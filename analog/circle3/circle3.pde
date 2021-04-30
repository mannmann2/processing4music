import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;

//BeatDetect beat;
//float eRadius;
color displayColor;
boolean ch = true;
String file = "../media/And so.mp3"; 
// Variables that define the "zones" of the spectrum
// For example, for bass, we take only the first 3% of the total spectrum
float specLow = 0.03; // 3%
float specMid = 0.07;  // 12.5%
float specHi = 1.0;   // 20%

// This leaves 64% of the possible spectrum that will not be used.
// These values are usually too high for the human ear anyway.

float th1, th2, th3;
// Scoring values for each zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Previous value, to soften the reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

//float hue = 0;
//int sat = 255;
//int bri = 200;

// Softening value
float scoreDecreaseRate = 25;
int specSize;

// Cubes that appear in space
Circle[] cubes;
float val;
 
void setup()
{
  //Display in 3D on the entire screen
  fullScreen(P3D);
  frameRate(60);
  //size(2000, 1000);
 
  // Load the minim library
  minim = new Minim(this);
  // Load song
  song = minim.loadFile(file, 1024);
  // Create the FFT object to analyze the song
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  // One circle per frequency band
  specSize = fft.specSize();
  th1 = specSize*specLow;
  th2 = specSize*specMid;
  th3 = specSize*specHi;
  println(specSize);
  
  cubes = new Circle[specSize];
  
  // Create all objects
  for (int i = 0; i < specSize; i++) {
   cubes[i] = new Circle(i); 
  }

  // Black background
  background(0);
   
  //Start the song
  song.play(20900);
  //song.play(0);
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  //beat = new BeatDetect();
  
  //ellipseMode(RADIUS);
  //eRadius = 60;
  //colorMode(HSB);
  noStroke();
}
 
void draw()
{
  // To advance the song, one draw() for each "frame" of the song...
  fft.forward(song.mix);
  
  // Calculation of "scores" (power) for three categories of sound
  // First, save old values
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  // Reset values
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
  
  // Calculate the new "scores"
  for(int i = 0; i < th1; i++)
    scoreLow += fft.getBand(i);
    
  for(int i = (int)(th1); i < th2; i++)
    scoreMid += fft.getBand(i);

  for(int i = (int)(th2); i < th3; i++)
    scoreHi += fft.getBand(i);

  // To slow down the descent.
  if (oldScoreLow - scoreDecreaseRate > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid - scoreDecreaseRate > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi - scoreDecreaseRate > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  // Volume for all frequencies at this time, with the highest sounds higher.
  // This allows the animation to go faster for higher-pitched sounds, which is more noticeable
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  println(scoreLow, scoreMid, scoreHi);
  //println(scoreLow + scoreMid + scoreHi);
  // Subtle color of background
  if (ch)
    background(0);
    //background(scoreLow/100, scoreMid/100, scoreHi/100);

  // The color is represented as: red for bass, green for medium sounds and blue for high.
  // Opacity is determined by the volume of the tape and the overall volume.
  
  if (scoreLow < 40 && scoreMid < 40 && scoreHi < 40) {
      scoreLow += 120;
      scoreMid += 60;
      scoreHi += 80;
    }
  
  // Circle for each frequency band
  for(int i = 0; i < specSize; i++)
  {
    // Value of the frequency band
    float bandValue = fft.getBand(i);
    //println(scoreLow, scoreMid, scoreHi, abs(cubes[i].prev - bandValue));

    if (i < th1) {
      displayColor = color(scoreLow, scoreMid*0.8, scoreHi*0.5); // THIS CAN BE PLAYED WITH
    }
    else if (i < th2) { 
      displayColor = color(scoreLow*0.8, scoreMid, scoreHi*0.8); // THIS CAN BE PLAYED WITH
    }
    else {
      displayColor = color(scoreLow*0.5, scoreMid*0.8, scoreHi); // THIS CAN BE PLAYED WITH
    }
    //displayColor = color(bandValue%255, sat, bri);
    
    //if (!cubes[i].start)
    //  val = 5;
    //else
      val = 5;
    if (bandValue - cubes[i].prev > val)
      cubes[i].display(displayColor, bandValue, scoreGlobal);
    else if (cubes[i].start)
      cubes[i].scale(displayColor, scoreGlobal/50);
      
    cubes[i].setPrev(bandValue);
  }
  //hue+=0.1;
}

void keyPressed() {
  if (key==' ') {
    delay(2000);
  }
  if (key=='c')
    ch = !ch;
}
