//with sharp turn and stop
// base of color tracking from processing 

import processing.io.*;
import gohai.glvideo.*;
GLCapture video;

color trackColor;

void setup() {
  size(320, 220, P2D);

  video = new GLCapture(this);

  video.start();

  trackColor = color(255, 0, 0);

  GPIO.pinMode(4, GPIO.OUTPUT);
  GPIO.pinMode(14, GPIO.OUTPUT);
  GPIO.pinMode(17, GPIO.OUTPUT);
  GPIO.pinMode(18, GPIO.OUTPUT);
}

void draw() {
  background(0);
  if (video.available()) {
    video.read();
  }

  video.loadPixels();
  image(video, 0, 0);

  float worldRecord = 500; 
  int closestX = 0;
  int closestY = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);


      float d = dist(r1, g1, b1, r2, g2, b2); 
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }

  if (worldRecord < 10) { 

    fill(trackColor);
    strokeWeight(2.0);
    stroke(100, 0, 0);
    rect(closestX, closestY, 10, 10);
    println(closestX, closestY);
    //-------------------------------------------------------------------------------------decision---------------------------

    if ((closestY>170) &&  (closestX>140) && (closestX<200))
    {
      stp();
      println(" STOP");
    } else if ((closestX==150) && (closestY==100))
    {
      stp();
      println("STOP    ");
    } else if (closestX<140)//turn left
    {
      right();
      println("Right");
    } else if (closestX>200)
    {
      left();
      println(" Left");
    } else if (closestY<170)
    {
      fwd();
      delay(10);
      println("Go Frwd");
    } else
    {
      stp();
    }
  }
}

void mousePressed() {

  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}























void sright () {
  GPIO.digitalWrite(4, GPIO.HIGH);
  GPIO.digitalWrite(14, GPIO.LOW);
  GPIO.digitalWrite(17, GPIO.LOW);
  GPIO.digitalWrite(18, GPIO.HIGH);
  delay(10);
}
void sleft()
{
  GPIO.digitalWrite(4, GPIO.LOW);
  GPIO.digitalWrite(14, GPIO.HIGH);
  GPIO.digitalWrite(17, GPIO.HIGH);
  GPIO.digitalWrite(18, GPIO.LOW);
  delay(10);
}
void right()
{
  GPIO.digitalWrite(4, GPIO.LOW);
  GPIO.digitalWrite(14, GPIO.LOW);
  GPIO.digitalWrite(17, GPIO.HIGH);
  GPIO.digitalWrite(18, GPIO.LOW);
  delay(10);
}
void left()
{
  GPIO.digitalWrite(4, GPIO.HIGH);
  GPIO.digitalWrite(14, GPIO.LOW);
  GPIO.digitalWrite(17, GPIO.LOW);
  GPIO.digitalWrite(18, GPIO.LOW);
  delay(10);
}
void back() {
  GPIO.digitalWrite(4, GPIO.LOW);
  GPIO.digitalWrite(14, GPIO.HIGH);
  GPIO.digitalWrite(17, GPIO.LOW);
  GPIO.digitalWrite(18, GPIO.HIGH);
  delay(10);
} 
void stp() {
  GPIO.digitalWrite(4, GPIO.HIGH);
  GPIO.digitalWrite(14, GPIO.HIGH);
  GPIO.digitalWrite(17, GPIO.HIGH);
  GPIO.digitalWrite(18, GPIO.HIGH);
  delay(10);
}
void fwd() {
  GPIO.digitalWrite(4, GPIO.HIGH);
  GPIO.digitalWrite(14, GPIO.LOW);
  GPIO.digitalWrite(17, GPIO.HIGH);
  GPIO.digitalWrite(18, GPIO.LOW);
  delay(10);
}
