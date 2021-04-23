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
boolean ch;
Ball[] balls;
Circle[][] circles;
Boundary w1, w2, w3, w4;

Box2DProcessing box2d;
 
void setup() {
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  fullScreen(P3D);
  background(0);
  colorMode(HSB);
  noStroke();
 
  player = new Player();
  player.load(dataPath("C:/Users/arman/Documents/Processing/data/ravel_bolero.mid"));
  //player.load(dataPath("C:/Users/arman/Documents/Processing/data/musical_opfer_bwv-1079-4.mid"));
  //player.load(dataPath("C:/Users/arman/Documents/Processing/data/Queen - Bohemian Rhapsody.mid"));
  
  balls = new Ball[player.channelCount];
  circles = new Circle[player.channelCount][12];
  for (int i=0; i<player.channelCount; i++) {
    
    for (int j = 0; j<12; j++) {
      circles[i][j] = new Circle(i, j);
    }

    x = 40 + random(width-80);
    y = 40 + random(height-80);
      
    println(x, y);
    balls[i] = new Ball(x, y, 60, player.getBPM());
  }
  w1 = new Boundary(width/2, -5, width, 10);
  w2 = new Boundary(width/2, height+5, width, 10);
  w3 = new Boundary(-5, height/2, 10, height);
  w4 = new Boundary(width+5, height/2, 10, height);
  
  player.start();
}

void draw() {
  background(255);
  box2d.step();
  //w1.display();
  //w2.display();
  //w3.display();
  //w4.display();
  
  for (Note n: player.getNotes()) {
  
    displayChannel = player.list.indexOf(n.channel);
    Ball b = balls[displayChannel];
    Circle c = circles[displayChannel][n.noteClass];
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
    if (n.living == 0) {
      c.create(pos.x, pos.y, size, dc, n);
    }
     
  }
   player.update();
  
  for (Ball b1: balls)
    b1.display();
      
  for (Circle[] ch : circles)
    for (Circle c: ch)
      c.display(); 
}
