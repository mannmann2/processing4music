import java.util.Collection;
import javax.sound.midi.*;

Player player;
PShader shader;

void setup() {
  fullScreen(P3D);
  background(0);
  colorMode(HSB);
  noStroke();
  player = new Player();
  player.load(dataPath("C:/Users/arman/Documents/Processing/data/Queen - Bohemian Rhapsody.mid"));
  player.start();
  shader = loadShader("C:/Users/arman/Documents/Processing/data/shader.glsl");
}

void draw() {
  background(#001133);
  shader.set("n", 20 * noise(frameCount * 0.001));

  translate(width/2, height/2);
  rotateZ(noise(0.23, 15 * frameCount * 0.00013));
  rotateY(frameCount * 0.003);

  directionalLight(30, 20, 255, 1, 1, 1);
  directionalLight(150, 20, 255, -1, -1, -1);
  
  for (Note n : player.getNotes()) {
    fill(map(n.noteClass, 0, 11, 0, 255), 
         map(n.channel, 0, 15, 80, 255), 
         map(n.note, 0, 127, 100, 255) * random(0.9, 1.0));

    pushMatrix();
    float t = frameCount * 0.003;
    scale(n.velocity * 0.05);
    rotateX(n.channel + noise(n.note * 0.1, t));
    rotateY(n.note * 0.6);
    rotateZ(map(n.noteClass, 0, 11, 0, TWO_PI-TWO_PI/12));
    
    pushMatrix();
    translate(0, n.velocity * 0.7, 0);
    box(40.0 / n.living, n.velocity * 0.1 + random(10), 40.0 / n.living);
    popMatrix();    
    
    translate(0, 10000, 0);
    box(0.2, 20000, 0.2);
    popMatrix();
  }
  player.update();
}
