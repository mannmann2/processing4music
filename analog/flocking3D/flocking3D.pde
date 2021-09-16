// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

Flock flock;
int zmax = 500;
void setup() {
  size(1500,1000, P3D);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 200; i++) {
    float w = random(width);
    float h = random(height);
    float z = random(zmax);
    Boid b = new Boid(w, h, z);
    flock.addBoid(b);
  }
}

void draw() {
  background(255);
  translate(0,0, -zmax-50);
  pushMatrix();
    
    //Déplacement
    translate(width/2,height/2,zmax/2);
    noFill();
    stroke(0);
    strokeWeight(1);
    //Creation of the box, variable size according to the intensity for the cube
    box(width, height, zmax);
    
    //Application of the matrix
    popMatrix();
  flock.run();
  
  // Instructions
  fill(0);
  text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX,mouseY,random(zmax)));
}
