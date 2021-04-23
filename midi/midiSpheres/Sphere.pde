class Ball {
  PVector position;
  PVector velocity;

  Body body;
  float radius, m;

  Ball(float x, float y, float r_, float bpm) {
    
    makeBody(x,y,r_);
    radius = r_;
    
  }

 Vec2 getPos() {
   Vec2 pos = box2d.getBodyPixelCoord(body);
   return pos;
 }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x,pos.y);
    // negative since y axis is flipped bw Processing and World
    rotate(-a);
    fill(0, 0);
    //strokeWeight(1);
    stroke(0);
    ellipse(0, 0, radius*2, radius*2);
    // Let's add a line so we can see the rotation
    //line(0,0,r,0);
    popMatrix();
    
    //noStroke();
    //strokeWeight(4);   
  }
  
  void makeBody(float x, float y, float r) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    
    body = box2d.createBody(bd);
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
     FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 0;
    fd.friction = 0;
    fd.restitution = 1.1;
    
    // Attach fixture to body
    body.createFixture(fd);
    
    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(new Vec2(20f, 20f));
    //body.setAngularVelocity(random(-10,10));
    
  }
}
