import java.util.Collection;
import javax.sound.midi.*;

Player player;
PShader shader;
Collection<Note> notes;

void setup() {
  fullScreen(P3D);
  //size(1200, 720, P3D);
  frameRate(60);
  background(0);
  colorMode(HSB);
  noStroke();
 
  player = new Player();
  player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/Queen - Bohemian Rhapsody.mid"));
  player.start();
  //shader = loadShader("C:/Users/arman/Documents/Processing/data/shader.glsl");
}

void draw() {
  
  //background(0);
  //shader.set("n", 20 * noise(frameCount * 0.001));  
    
  notes = player.getNotes();

  translate(width/2, height/2);
  for (Note n : notes) {
    
    println(n.note % 12 + " " + n.channel + " " + n.velocity, n.living, n.dying);
    
    //fill(map(n.note % 12, 0, 11, 0, 255), map(n.channel, 0, 15, 80, 255), map(n.note, 0, 127, 100, 255) * random(0.9, 1.0));
    fill(map(n.channel, 0, 15, 0, 255), map(n.note % 12, 0, 11, 80, 255), map(n.velocity, 0, 127, 25, 230) * random(0.9, 1.0));
      
    pushMatrix();
    float t = frameCount * 0.003;
    //scale(3);
    
    rotateZ(map(n.channel % player.channelCount, 0, 11, 0, TWO_PI-TWO_PI/12));
    
    pushMatrix();
    translate(0, map(n.noteClass, 0, 11, 50, 540), 0);
    float size = 600.0/sqrt(n.living);
    if (size > 0)
      box(size, n.velocity * 0.8 + random(10), size);
    popMatrix();
    
    translate(0, 5000.0, 0);
    fill(map(n.channel, 0, 15, 0, 255), 255, 255);
    box(2, 10000, 0.6);
    popMatrix();
  }
  player.update();
}
