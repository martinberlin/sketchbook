/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */
 HScrollbar hs1;
PImage a;  // Declare variable "a" of type PImage
import processing.serial.*;
import ddf.minim.*;

float amp=10;
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
     hs1 = new HScrollbar(10, 20, width-20, 10, 3*5+1);
  //noLoop();  // Makes draw() only run once
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  //image(a, 0, 0); 
  // Displays the image at point (100, 0) at half of its size
  PImage img = createImage(25, 25, ARGB);
  int i=0;int br;
  float amp = hs1.getPos()-10;
  
  //print (amp);print (" ");
  
   hs1.update();
  hs1.display();
  
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

class HScrollbar
{
  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // x position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (int xp, int yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if(over()) {
      over = true;
    } else {
      over = false;
    }
    if(mousePressed && over) {
      locked = true;
    }
    if(!mousePressed) {
      locked = false;
    }
    if(locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if(abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  boolean over() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
    mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    fill(255);
    rect(xpos, ypos, swidth, sheight);
    if(over || locked) {
      fill(153, 102, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
