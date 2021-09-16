class Circle {
  
  Note n1;
  float x, y;
  color dc1;
  float size1;
  boolean show, reset;
  int frame;  
  Circle(float x1, float y1, int r, int c) {
    show = false;
    x = x1;
    y = y1;
  }
  
  void create(float size, color dc, Note n) {
    n1 = n;
    dc1 = dc;
    frame = 0;
    size1 = size;
    //display();
    show = true;
  }
  
  void display(boolean str) {
    if (show) {
    //noStroke();
    //fill(dc1, 130);
    float k = 150 - frame * 0.18;
    if (str&&k>0)
      stroke(0);
    else
      noStroke();
    fill(dc1, k);
    
    circle(x, y, size1 + frame*1.8);
    frame ++;
    }
  }
}
