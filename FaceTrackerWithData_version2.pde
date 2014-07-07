// FaceTrackerWithData
//
// a face tracking system using 
// Kyle McDonald's FaceOSC
// https://github.com/kylemcdonald/ofxFaceTracker
// codes adapted from 2012 Dan Wilcox danomatika.com
// developed by Lois Yang 
// for the Social Computing Lab REU program, 2014 Summer Internship.
//
// To use this program, 
// first download the oscP5 library from 
// http://www.sojamo.de/libraries/oscP5/

import oscP5.*;
OscP5 oscP5;

// TIME
int year = year();
int month = month();
int day = day();
int hour;
int minute;
int second;
int millis;
String currentTime;

// ALWAYS SENT:FOUND
int found;

// SENT WHEN A FACE IS TRACKED
float poseScale;
PVector posePosition = new PVector();
PVector poseOrientation = new PVector();

// gesture
float mouthHeight;
float mouthWidth;
float eyeLeft;
float eyeRight;
float eyebrowLeft;
float eyebrowRight;
float jaw;
float nostrils;

PrintWriter dataFile;

void setup() {
  size(640, 480);
  frameRate(120);

  dataFile = createWriter("data.txt");
  dataFile.println(day+"/"+month+"/"+year);
  dataFile.println("timestamp\t"+"FaceTracked\t"+"mouthHeight\t");

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseScale", "/pose/scale");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");

}

void draw() {  
  background(255);
  stroke(0);

//determine the current time stamp
  hour = hour();
  minute = minute();
  second = second();
  millis = millis();
  currentTime = hour+":"+minute+" "+second+"s"+millis+"ms";
  
  if(found == 0){
    dataFile.println(currentTime+"\t"+found);
  }
  else if(found > 0) {
    dataFile.println(currentTime+"\t"+found + "\t" + mouthHeight);
    translate(posePosition.x, posePosition.y);
    scale(poseScale);
    noFill();
    ellipse(-20, eyeLeft * -9, 20, 7);
    ellipse(20, eyeRight * -9, 20, 7);
    ellipse(0, 20, mouthWidth* 3, mouthHeight * 3);
    ellipse(-5, nostrils * -1, 7, 3);
    ellipse(5, nostrils * -1, 7, 3);
    rectMode(CENTER);
    fill(0);
    rect(-20, eyebrowLeft * -5, 25, 5);
    rect(20, eyebrowRight * -5, 25, 5);
  }
}

// OSC CALLBACK FUNCTIONS


public void found(int i) {
  println("found: " + i);
  found = i;
}

public void poseScale(float s) {
  println("scale: " + s);
  poseScale = s;
}

public void posePosition(float x, float y) {
  println("pose position\tX: " + x + " Y: " + y );
  posePosition.set(x, y, 0);
}

public void poseOrientation(float x, float y, float z) {
  println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.set(x, y, z);
}

public void mouthWidthReceived(float w) {
  println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  println("mouth height: " + h);
  mouthHeight = h;
}

public void eyeLeftReceived(float f) {
  println("eye left: " + f);
  eyeLeft = f;
}

public void eyeRightReceived(float f) {
  println("eye right: " + f);
  eyeRight = f;
}

public void eyebrowLeftReceived(float f) {
  println("eyebrow left: " + f);
  eyebrowLeft = f;
}

public void eyebrowRightReceived(float f) {
  println("eyebrow right: " + f);
  eyebrowRight = f;
}

public void jawReceived(float f) {
  println("jaw: " + f);
  jaw = f;
}

public void nostrilsReceived(float f) {
  println("nostrils: " + f);
  nostrils = f;
}

// all other OSC messages end up here
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.isPlugged() == false) {
    println("UNPLUGGED: " + theOscMessage);
  }
}

void keyPressed() {
  if (key=='q' || key == 'Q'){
      // Writes the remaining data to the file
      // Then, finishes the file 
      dataFile.flush();  
      dataFile.close(); 

      // Stops the program
      exit();  
  }
}
