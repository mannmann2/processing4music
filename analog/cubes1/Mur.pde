//Class to display the lines on the sides
class Mur {
  // Minimum and maximum position Z
  float startingZ = -10000;
  float maxZ = 20;
  
  // Position values
  float x, y, z;
  float sizeX, sizeY;
  
  // Constructer
  Mur(float x, float y, float sizeX, float sizeY) {
    //Make the line appear at the specified place
    this.x = x;
    this.y = y;
    //Random depth
    this.z = random(startingZ, maxZ);  
    
    // We determine the size because the walls on the floors have a different size than those on the sides
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  //Display function
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    // Color determined by low, medium and high sounds
    // Opacity determined by the overall volume
    noStroke();
    
    color displayColor = color(scoreLow*0.75, scoreMid*0.75, scoreHi*0.75, scoreGlobal*5);
    //Make lines disappear in the distance to give an illusion of fog
    fill(displayColor, 255); //((scoreGlobal)/100)*(255+(z/25)));
    
    // First band, the one that moves according to the force
    // transformation matrix
    pushMatrix();
    //Déplacement
    translate(x, y, z);
    //extension
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity*0.01), sizeY*(intensity*0.01), 10);
    //Creation of the "box"
    box(1);
    popMatrix();
    
    
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal*2);
    fill(displayColor, (scoreGlobal/1000)*(255+(z/25)));
    
    //Second band, the one that is still the same size
    //Transformation Matri
    pushMatrix();
    //Déplacement
    translate(x, y, z);
    //extension
    scale(sizeX, sizeY, 5);
    //Creation of the "box"
    box(1);
    popMatrix();
    
    //Déplacement Z
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}