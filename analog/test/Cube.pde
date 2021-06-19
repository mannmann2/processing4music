
//Class for cubes floating in space
class Cube {
  // Z position of spawn and maximum Z position
  float startingZ = -20;

  // Position values
  float x, y, z;  
  int size = 50;
  float prev = 0;
  
  //Constructeur
  Cube(int i) {
    //Make the cube appear in a random place
    x = 100 + (i % (int)((width-200)/size))*size;
    y = 100 + size*(int)(i/((width-200)/size));
    z = startingZ;
  }
  
  void display(color displayColor, float intensity, float scoreGlobal) {
    //Selection of color, opacity determined by intensity (volume of the tape)
    fill(displayColor);
    //if (prev-0.1 > intensity) {
    //  intensity = prev - 0.1;
    //  prev = intensity;
    //}
    // Color lines, they disappear with the individual intensity of the cube
    color strokeColor = color(255, 100-(intensity*200));
    stroke(strokeColor);
    //strokeWeight(1);
    strokeWeight(1 + (scoreGlobal/200));
    // Creating a transformation matrix to perform rotations, enlargements
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Creation of the box, variable size according to the intensity for the cube
    box(size+(intensity*3)); // /2
    //prev = intensity;
    //Application of the matrix
    popMatrix();
    
    prev = intensity;
   
  }
}
