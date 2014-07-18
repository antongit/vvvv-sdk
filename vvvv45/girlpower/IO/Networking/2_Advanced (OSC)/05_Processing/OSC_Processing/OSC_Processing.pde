// vvvv talks to Processing via OSC.
// Click the mouse in the window. vvvv will reply. 
//
// vvvv patch can be found in \girlpower\IO\Networking\2_Advanced (OSC) 
// of the vvvv distribution, which can be downloaded here:
// vvvv.org/downloads
//
// This sketch is adapted version of these examples:
// http://www.sojamo.de/libraries/oscp5/examples/oscP5message/oscP5message.pde
// http://www.sojamo.de/libraries/oscp5/examples/oscP5oscArgument/oscP5oscArgument.pde

// **********************
//
// Add the OSC library: 
// 1. Sketch > Import Library > Add Library ...
// 2. Type OSC and choose oscP5
//
// **********************

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

PFont f;
int firstValue;
float secondValue;
String thirdValue="";
boolean data;

void setup() {
  size(400,400);
  
  f = createFont("Arial",16,true);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number.*/
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);
}

void draw() {
  background(0); 
  
  fill(150);
  textFont(f,15);
  text("Click to say hello to vvvv", 10, 120);
  
  
  /* if the oscEvent() function (see below) receives the OSC data it will be drawn */
  fill(255);
  if (data)
  {
    textFont(f,10);
    text(firstValue + " " + secondValue, 10,150);
    textFont(f,15);
    text(thirdValue, 10, 170);
  }
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  
  /* this is the address */
  OscMessage myMessage = new OscMessage("/hello");
  
  myMessage.add(42); /* add an int to the osc message */
  myMessage.add(random(1)); /* add a float to the osc message */
  myMessage.add("Hello vvvv, I'm Processing."); /* add a string to the osc message */
  myMessage.add(new byte[] {0x00, 0x01, 0x10, 0x20}); /* add a byte blob to the osc message */
  myMessage.add(new int[] {1,2,3,4}); /* add an int array to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  /* get and parse the arguments */
  firstValue = theOscMessage.get(0).intValue();
  secondValue = theOscMessage.get(1).floatValue();
  thirdValue = theOscMessage.get(2).stringValue();
  
  data=true;
}

