add_library('minim')
from Cube import Cube

fft = None
song = None
beat = None
nbCubes = None

rec = False
file = "../media/untitled.mp3" 
# Variables that define the "zones" of the spectrum
# For example, for bass, we take only the first 3% of the total spectrum
specLow = 0.03 # 3%
specMid = 0.08  # 12.5%
specHi = 1.0   # 20%

# This leaves 64% of the possible spectrum that will not be used.
# These values are usually too high for the human ear anyway.

# Scoring values for each zone
scoreLow, scoreMid, scoreHi = 0, 0, 0
th1, th2, th3 = 0, 0, 0
# Previous value, to soften the reduction
oldScoreLow = scoreLow
oldScoreMid = scoreMid
oldScoreHi = scoreHi

# hu = 0
# sat = 255
# bri = 200
# eRadius = 60
  
# Softening value
scoreDecreaseRate = 25
 
def setup():
  global fft, song, nbCubes, cubes, beat, th1, th2, th3
  #Display in 3D on the entire screen
  # fullScreen(P3D)
  size(1200, 900, P3D)
  frameRate(60)
  # colorMode(HSB);

  # Load the minim library
  minim = Minim(this)
  # Load song
  song = minim.loadFile(file, 512)
  # Create the FFT object to analyze the song
  fft = FFT(song.bufferSize(), song.sampleRate())
  
  # One cube per frequency band
  #nbCubes = (int)(fft.specSize()*specHi)
  nbCubes = fft.specSize() # this should be used going by comment
  print(nbCubes)
  th1 = nbCubes*specLow
  th2 = nbCubes*specMid
  th3 = nbCubes*specHi
  
  # Create all objects
  # Create cubic objects
  cubes = [Cube(i) for i in range(nbCubes)]

  # Black background
  background(0)
   
  #Start the song
  song.play(0)
  
  # a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = BeatDetect()
  
  ellipseMode(RADIUS)


def draw():
  global scoreLow, scoreMid, scoreHi, nbCubes, hu, eRadius
  # To advance the song, one draw() for each "frame" of the song...
  fft.forward(song.mix)
  
  # Calculation of "scores" (power) for three categories of sound
  # First, save old values
  oldScoreLow = scoreLow
  oldScoreMid = scoreMid
  oldScoreHi = scoreHi
  
  # Reset values
  scoreLow = 0
  scoreMid = 0
  scoreHi = 0
  
  # Calculate the new "scores"
  for i in range(int(th1)):
    scoreLow += fft.getBand(i)
    
  for i in range(int(th1), int(th2)):
    scoreMid += fft.getBand(i)

  for i in range(int(th2), int(th3)):
    scoreHi += fft.getBand(i)

  # To slow down the descent.
  if (oldScoreLow > scoreLow): 
    scoreLow = oldScoreLow - scoreDecreaseRate
  
  if (oldScoreMid > scoreMid):
    scoreMid = oldScoreMid - scoreDecreaseRate
  
  if (oldScoreHi > scoreHi):
    scoreHi = oldScoreHi - scoreDecreaseRate
  
  # Volume for all frequencies at this time, with the highest sounds higher.
  # This allows the animation to go faster for higher-pitched sounds, which is more noticeable
  scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi
  
  # print(scoreLow, scoreMid, scoreHi)
  # print(scoreLow + scoreMid + scoreHi)
  # Subtle color of background
  background(scoreLow/100, scoreMid/100, scoreHi/100)
  
  # beat.detect(song.mix)
  # a = map(eRadius, 20, 80, 60, 255)
  # # colorMode(HSB)
  # fill(hu, sat, bri, a)
  # if beat.isOnset():
  #   eRadius = 80
  # ellipse(width/2, height/2, eRadius, eRadius)
  # eRadius *= 0.95
  # if eRadius < 20:
  #   eRadius = 20

  # The color is represented as: red for bass, green for medium sounds and blue for high.
  # Opacity is determined by the volume of the tape and the overall volume.
      
  # Cube for each frequency band
  for i in range(nbCubes):
    # Value of the frequency band
    bandValue = fft.getBand(i)
    
    #displayColor = color(bandValue%255, sat, bri)
    if (i < th1):
      displayColor = color(scoreLow, scoreMid*0.8, scoreHi*0.5) # THIS CAN BE PLAYED WITH
    elif (i < th2): 
      displayColor = color(scoreLow*0.8, scoreMid, scoreHi*0.8) # THIS CAN BE PLAYED WITH
    else:
      displayColor = color(scoreLow*0.5, scoreMid*0.8, scoreHi) # THIS CAN BE PLAYED WITH
      # displayColor = color(scoreLow*0.9, scoreMid*0.9, scoreHi*0.9, bandValue*400) # THIS CAN BE PLAYED WITH
     
    cubes[i].display(displayColor, bandValue, scoreGlobal)
  
  # hu += 0.1

def keyPressed():
  if (key==' '):
    delay(2000)
  #if (key=='c'):
  #  ch = !ch
