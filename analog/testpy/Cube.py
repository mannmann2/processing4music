#Class for cubes floating in space
class Cube:
  # Z position of spawn and maximum Z position
  startingZ = -20
  
  #Constructeur
  def __init__(self, i):
    global startingZ
    # Make the cube appear in a random place
    self.x = 100+ (i % int((this.width-200)/50))*50
    self.y = 100 + 50*int(i/((this.width-200)/50))
    self.z = self.startingZ
    
  def display(self, displayColor, intensity, scoreGlobal):
    #Selection of color, opacity determined by intensity (volume of the tape)
    colorMode(RGB)
    fill(displayColor)
    
    # Color lines, they disappear with the individual intensity of the cube
    strokeColor = color(255, 100-(intensity*200))
    stroke(strokeColor)
    strokeWeight(1)
    #strokeWeight(1 + (scoreGlobal/300))
    # Creating a transformation matrix to perform rotations, enlargements
    pushMatrix()
    
    #Deplacement
    translate(self.x, self.y, self.z)
    
    #Creation of the box, variable size according to the intensity for the cube
    box(50+(intensity)) # /2
    
    #Application of the matrix
    popMatrix()
