class Circle {
  
  Note n1;
  float x, y;
  color dc1;
  float size;
  boolean reset;
  Circle(float x1, float y1, int r) {
    x = x1;
    y = y1;
    size = r;
  }

  void display(float k) {
    //noStroke();
    //fill(dc1, 130);
    stroke(0);
    fill(255, k);
    circle(x, y, size);
  }
}
