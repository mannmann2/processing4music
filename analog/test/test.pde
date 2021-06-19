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
float specLow = 0.04; // 3%
float specMid = 0.2;  // 3%
float specHi = 1;   // 20%
// This leaves 65% of the possible spectrum that will not be used.
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

float c;
float hue = 0;
int sat = 255;
int bri = 173;

// Softening value
float scoreDecreaseRate = 10;

// Cubes that appear in space
int nbCubes;
Cube[] cubes;

int specSize;

float a1 = 1.0;
float a2 = 1.0;
float a3 = 1.0;

String windowName = "Rectangualr Window";

void setup()
{
  //Display in 3D on the entire screen
  //fullScreen(P3D);
  size(2100, 1350, P3D);
  frameRate(60);
 
  // Load the minim library
  minim = new Minim(this);
  // Load song
  song = minim.loadFile(file, 512);
  // Create the FFT object to analyze the song
  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.linAverages(50);
  //fft.logAverages(22, 5);

  specSize = fft.specSize();
  th1 = specSize*specLow;
  th2 = specSize*specMid;
  th3 = specSize*specHi;
  
  // One cube per frequency band
  nbCubes = (int)(specSize*specHi);
  //nbCubes = specSize; // this should be used going by comment
  cubes = new Cube[nbCubes];
  println(nbCubes);

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
  
  textFont(createFont("Arial", 20));
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
  
  // Subtle color of background
  //background(scoreLow/100, scoreMid/100, scoreHi/100);  
  colorMode(RGB);
  background(255-scoreLow/100, 255-scoreMid/100, 255-scoreHi/100);

  //println(scoreLow, scoreMid, scoreHi);
  //println(scoreLow + scoreMid + scoreHi);
  
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
     
  //a1 = scoreLow/th1;
  //a2 = scoreMid/(th2-th1);
  //a3 = scoreHi/(th3-th2);
  
  colorMode(HSB);
  // Cube for each frequency band
  for(int i = 0; i < nbCubes; i++)
  {
    // Value of the frequency band
    float bandValue = fft.getBand(i);
    if (i<=th1) {
      c = hue+scoreLow;
      //bandValue /= a1;
      //bandValue=0;
    }
    else if (i<=th2) {
      c = hue+scoreMid+120;
      //bandValue /= a2;
      //bandValue=10;
    }
    else {
      c = hue+scoreHi;
      //bandValue /= a3;
      //bandValue=2;
    }
    float a = fft.getAvg(int(float(i)/specSize*fft.avgSize()));
    
    //if (cubes[i].prev - bandValue > 5)
    //  bandValue = cubes[i].prev - 5;
      
    //bandValue = min(bandValue, 20);
    
    //if (i < th1) {
    //  displayColor = color(scoreLow, scoreMid*3, scoreHi*2); // THIS CAN BE PLAYED WITH
    //}
    //else if (i < th2) { 
    //  displayColor = color(scoreLow*0.8, scoreMid*3, scoreHi*2); // THIS CAN BE PLAYED WITH
    //}
    //else {
    //  displayColor = color(scoreLow*0.5, scoreMid*3, scoreHi*2); // THIS CAN BE PLAYED WITH
    //}
    displayColor = color(c%256, sat, bri);    
    //displayColor = color(scoreLow*0.9, scoreMid*0.9, scoreHi*0.9, bandValue*500); // THIS CAN BE PLAYED WITH
    //displayColor = color(40+scoreLow*2, 120+scoreMid*2, 100+scoreHi*2, bandValue*500); // THIS CAN BE PLAYED WITH
    //displayColor = color(scoreLow*0.9, scoreMid*0.9, scoreHi*0.9); // THIS CAN BE PLAYED WITH
    //displayColor = color(90+hue, sat, bri);
    cubes[i].display(displayColor, bandValue, scoreGlobal);
    
    stroke(0);
    rect(100 + i*5, height-300, 5, -bandValue*40);
    rect(100 + i*5, height-300, 5, a*40);
  }
  
  //float centerFrequency = 0;
  //float rem = 100;
  //for(int i = 0; i < fft.avgSize(); i++) {
  //  centerFrequency    = fft.getAverageCenterFrequency(i);
  //  // how wide is this average in Hz?
  //  float averageWidth = fft.getAverageBandWidth(i);   
    
  //  // we calculate the lowest and highest frequencies
  //  // contained in this average using the center frequency
  //  // and bandwidth of this average.
  //  float lowFreq  = centerFrequency - averageWidth/2;
  //  float highFreq = centerFrequency + averageWidth/2;
    
  //  // freqToIndex converts a frequency in Hz to a spectrum band index
  //  // that can be passed to getBand. in this case, we simply use the 
  //  // index as coordinates for the rectangle we draw to represent
  //  // the average.
  //  int xl = (int)fft.freqToIndex(lowFreq);
  //  int xr = (int)fft.freqToIndex(highFreq);
    
  //  // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
  //  rect(rem, height-200, xr, fft.getAvg(i)*10);
  //  rem = rem+xr;
  //}
  //fill(
  text("The window being used is: " + windowName, 3*width/4, height-200);

  hue+=0.1;
}

void keyPressed() {
  if (key==' ') {
    delay(2000);
  }
  //if (key=='c')
  //  ch = !ch;
}

void keyReleased()
{
  WindowFunction newWindow = FFT.NONE;
  
  if ( key == '1' ) 
  {
    newWindow = FFT.BARTLETT;
  }
  else if ( key == '2' )
  {
    newWindow = FFT.BARTLETTHANN;
  }
  else if ( key == '3' )
  {
    newWindow = FFT.BLACKMAN;
  }
  else if ( key == '4' )
  {
    newWindow = FFT.COSINE;
  }
  else if ( key == '5' )
  {
    newWindow = FFT.GAUSS;
  }
  else if ( key == '6' )
  {
    newWindow = FFT.HAMMING;
  }
  else if ( key == '7' )
  {
    newWindow = FFT.HANN;
  }
  else if ( key == '8' )
  {
    newWindow = FFT.LANCZOS;
  }
  else if ( key == '9' )
  {
    newWindow = FFT.TRIANGULAR;
  }

  fft.window( newWindow );
  windowName = newWindow.toString();

}
