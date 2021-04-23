import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

BeatDetect beat;
float eRadius;

color displayColor;
boolean rec = false;
String file = "../media/untitled.mp3"; 
// Variables that define the "zones" of the spectrum
// For example, for bass, we take only the first 3% of the total spectrum
float specLow = 0.03; // 3%
float specMid = 0.08;  // 12.5%
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

float hue = 0;
int sat = 255;
int bri = 200;

// Softening value
float scoreDecreaseRate = 25;

// Cubes that appear in space
int nbCubes; // = 120;
Cube[] cubes;

 
void setup()
{
  //Display in 3D on the entire screen
  fullScreen(P3D);
  //size(2000, 2000);
  frameRate(60);
 
  // Load the minim library
  minim = new Minim(this);
  // Load song
  song = minim.loadFile(file, 512);
  // Create the FFT object to analyze the song
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  // One cube per frequency band
  //nbCubes = (int)(fft.specSize()*specHi);
  nbCubes = fft.specSize(); // this should be used going by comment
  cubes = new Cube[nbCubes];
  println(nbCubes);
  th1 = nbCubes*specLow;
  th2 = nbCubes*specMid;
  th3 = nbCubes*specHi;

  // Create all objects
  // Create cubic objects
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(i); 
  }

  // Black background
  background(0);
   
  //Start the song
  song.play(0);
  
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
  
  ellipseMode(RADIUS);
  eRadius = 60;
  
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
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  // Volume for all frequencies at this time, with the highest sounds higher.
  // This allows the animation to go faster for higher-pitched sounds, which is more noticeable
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  //println(scoreLow, scoreMid, scoreHi);
  //println(scoreLow + scoreMid + scoreHi);
  // Subtle color of background
  background(scoreLow/100, scoreMid/100, scoreHi/100);
  
  //beat.detect(song.mix);
  //float a = map(eRadius, 20, 80, 60, 255);
  //colorMode(HSB);
  //fill(hue, sat, bri, a);
  //if ( beat.isOnset() ) eRadius = 80;
  //ellipse(width/2, height/2, eRadius, eRadius);
  //eRadius *= 0.95;
  //if ( eRadius < 20 ) eRadius = 20;

  // The color is represented as: red for bass, green for medium sounds and blue for high.
  // Opacity is determined by the volume of the tape and the overall volume.
      
  // Cube for each frequency band
  for(int i = 0; i < nbCubes; i++)
  {
    // Value of the frequency band
    float bandValue = fft.getBand(i);
    
    //displayColor = color(bandValue%255, sat, bri);
    if (i < th1) {
      displayColor = color(scoreLow, scoreMid*0.8, scoreHi*0.5); // THIS CAN BE PLAYED WITH
      //print("A ");
    }
    else if (i < th2) { 
      displayColor = color(scoreLow*0.8, scoreMid, scoreHi*0.8); // THIS CAN BE PLAYED WITH
      //print("B ");
    }
    else {
      //print("C ");
      displayColor = color(scoreLow*0.5, scoreMid*0.8, scoreHi); // THIS CAN BE PLAYED WITH
    }
    //print(displayColor);
     //displayColor = color(scoreLow*0.9, scoreMid*0.9, scoreHi*0.9, bandValue*400); // THIS CAN BE PLAYED WITH
    cubes[i].display(displayColor, bandValue, scoreGlobal);
  }
  
  hue+=0.1;
}

void keyPressed() {
  if (key==' ') {
    delay(2000);
  }
  //if (key=='c')
  //  ch = !ch;
}
