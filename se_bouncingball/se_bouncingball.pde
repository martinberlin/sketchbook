/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */

import ddf.minim.*;
//Serial Peggy initialization
import processing.serial.*;
Serial peggyPort;
PImage peggyImage = new PImage(25,25);
byte [] peggyHeader = new byte[] { (byte)0xde, (byte)0xad, (byte)0xbe,(byte)0xef,1,0 };
byte [] peggyFrame = new byte[13*25];


int amp=400;
Minim minim;
AudioInput in;


void setup() {
  size(200, 200);
  noStroke();
  frameRate(30);
  smooth();
  // Set the starting position of the shape
  xpos = width/2;
  ypos = height/2;
  
  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn(Minim.STEREO, 625);
  
   String portName = Serial.list()[0];
   peggyPort = new Serial(this, portName, 115200);    // CHANGE_HERE
     
}
/**
 * Bounce code modified from the Processing samples and modified to display on a Peggy 2.. 
 
 BE SURE TO CHANGE THE SERIAL PORT NAME!! IN THE Setup() METHOD!

*/ 

int size = 60;       // Width of the shape
float xpos, ypos;    // Starting position of shape    

float xspeed = 2.8;  // Speed of the shape
float yspeed = 2.2;  // Speed of the shape

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom


void draw() 
{
  background(10);
  
  // Update the position of the shape
  xpos = xpos + ( xspeed * xdirection );
  ypos = ypos + ( yspeed * ydirection );
  
  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  if (xpos > width-size || xpos < 0) {
    xdirection *= -1;
  }
  if (ypos > height-size || ypos < 0) {
    ydirection *= -1;
  }

  // Draw the shape
  ellipse(xpos+size/2, ypos+size/2, size, size);

  renderToPeggy(grabDisplay());
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
