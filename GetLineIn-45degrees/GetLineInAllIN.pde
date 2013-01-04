import ddf.minim.*;
import processing.serial.*;

Minim minim;
AudioInput in;
Serial peggyPort;
PImage peggyImage = new PImage(25,25);
byte [] peggyHeader = new byte[] 
    { (byte)0xde, (byte)0xad, (byte)0xbe,(byte)0xef,1,0 };
byte [] peggyFrame = new byte[13*25];




void setup()
{
   String portName = Serial.list()[0];
   peggyPort = new Serial(this, portName, 115200);    // CHANGE_HERE
     

  minim = new Minim(this);  
  // get a line in from Minim, default bit depth is 16
  // * getLineIn(int type, int bufferSize, float sampleRate, int bitDepth)  
  in = minim.getLineIn(Minim.STEREO, 50,24000,16);
  
}

void draw() { 
  int idx = 0;
  int i = 0;int br = 0;
  int v = 0;
 byte val = 0;
  
  // build an array to serialize to the peggy
  for (int y =0; y < 25; y++)
  {

    for (int x=0; x < 25; x++)
    {
      br=int( in.left.get(x+y) *256);
       if (br<0) br=br*br;
       
      print (" "+ br );
    
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
