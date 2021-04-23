class Circle {
  
  Note n1;
  float x1, y1;
  color dc1;
  float size1;
  boolean show, reset;
  int frame;
  
  Circle(int r, int c) {
    show = false;
  }
  
  void create(float x, float y, float size, color dc, Note n) {
    x1 = x;
    y1 = y;
    n1 = n;
    dc1 = dc;
    frame = 0;
    size1 = size;
    display();
    show = true;
  }
  
  void display() {
    if (show) {
    noStroke();
    fill(dc1, 130 - frame * 0.3);
    circle(x1, y1, size1 + frame);
    frame ++;
    }
  }
}
