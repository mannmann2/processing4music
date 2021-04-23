import shiffman.box2d.*;
import org.jbox2d.common.Vec2;
//import org.jbox2d.common.*;
//import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.CircleShape;
import org.jbox2d.collision.shapes.PolygonShape;
//import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.Contact;

Player player;
PShader shader;
Collection<Note> notes;
float size, alpha;
float x, y;
int displayChannel;
boolean ch;

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

Boundary w1;

Box2DProcessing box2d;
 
void setup() {
  fullScreen(P3D);
  background(0);
  colorMode(HSB);
  noStroke();
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  //box2d.setGravity(0, 0);
  //box2d.listenForCollisions();
  
  particles = new ArrayList<Particle>();
  
  player = new Player();
  //player.load(dataPath("C:/Users/arman/Documents/Processing/data/ravel_bolero.mid"));
  player.load(dataPath("C:/Users/arman/Documents/Processing/data/musical_opfer_bwv-1079-4.mid"));
  //player.load(dataPath("C:/Users/arman/Documents/Processing/data/Queen - Bohemian Rhapsody.mid"));
  
 
  w1 = new Boundary(width/2, height-5, width, 10);
  
  player.start();
}

void draw() {
  background(255);
  box2d.step();
  //w1.display();
  //w2.display();
  //w3.display();
  //w4.display();
  println(particles.size());
  for (Note n: player.getNotes()) {
  
    displayChannel = player.list.indexOf(n.channel);

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
    
    if (n.living == 0) {
      particles.add(new Particle(200 +random(-20, 20) + displayChannel*(width-400)/player.channelCount, 100, size/2, dc));
    }
  }
  
  // Look at all particles
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (p.done()) {
      particles.remove(i);
    }
  }
  w1.display();

  player.update();
}

// Collision event functions!
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Particle.class && o2.getClass() == Particle.class) {
    Particle p1 = (Particle) o1;
    p1.change();
    Particle p2 = (Particle) o2;
    p2.change();
  }

}

// Objects stop touching each other
void endContact(Contact cp) {
}
