class Cube {
  
  //Valeurs de positions
  float x, y, z;
  float v;
  //float rotX, rotY, rotZ;
  //float sumRotX, sumRotY, sumRotZ;
  
  //Constructeur
  Cube(int i, int j, int ch) {
    x = j*width/ch;
    y = i*height/12;
    z = -500;
    v = 1;
    //println(i, j, x, y);
    //Donner au cube une rotation aléatoire
    //rotX = random(0, 1);
    //rotY = random(0, 1);
    //rotZ = random(0, 1);
  }
  
  void display(color displayColor, int size, int living, int velocity) {
    
    //Création d'une matrice de transformation pour effectuer des rotations, agrandissements
    pushMatrix();
    
    fill(displayColor, 175);
    //color strokeColor = color(0); //, 150-(20*intensity));
    //stroke(strokeColor);
    //strokeWeight(1 + (scoreGlobal/300));
    
    //Déplacement
    //translate(x, y, z);
    //Calcul de la rotation en fonction de l'intensité pour le cube
    //sumRotX += intensity*(rotX/1000);
    //sumRotY += intensity*(rotY/1000);
    //sumRotZ += intensity*(rotZ/1000);
    //Application de la rotation
    //rotateX(sumRotX);
    //rotateY(sumRotY);
    //rotateZ(sumRotZ);
    
    //noStroke();
    //if (living == 0) {
    //  z = -500;
    //  translate(x, y, z);
    //  box(size);
    //  //sphere(size);
    //}
    //else if (size - living > 0) { 
    //  z -= 2;
    //  translate(x, y, z);
    //  box(size-living);
    //  //sphere(size);
    //}
    
    translate(x, y, z);
    if (living == 0){
      v = velocity;
      box(size);
    }
    else if (size - living > 0) 
      box(size-living);
    
    popMatrix();
    
    //Déplacement Z
    //z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replacer la boite à l'arrière lorsqu'elle n'est plus visible
    //if (z >= maxZ) {
    //  x = random(0, width);
    //  y = random(0, height);
    //  z = startingZ;
    //}
  }
}
