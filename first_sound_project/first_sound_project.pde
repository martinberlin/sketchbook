/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/14467*@* */

import ddf.minim.*;
//Serial Peggy initialization
import processing.serial.*;
Serial peggyPort;
PImage peggyImage = new PImage(25,25);
byte [] peggyHeader = new byte[] { (byte)0xde, (byte)0xad, (byte)0xbe,(byte)0xef,1,0 };
byte [] peggyFrame = new byte[13*25];

Minim minim;
AudioInput in;

void setup()
{
  size(200, 200, P2D);
  frameRate(20);
  minim = new Minim(this);
 // minim.debugOn();
  
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);
  
 String portName = Serial.list()[0];
  peggyPort = new Serial(this, portName, 115200);    // CHANGE_HERE
  
}

void draw()
{
  background(0);
  
  // draw the waveforms
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
   fill(255,255,255,255);
  
    rect(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    rect(i, 250 + in.right.get(i)*50, i+1, 50 + in.right.get(i+1)*50);
    fill(255,255,255);
  //  rect(i, 400 + in.right.get(i)*200, i+1, 50 + in.right.get(i+1)*200);
    //rect(i, 150 + in.right.get(i)*200, i+1, 50 + in.right.get(i+1)*200);
  }

  
  renderToPeggy(grabDisplay());
}


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  
  super.stop();
}

// this method creates a PImage that is a copy 
// of the current processing display.
// Its very crude and inefficient, but it works.
PImage grabDisplay()
{
  PImage img = createImage(width, height, ARGB);
  loadPixels();
  arraycopy(pixels, 0, img.pixels, 0, width * height);
  return img;
}

// render a PImage to the Peggy by transmitting it serially.  
// If it is not already sized to 25x25, this method will 
// create a downsized version to send...
void renderToPeggy(PImage srcImg)
{
  int idx = 0;
  
  PImage destImg = peggyImage;
  if (srcImg.width != 25 || srcImg.height != 25)
    destImg.copy(srcImg,0,0,srcImg.width,srcImg.height,0,0,destImg.width,destImg.height);
  else
    destImg = srcImg;
    
  // iterate over the image, pull out pixels and 
  // build an array to serialize to the peggy
  for (int y =0; y < 25; y++)
  {
    byte val = 0;
    for (int x=0; x < 25; x++)
    {
      color c = destImg.get(x,y);
      int br = ((int)brightness(c))>>4;
      if (x % 2 ==0)
        val = (byte)br;
      else
      {
        val = (byte) ((br<<4)|val);
        peggyFrame[idx++]= val;
      }
    }
    peggyFrame[idx++]= val;  // write that one last leftover half-byte
  }
  
  // send the header, followed by the frame
  peggyPort.write(peggyHeader);
  peggyPort.write(peggyFrame);
  //no way to flush()?  Apparently this is done by write()
}
