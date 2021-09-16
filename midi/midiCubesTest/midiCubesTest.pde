import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import javax.sound.midi.*;

Player player;
PShader shader;
Collection<Note> notes;
int noteClass, displayChannel, octave;

//import ddf.minim.*;
//import ddf.minim.ugens.*;

//Minim minim;

// for recording
//AudioInput in;
//AudioRecorder recorder;
//boolean recorded;

// for playing back
//AudioOutput out;
//FilePlayer player2;

Cube [][] cubes;
float [][] vels;

void setup() {
  fullScreen(P3D);
  //size(1000, 700, P3D);
  frameRate(60);
  background(0);
  colorMode(HSB);
  strokeWeight(1);
  //sphereDetail(10);
  player = new Player();
  player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/Queen - Bohemian Rhapsody.mid"));
  //player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/musical_opfer_bwv-1079-4.mid"));

  vels = new float[12][player.channelCount];
  cubes = new Cube[12][player.channelCount];
  for (int i = 0; i < 12; i++) {
    for (int j = 0; j < player.channelCount; j++) {
      cubes[i][j] = new Cube(i, j, player.channelCount);
    }
  }
  
  player.start();
  //shader = loadShader("shader.glsl");
  
  //minim = new Minim(this);
  
  //// get a stereo line-in: sample buffer length of 2048
  //// default sample rate is 44100, default bit depth is 16
  //in = minim.getLineIn(Minim.STEREO);
  
  //// create an AudioRecorder that will record from in to the filename specified.
  //// the file will be located in the sketch's main folder.
  //out = minim.getLineOut(Minim.STEREO);
  //recorder = minim.createRecorder(in, "myrecording.wav", true);
  //recorder.beginRecord();
}

void draw() {
  background(255);
  //rotateX(PI/4);
  //noStroke();

  for (Note n: player.getNotes()) {
    
    displayChannel = player.list.indexOf(n.channel);
    //println(n.noteClass, n.octave, displayChannel, n.velocity, n.living, n.dying);
    
    
    color dc = color(map(n.noteClass, 0, 12, 0, 255), 
                     map(displayChannel, 0, player.channelCount, 40, 255), 
                     map(octave, 0, 9, 120, 255));
                     
    //* random(0.9, 1.0));
    cubes[n.noteClass][displayChannel].display(dc, n.velocity*20/player.channelCount, n.living, n.velocity);
  }
  
  
   for (int j = 0; j < 12; j++)
      for (int k = 0; k < player.channelCount; k++)
        vels[j][k] = cubes[j][k].v;

   
    for (int j = 0; j < 12; j++) {
      for (int k = 0; k < player.channelCount; k++) {
                
        for(int i=-10; i<=10; i++) {
          if (i==0)
            continue;
            
          int k2 = (k+i)%player.channelCount;
          if (k2 < 0)
            k2 = player.channelCount - abs(k2);
          int j2 = j;
          if ((k+i) > player.channelCount-1)
            j2 += 1;
          else if ((k+i) < 0)
            j2 -= 1;
        
          if ((j2 == -1) || (j2 == 12))
            continue;
          vels[j2][k2] = vels[j2][k2] + (cubes[j][k].v-vels[j2][k2])/pow(2, abs(i));
        }
      }
    }
     
  int dist = -25;
  int heightMult = 5;
  float previousBandValue = cubes[0][0].v;
     
    for (int j = 0; j < 12; j++) {
      for (int k = 0; k < player.channelCount; k++) {
        
        cubes[j][k].v = vels[j][k];
        
        if (cubes[j][k].v > 0.05)
          cubes[j][k].v -= 0.5;
        else
          cubes[j][k].v = 0.05;
        
        int i = j*12+k;
        //int bandValue = 0;
        //int prevBandValue = 0;
        //float bandValue = (cubes[j][k].v/10) * (50/(i+1));
        
        float previous = dist*(i-1);
        float current = dist*i;
        float currentValue = cubes[j][k].v * heightMult;
        float previousValue = previousBandValue*heightMult;
        //float previousBandValue = cubes[j][k].v_prev;

        //println(i, bandValue, previousBandValue);
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
        
        previousBandValue = cubes[j][k].v;
     }
  }
  // make walls
  //stroke(255);
  //fill(255, 0);
  //translate(0,0,-200);
  //rect(0, 0, width, height);
  
  player.update();
}

//void keyReleased()
//{
//  if (key =='r') {
//    recorder.endRecord();
//    recorder.save();
//    player2 = new FilePlayer(recorder.save());
//    player2.patch(out);
//    player2.play();
//  }
//}
