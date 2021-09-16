import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;

color displayColor;
boolean ch = true;
boolean rec = false;
String file = "../media/étos.mp3"; 
// Variables that define the "zones" of the spectrum
// For example, for bass, we take only the first 3% of the total spectrum
float specLow = 0.03;
float specMid = 0.4;
float specHi = 1;

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

float score;

// Softening value
float scoreDecreaseRate = 25;
int specSize;

int nb;
Flock flock;

float c;
//float hue = 0;
//int sat = 100;
//int bri = 65;

float a1 = 1.0;
float a2 = 1.0;
float a3 = 1.0;

float g = 0.9;
 
void setup()
{
  //Display in 3D on the entire screen
  //fullScreen(P3D);
  size(1500,900);
  frameRate(120);
  //colorMode(HSB);
  
  // Load the minim library
  minim = new Minim(this);
  // Load song
  song = minim.loadFile(file);
  // Create the FFT object to analyze the song
  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.linAverages(50);

  // One boid per frequency band
  specSize = fft.specSize();
  th1 = specSize*specLow;
  th2 = specSize*specMid;
  th3 = specSize*specHi;
  
  nb = (int)(specSize*specHi);
  //nb = fft.specSize(); // this should be used going by comment
  println(nb, song.bufferSize(), song.sampleRate(), specSize, th1, th2, th3);
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < nb*4; i++) {
    float w = random(width);     
    float h = random(height);

    Boid b = new Boid(w, h);
    flock.addBoid(b);
  }
  background(255);
  
  //Start the song
  song.play(0);
}
 
void draw()
{
  // To advance the song, one draw() for each "frame" of the song...
  fft.forward(song.mix);
  
  // Calculation of "scores" (power) for three categories of sound
  // First, save old values
  //oldScoreLow = scoreLow;
  //oldScoreMid = scoreMid;
  //oldScoreHi = scoreHi;
  
  // Reset values
  //scoreLow = 0;
  //scoreMid = 0;
  //scoreHi = 0;
  score = 0;
  
  //// Calculate the new "scores"
  //for(int i = 0; i < th1; i++)
  //  scoreLow += fft.getBand(i);
    
  //for(int i = (int)(th1); i < th2; i++)
  //  scoreMid += fft.getBand(i);

  //for(int i = (int)(th2); i < th3; i++)
  //  scoreHi += fft.getBand(i);

  //// To slow down the descent.
  //if (oldScoreLow - scoreDecreaseRate > scoreLow) {
  //  scoreLow = oldScoreLow - scoreDecreaseRate;
  //} 
  //if (oldScoreMid - scoreDecreaseRate > scoreMid) {
  //  scoreMid = oldScoreMid - scoreDecreaseRate;
  //}
  //if (oldScoreHi - scoreDecreaseRate > scoreHi) {
  //  scoreHi = oldScoreHi - scoreDecreaseRate;
  //}
  
  // Volume for all frequencies at this time, with the highest sounds higher.
  // This allows the animation to go faster for higher-pitched sounds, which is more noticeable
  //float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  //println(scoreLow, scoreMid, scoreHi);
  //println(scoreLow + scoreMid + scoreHi);
  
  // Subtle color of background
  if (ch) {
    //colorMode(RGB, 255, 255, 255);
    //background(scoreGlobal/10, 255-sat, bri);
    background(255-scoreLow/10, 255-scoreMid/10, 255-scoreHi/10);  
    //background(255-max(scoreGlobal, 50));
    //background(255);
  }
  
  for(int i = 0; i < specSize; i++)
    score += fft.getBand(i);
  
  //colorMode(HSB, 360, 100, 100);
  for(int i = 0; i < nb*4; i++)
  {
    Boid boid = flock.boids.get(i);
    // Value of the frequency band

    int j = i%specSize;
    float bandValue = fft.getBand(j);
    float a = fft.getAvg(int(float(j)/specSize*fft.avgSize()));

//    if (j<=specSize/3) {
//      c = scoreLow;
//      //bandValue /= a1;
//      //bandValue=0;
//    }
//    else if (j<=2*specSize/3) {
//      c = scoreMid;
//      //bandValue /= a2;
//      //bandValue=10;
//    }
//    else {
//      c = scoreHi;
//      //bandValue /= a3;
//      //bandValue=2;
//    }
    g = g*(1-g)*3.6;
    //println((g*255)%256, score);
    //displayColor = color(hue%360, sat, bri);
    displayColor = color(g*220, 220, score);
    //displayColor = color(c%256, sat, bri);
    //displayColor = color(scoreLow, 230, scoreHi);
    //displayColor = color(40+scoreLow*2, 120+scoreMid*2, 100+scoreHi*2);
    boid.custom(displayColor, bandValue, a);
  }
   flock.run();
   //hue+=0.05;
   
   //a1 = scoreLow/th1;
   //a2 = scoreMid/(th2-th1);
   //a3 = scoreHi/(th3-th2);
}

void keyPressed() {
  if (key==' ') {
    delay(200);
  }
  if (key=='c')
    ch = !ch;
}
