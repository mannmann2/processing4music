//Class for cubes floating in space
class Cube {
  // Z position of spawn and maximum Z position
  float startingZ = -10000;
  float maxZ = 1000;
  
  // Position values
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructeur
  Cube() {
    //Make the cube appear in a random place
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //Give the cube a random rotation
    rotX = random(-1, 1);
    rotY = random(-1, 1);
    rotZ = random(-1, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Selection of color, opacity determined by intensity (volume of the tape)
    color displayColor = color(scoreLow*0.9, scoreMid*0.9, scoreHi*0.9, intensity*500); // THIS CAN BE PLAYED WITH
    fill(displayColor);
    
    // Color lines, they disappear with the individual intensity of the cube
    color strokeColor = color(255, 150-(intensity*100));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/200));
    
    // Creating a transformation matrix to perform rotations, enlargements
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Calculation of the rotation according to the intensity for the cube
    sumRotX += intensity*2*(rotX/1000)+rotX/1000; // added the sum parts
    sumRotY += intensity*2*(rotY/1000)+rotY/1000;
    sumRotZ += intensity*2*(rotZ/1000)+rotZ/1000;
    //Application of the rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //Creation of the box, variable size according to the intensity for the cube
    box(70+(intensity*4));
    
    //Application of the matrix
    popMatrix();
    
    //Déplacement Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/100), 2)));
    
    //Replace the box at the back when it is no longer visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}