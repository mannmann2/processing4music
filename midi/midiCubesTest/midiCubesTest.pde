import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import javax.sound.midi.*;

Player player;
PShader shader;
Collection<Note> notes;
int noteClass, displayChannel, octave;

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;

// for recording
AudioInput in;
AudioRecorder recorder;
boolean recorded;

// for playing back
AudioOutput out;
FilePlayer player2;

Cube [][] cubes;

void setup() {
  fullScreen(P3D);
  background(0);
  colorMode(HSB);
  strokeWeight(4);

  player = new Player();
  //player.load(dataPath("C:/Users/arman/Documents/Processing/data/musical_opfer_bwv-1079-4.mid"));
  player.load(dataPath("C:/Users/arman/Documents/Processing/data/Queen - Bohemian Rhapsody.mid"));
  
  cubes = new Cube[12][player.channelCount];
  for (int i = 0; i < 12; i++) {
    for (int j = 0; j < player.channelCount; j++) {
      cubes[i][j] = new Cube(i, j, player.channelCount);
    }
  }
  
  player.start();
  //shader = loadShader("shader.glsl");
  
  minim = new Minim(this);
  
  //// get a stereo line-in: sample buffer length of 2048
  //// default sample rate is 44100, default bit depth is 16
  //in = minim.getLineIn(Minim.STEREO);
  
  //// create an AudioRecorder that will record from in to the filename specified.
  //// the file will be located in the sketch's main folder.
  out = minim.getLineOut(Minim.STEREO);
  recorder = minim.createRecorder(out, "myrecording.wav", true);
  //recorder.setRecordSource(out);
  recorder.beginRecord();
  
}

void draw() {
  background(0);
  //noStroke();
  

  for (Note n: player.getNotes()) {
    
    displayChannel = player.list.indexOf(n.channel);
    println(n.noteClass, n.octave, displayChannel, n.velocity, n.living, n.dying);
    
    
    color dc = color(map(n.noteClass, 0, 12, 0, 255), 
                     map(displayChannel, 0, player.channelCount, 40, 255), 
                     map(octave, 0, 9, 120, 255));
                     
    //* random(0.9, 1.0));
    cubes[n.noteClass][displayChannel].display(dc, n.velocity*20/player.channelCount, n.living);
    
  }
  
  //stroke(255);
  //fill(255, 0);
  //translate(0,0,-200);
  //rect(0, 0, width, height);
  
  
  player.update();
}

void keyReleased()
{
  if (key =='r') {
    recorder.endRecord();
    recorder.save();
    player2 = new FilePlayer(recorder.save());
    player2.patch(out);
    player2.play();
  }
}
