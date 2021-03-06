import shiffman.box2d.*;
import org.jbox2d.common.Vec2;
//import org.jbox2d.common.*;
//import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.CircleShape;
import org.jbox2d.collision.shapes.PolygonShape;
//import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.dynamics.*;
//import org.jbox2d.dynamics.contacts.*;

Player player;
PShader shader;
Collection<Note> notes;
float size, alpha;
float x, y;
int displayChannel;
boolean ch = true;
boolean debug = false;
Ball[] balls;
Circle[] circles;
Boundary w1, w2, w3, w4;

Box2DProcessing box2d;
 
void setup() {
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  fullScreen(P3D);
  frameRate(120);
  background(0);
  colorMode(HSB);
  noStroke();
 
  player = new Player();
  player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/07-lacri.mid"));
  //player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/musical_opfer_bwv-1079-4.mid"));
  //player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/Queen - Bohemian Rhapsody.mid"));
  
  balls = new Ball[player.channelCount];
  
  circles = new Circle[player.channelCount];

  for (int i=0; i<player.channelCount; i++) {

    x = 40 + random(width-80);
    y = 40 + random(height-80);
      
    println(x, y);
    balls[i] = new Ball(x, y, 60, player.getBPM());
    circles[i] = new Circle(x, y, 50);
  }
  w1 = new Boundary(width/2, -5, width, 10);
  w2 = new Boundary(width/2, height+5, width, 10);
  w3 = new Boundary(-5, height/2, 10, height);
  w4 = new Boundary(width+5, height/2, 10, height);
  
  player.start();
}

void draw() {
  if (ch)
    background(0);
  box2d.step();
  //w1.display();
  //w2.display();
  //w3.display();
  //w4.display();
  
  for (Note n: player.getNotes()) {
  
    displayChannel = player.list.indexOf(n.channel);
    
    Circle c = circles[displayChannel];
    Ball b = balls[displayChannel];
    
    // Velocity: 0-127
    size = map(n.velocity, player.minV, player.maxV, 75, 250);
    //size = (16*size/player.channelCount) - n.living*2;
    //alpha = 255/(size*0.01);
   
    //println(n.noteClass, n.octave, displayChannel, n.velocity, n.living, n.dying);
    
    color dc = color(
      map(n.noteClass, 0, 12, 0, 255),  // Hue (13 values to prevent duplication)
      map(displayChannel, 0, player.channelCount, 100, 255),  //Saturation
      // Octaves: 0-10
      map(n.octave, player.minOct, player.maxOct, 120, 255)  // Brightness 
    );
    
    Vec2 pos = b.getPos();
    //if (n.living == 0) {
    //  c.create(pos.x, pos.y, size, dc, n);
    //}
     
  }
   player.update();
   
  for (Circle c : circles)
      c.display(); 
      
  for (Ball b1: balls)
    b1.display(debug);
}

void keyPressed() {
  if (key=='d')
    debug = !debug;
  else if (key == 'c')
    ch =! ch;
}
