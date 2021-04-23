
import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;

boolean rec = false;
String file = "../media/untitled.mp3"; 
// Variables that define the "zones" of the spectrum
// For example, for bass, we take only the first 3% of the total spectrum
float specLow = 0.05; // 3%
float specMid = 0.02;  // 12.5%
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

// Softening value
float scoreDecreaseRate = 25;

// Cubes that appear in space
int nbCubes; // = 120;
//Cube[] cubes;

 
void setup()
{
  //Display in 3D on the entire screen
  fullScreen(P3D);
  frameRate(60);
 
  // Load the minim library
  minim = new Minim(this);
  // Load song
  song = minim.loadFile(file);
  // Create the FFT object to analyze the song
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  // One cube per frequency band
  //nbCubes = (int)(fft.specSize()*specHi);
  nbCubes = fft.specSize(); // this should be used going by comment
  //cubes = new Cube[nbCubes];
  println(nbCubes, song.bufferSize(), song.sampleRate(), fft.specSize());

  // Create all objects
  // Create cubic objects
  //for (int i = 0; i < nbCubes; i++) {
  // cubes[i] = new Cube(i); 
  //}

  // Black background
  background(0);
  
  //Start the song
  song.play(0);
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
  
  int specSize = fft.specSize();
  // Calculate the new "scores"
  for(int i = 0; i < specSize*specLow; i++)
    scoreLow += fft.getBand(i);
    
  for(int i = (int)(specSize*specLow); i < specSize*specMid; i++)
    scoreMid += fft.getBand(i);

  for(int i = (int)(specSize*specMid); i < specSize*specHi; i++)
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
  
  

  // The color is represented as: red for bass, green for medium sounds and blue for high.
  // Opacity is determined by the volume of the tape and the overall volume.
      
  // Cube for each frequency band
  //for(int i = 0; i < nbCubes; i++)
  //{
  //  // Value of the frequency band
  //  float bandValue = fft.getBand(i);
  //  cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
