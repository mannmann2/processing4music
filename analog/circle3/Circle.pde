class Circle {
  // Z position of spawn and maximum Z position
  float startingZ = -20;
  
  // Position values
  float x, y, z, radius, alpha, prev;
  boolean start;
  color displayCol;
  
  //Constructeur
  Circle(int i) {
    //Make the cube appear in a random place
    //x = 100+ (i % (int)((width-200)/50))*50;
    //y = 100 + 50*(int)(i/((width-200)/50));
    y = 0;
    x = 0;
    z = startingZ;
    radius = 0;
    alpha = 0;
    
    prev = 0;
    start = false;
  }
  
  void display(color displayColor, float intensity, float scoreGlobal) {
    //Selection of color, opacity determined by intensity (volume of the tape)
    
    
    y = random(0, height);
    x = random(0, width);
    radius = intensity*5;
    
    alpha = 200;
    displayCol = displayColor;
    fill(displayCol, alpha);
    
    // Color lines, they disappear with the individual intensity of the cube
    //color strokeColor = color(255, 100-(intensity*200));
    //stroke(strokeColor);
    //strokeWeight(1);
    //strokeWeight(1 + (scoreGlobal/300));
    
    ellipse(x, y, radius, radius);
    
    
    // Creating a transformation matrix to perform rotations, enlargements
    //pushMatrix();
    
    //Déplacement
    //translate(x, y, z);
    
    //Creation of the box, variable size according to the intensity for the cube
    //box(50+(intensity)); // /2
    
    //Application of the matrix
    //popMatrix();
    start = true;
   
  }
  
  void scale(color displayColor, float factor) {
    radius = radius + 1;
    alpha -= 1;
    fill(displayCol, alpha);
    ellipse(x, y, radius, radius);
  }
  
  void setPrev(float val){
    prev = val;
  }
}