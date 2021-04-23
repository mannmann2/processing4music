import processing.sound.*;

// Declare the sound source and FFT analyzer variables
SoundFile sample;
Waveform waveform;
FFT fft;

// Define how many FFT bands to use (this needs to be a power of two)
int bands = 512;
boolean ch = true;
// Define a smoothing factor which determines how much the spectrums of consecutive
// points in time should be combined to create a smoother visualisation of the spectrum.
// A smoothing factor of 1.0 means no smoothing (only the data from the newest analysis
// is rendered), decrease the factor down towards 0.0 to have the visualisation update
// more slowly, which is easier on the eye.
float smoothingFactor = 0.5;

// Create a vector to store the smoothed spectrum data in
float[] sum = new float[bands]; 
// Declare a drawing variable for calculating the width of the 
float barWidth;

// Variables for drawing the spectrum:
// Declare a scaling factor for adjusting the height of the rectangles
int scale = 20;
int samples = 1000;

float specLow = 0.015; // 3%
float specMid = 0.1;  // 12.5%
float specHi = 0.3;   // 20%
// This leaves 64% of the possible spectrum that will not be used.
// These values are usually too high for the human ear anyway.

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

public void setup() {
  size(1280, 720);
  //fullScreen(P3D);
  frameRate(60);
  //background(125, 255, 125);
  background(255);
  // Calculate the width of the rects depending on how many bands we have
  barWidth = width/float(bands);

  // Load and play a soundfile and loop it.
  sample = new SoundFile(this, "../media/untitled.mp3");
  sample.play();

  // Create the FFT analyzer and connect the playing soundfile to it.
  waveform = new Waveform(this, samples);
  waveform.input(sample);
  //fft = new FFT(this, bands);
  //fft.input(sample);
  //cubes = new Cube[bands];
  //for (int i = 0; i < bands; i++) {
  // cubes[i] = new Cube(i); 
  //}
  colorMode(HSB);
}

public void draw() {
  if (ch)
    background(255);
  // Set background color, noStroke and fill color
  //background(125, 255, 125);

  // Perform the analysis
  //fft.analyze();
  
  //oldScoreLow = scoreLow;
  //oldScoreMid = scoreMid;
  //oldScoreHi = scoreHi;
  
  //// Reset values
  //scoreLow = 0;
  //scoreMid = 0;
  //scoreHi = 0;
  
  //int specSize = bands;
  //// Calculate the new "scores"
  //for(int i = 0; i < specSize*specLow; i++)
  //  scoreLow += fft.spectrum[i];
    
  //for(int i = (int)(specSize*specLow); i < specSize*specMid; i++)
  //  scoreMid += fft.spectrum[i];

  //for(int i = (int)(specSize*specMid); i < specSize*specHi; i++)
  //  scoreHi += fft.spectrum[i];
    
  //background(scoreLow/100, scoreMid/100, scoreHi/100);

  ////// To slow down the descent.
  ////if (oldScoreLow > scoreLow) {
  ////  scoreLow = oldScoreLow - scoreDecreaseRate;
  ////}
  
  ////if (oldScoreMid > scoreMid) {
  ////  scoreMid = oldScoreMid - scoreDecreaseRate;
  ////}
  
  ////if (oldScoreHi > scoreHi) {
  ////  scoreHi = oldScoreHi - scoreDecreaseRate;
  ////}
  
  //// Volume for all frequencies at this time, with the highest sounds higher.
  //// This allows the animation to go faster for higher-pitched sounds, which is more noticeable
  //float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  //println(scoreLow, scoreMid, scoreHi);

  //for (int i = 0; i < bands; i++) {
  //  // Smooth the FFT spectrum data by smoothing factor
  //  sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
  //  cubes[i].display(scoreLow, scoreMid, scoreHi, sum[i]*height, scoreGlobal);
    
  //  // Draw the rectangles, adjust their height using the scale factor
  //  fill(255, 0, 150);
  //  noStroke();
  //  rect(i*barWidth, height, barWidth, -sum[i]*height*scale);
  //}
  
  //stroke(255);
  strokeWeight(0.8);
  //line(bands*specLow*barWidth, 0, bands*specLow*barWidth, height);
  //line(bands*(specLow+specMid)*barWidth, 0, bands*(specLow+specMid)*barWidth, height);
  //line(bands*(specLow+specMid+specHi)*barWidth, 0, bands*(specLow+specMid+specHi)*barWidth, height);
  
  noStroke();
  waveform.analyze();
  

  
  
  //fill(hue%255, 100, 255, 100);
  
  //fill(0);
  //beginShape();
  //for(int i = 0; i < samples; i++){
  //  // Draw current data of the waveform
  //  // Each sample in the data array is between -1 and +1 
  //  vertex(
  //    map(i, 0, samples, 0, width),
  //    map(waveform.data[i], -1, 1, 0, height)
  //  );
  //}
  //endShape();
  
  fill((210+hue)%255, sat, bri, 100);
  //stroke(40, 40, 255);
  beginShape();
  for(int i = 0; i < samples/3; i++){
    // Draw current data of the waveform
    // Each sample in the data array is between -1 and +1 
    vertex(
      map(i, 0, samples/3, 0, width),
      map(waveform.data[i], -1, 1, 0, height)
    );
  }
  endShape();
  
  fill((125+hue)%255, sat, bri, 100);
  //stroke(40, 255, 40);
  beginShape();
  for(int i = samples/3; i < 2*samples/3; i++){
    // Draw current data of the waveform
    // Each sample in the data array is between -1 and +1 
    vertex(
      map(i, samples/3, 2*samples/3, 0, width),
      map(waveform.data[i], -1, 1, 0, height)
    );
  }
  endShape();
  
  fill((40+hue)%255, sat, bri, 100);
  //stroke(255, 40,40);
  beginShape();
  for(int i = 2*samples/3; i < samples; i++){
    // Draw current data of the waveform
    // Each sample in the data array is between -1 and +1 
    vertex(
      map(i, 2*samples/3, samples, 0, width),
      map(waveform.data[i], -1, 1, 0, height)
    );
  }
  endShape();
  
  hue+=0.01;
  println(hue);
}

void keyPressed() {
  if (key==' ') {
    delay(2000);
  }
  if (key=='c')
    ch = !ch;
}
