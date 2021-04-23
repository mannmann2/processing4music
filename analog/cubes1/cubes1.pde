import ddf.minim.Minim;
import ddf.minim.AudioPlayer;
import ddf.minim.analysis.FFT;
 
Minim minim;
AudioPlayer song;
FFT fft;

boolean rec = false;
String file = "../media/untitled.mp3"; 
// Variables that define the "zones" of the spectrum
// For example, for bass, we take only the first 3% of the total spectrum
float specLow = 0.025; // 3%
float specMid = 0.03;  // 12.5%
float specHi = 0.35;   // 20%
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

// Distance between each line point, negative because on the z dimension
float dist = -15; // -25;
// Line height multiplier
float heightMult = 5;

// Cubes that appear in space
int nbCubes = 120; // 150;
Cube[] cubes;

// Lines that appear on the sides
int nbMurs;
Mur[] murs;
 
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
  
  //// One cube per frequency band
  //nbCubes = (int)(fft.specSize()*specHi);
  //nbCubes = fft.specSize(); // this should be used going by comment
  cubes = new Cube[nbCubes];
  
  // As many walls as we want
  nbMurs = fft.specSize(); // creating 1 wall for each band
  murs = new Mur[nbMurs];

  // Create all objects
  // Create cubic objects
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(); 
  }
  
  // Create wall objects
  // Left Walls
  for (int i = 0; i < nbMurs; i+=4)
   murs[i] = new Mur(0, height/2, 10, height); 
  
  // Right walls
  for (int i = 1; i < nbMurs; i+=4)
   murs[i] = new Mur(width, height/2, 10, height); 
  
  // Low walls
  for (int i = 2; i < nbMurs; i+=4)
   murs[i] = new Mur(width/2, height, width, 10); 
  
  // High walls
  for (int i = 3; i < nbMurs; i+=4)
   murs[i] = new Mur(width/2, 0, width, 10); 
  
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
  
  // Diagonal lines, here we must keep the value of the previous band and the next one to connect them together
  float previousBandValue = fft.getBand(0);
  // For each band
  for(int i = 1; i < specSize; i++)
  {
    // Value of the frequency band, we multiply the bands farther to make them more visible.
    float bandValue = fft.getBand(i); //*(1 + (i/50));
    
    // Selection of the color according to the forces of the different types of sounds
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 255-i); // update ALPHA calc
    strokeWeight(1 + (scoreGlobal/200));
    
    float previous = dist*(i-1);
    float current = dist*i;
    float previousValue = previousBandValue*heightMult;
    float currentValue = bandValue*heightMult;
    
    // lower left line
    line(0, height-previousValue, previous, 0, height-currentValue, current);
    line(previousValue, height, previous, currentValue, height, current);
    line(0, height-previousValue, previous, currentValue, height, current);
    
    // upper left line
    line(0, previousValue, previous, 0, currentValue, current);
    line(previousValue, 0, previous, currentValue, 0, current);
    line(0, previousValue, previous, currentValue, 0, current);
    //line(previousValue, 0, previous, 0, currentValue, current);
    
    // lower right line
    line(width, height-previousValue, previous, width, height-currentValue, current);
    line(width-previousValue, height, previous, width-currentValue, height, current);
    line(width, height-previousValue, previous, width-currentValue, height, current);
    
    //upper right line
    line(width, previousValue, previous, width, currentValue, current);
    line(width-previousValue, 0, previous, width-currentValue, 0, current);
    line(width, previousValue, previous, width-currentValue, 0, current);
    
    // Save the value for the next loop round
    previousBandValue = bandValue;
  }
  
  // The color is represented as: red for bass, green for medium sounds and blue for high.
  // Opacity is determined by the volume of the tape and the overall volume.
      
  // Cube for each frequency band
  for(int i = 0; i < nbCubes; i++)
  {
    // Value of the frequency band
    float bandValue = fft.getBand(i);
    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  // Rectangular walls
  for(int i = 0; i < nbMurs; i++)
  {
    // Each wall is assigned a band, and its strength is sent to it
    //float intensity = fft.getBand(i%(int)(specSize*specHi));
    float bandValue = fft.getBand(i);
    murs[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  // record?
  if (rec == true)
    saveFrame("output/viz_####.jpg");
}
