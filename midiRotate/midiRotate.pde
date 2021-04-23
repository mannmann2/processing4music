import java.util.Collection;

Player player;
PShader shader;
Collection<Note> notes;
float size, alpha;
boolean ch = true;

void setup() {
  fullScreen(P3D);
  background(255);
  colorMode(HSB);
  noStroke();
 
  player = new Player();
  player.load(dataPath("C:/Users/arman/Documents/Processing/data/musical_opfer_bwv-1079-4.mid"));
  //player.load(dataPath("C:/Users/arman/Documents/Processing/data/Queen - Bohemian Rhapsody.mid"));
  player.start();
  //shader = loadShader("shader.glsl");
}

void draw() {
  
  background(255);
  //shader.set("n", 20 * noise(frameCount * 0.001));

  //rotateZ(noise(0.23, 15 * frameCount * 0.00013));
  //rotateY(frameCount * 0.003);

  //directionalLight(30, 20, 255, 1, 1, 1);
  //directionalLight(150, 20, 255, -1, -1, -1);
  
  translate(width/2, height/2);
    
  notes = player.getNotes(); 
  
  for (Note n : notes) {
    
    //println(n.noteClass, n.channel, n.velocity, n.living, n.dying);
    //fill(map(n.noteClass, 0, 11, 0, 255), map(n.channel, 0, 15, 80, 255), map(n.note, 0, 127, 100, 255) * random(0.9, 1.0));
    
    size = 400.0 - n.living*2;
    //size = (16*size/player.channelCount) - n.living*2;
    color displayColor = color(
      map(n.noteClass, 0, 12, 0, 255), 
      map(n.channel, 15, 0, 80, 255), 
      map(n.velocity, player.minV, player.maxV, 100, 255) * random(0.9, 1.0)
    );
    alpha = 255-(size/4);
    
    fill(displayColor, alpha);
      
    pushMatrix();
    //float t = frameCount * 0.003;
    //scale(n.velocity * 0.05); //3
    //rotateX(n.channel); // + noise(n.note * 0.1, t));
    //rotateY(n.note * 0.06);    
    rotateZ(map(n.noteClass, 0, 11, 0, TWO_PI-TWO_PI/12));
    
    pushMatrix();

    int displayChannel = player.list.indexOf(n.channel);
    float dis = map(displayChannel, 0, player.channelCount, 200, height/2-20);
    
    translate(0, dis, 0);
    stroke(0);
    strokeWeight(4);
    if (size > 0) {
      box(size, n.velocity, 400.0 - n.living*1);
      //line(-10000, 0, 0, 10000, 0, 0);
    }   
    popMatrix();
    
    //translate(0, 5000.0, 0);
    //box(0.2, 10000, 0.6);
    line(0, dis/4, 0, 0, 10000, 0);
    strokeWeight(2);
    circle(0,0,dis/2);
    popMatrix();
  }
  player.update();
  
  if (!ch) {
    player.pause();
    ch = !ch;
  }
}

void keyPressed() {
  if (key == ' ') {
      ch = !ch;
  }
}
