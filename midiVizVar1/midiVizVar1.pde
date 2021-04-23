import java.util.Collection;
import javax.sound.midi.*;

Player player;
PShader shader;
Collection<Note> notes;

void setup() {
  fullScreen(P3D);
  background(#001133);
  colorMode(HSB);
  noStroke();
 
  player = new Player();
  player.load(dataPath("C:/Users/arman/Documents/Processing/data/Queen - Bohemian Rhapsody.mid"));
  player.start();
  //shader = loadShader("C:/Users/arman/Documents/Processing/data/shader.glsl");
}

void draw() {
  background(#001133);
  //background(255);
  //shader.set("n", 20 * noise(frameCount * 0.001));

  translate(width/2, height/2);
  //rotateZ(noise(0.23, 15 * frameCount * 0.00013));
  //rotateY(frameCount * 0.003);

  //directionalLight(30, 20, 255, 1, 1, 1);
  //directionalLight(150, 20, 255, -1, -1, -1);
  
  notes = player.getNotes();
  //print("size:", notes.size());
  //if (notes.size() == 0) {
  //  println("restart");
  //  return;
  //}
  for (Note n : notes) {
    
    println(n.note % 12 + " " + n.channel + " " + n.velocity, n.living, n.dying);
    
    //fill(map(n.note % 12, 0, 11, 0, 255), map(n.channel, 0, 15, 80, 255), map(n.note, 0, 127, 100, 255) * random(0.9, 1.0));
      fill(map(n.noteClass, 0, 11, 0, 255), 
           map(n.channel, 0, 15, 80, 255), 
           map(n.note, 0, 127, 100, 255) * random(0.9, 1.0));
      
    pushMatrix();
    float t = frameCount * 0.003;
    scale(n.velocity * 0.01);
    
    //rotateX(n.channel + noise(n.note * 0.1, t));
    //rotateY(n.octave * 0.6);
    rotateX(PI * n.channel/15);
    rotateY(PI * (n.octave-5)/4);
    rotateZ(map(n.noteClass, 0, 11, 0,  TWO_PI-TWO_PI/12));
    
    pushMatrix();
    translate(0, map(n.channel, 0, 15, 100, 800), 0);
    //translate(0, n.velocity*3, 0);
    float size = 600.0/sqrt(n.living);
    if (size > 0)
      box(size, n.velocity * 0.7 + random(10), size);
    //box(400.0 / n.living, n.velocity * 0.5 + random(10), 400.0 / n.living);
    popMatrix();
    
    translate(0, 50+10000, 0);
    box(1, 20000, 1);
    popMatrix();
  }
  player.update();
}
