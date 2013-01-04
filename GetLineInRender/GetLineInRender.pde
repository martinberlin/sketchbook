/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */
 
PImage a;  // Declare variable "a" of type PImage
import processing.serial.*;
import ddf.minim.*;

int amp=400;
Minim minim;
AudioInput in;


Serial peggyPort;
PImage peggyImage = new PImage(25,25);
byte [] peggyHeader = new byte[] 
    { (byte)0xde, (byte)0xad, (byte)0xbe,(byte)0xef,1,0 };
byte [] peggyFrame = new byte[13*25];

boolean SerialEnabled;      // Set to "false" until we have a successful connection.



void setup() {
  size(250, 250,P2D);
  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn(Minim.STEREO, 625);
   String portName = Serial.list()[0];
   peggyPort = new Serial(this, portName, 115200);    // CHANGE_HERE
     
  //noLoop();  // Makes draw() only run once
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  //image(a, 0, 0); 
  // Displays the image at point (100, 0) at half of its size
  PImage img = createImage(25, 25, ARGB);
  int i=0;int br;
  
  for(int x=0; x < 25;x++) {
    for(int y=0; y < 25; y++) {
      
      br=int (in.left.get(y)*amp) + int(in.right.get(x)*amp);
      //print(in.left.get(x+y)*300  );print (" " );
      
      img.pixels[i] = br; 
      
      i++;
     }
  }
  
 // print (mouseX);
  

 renderToPeggy(img);

}


// render a PImage to the Peggy by transmitting it serially.  
// If it is not already sized to 25x25, this method will 
// create a downsized version to send...
void renderToPeggy(PImage srcImg)
{
  int idx = 0;
  
  PImage destImg = srcImg; 
    
  // iterate over the image, pull out pixels and 
  // build an array to serialize to the peggy
  for (int y =0; y < 25; y++)
  {
    byte val = 0;
    for (int x=0; x < 25; x++)
    {
     // print (x+" "+y+" ");
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
   
  peggyPort.write(peggyHeader);
  peggyPort.write(peggyFrame); 
}


