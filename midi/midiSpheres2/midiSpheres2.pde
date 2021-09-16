Player player;
PShader shader;
Collection<Note> notes;
float size, alpha;
float x, y;
int displayChannel;
boolean ch = true;
boolean debug = false;
boolean str;
Circle[][] circles;
Circle [] lastc;

void setup() {

  fullScreen(P3D);
  frameRate(120);
  background(0);
  colorMode(HSB);
  strokeWeight(1.5);
  player = new Player();
  //player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/ravel_bolero.mid"));
  //player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/musical_opfer_bwv-1079-4.mid"));
  player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/07a-lacr.mid"));
//player.load(dataPath("/Users/tom/Desktop/git/processing4music/midi/media/Queen - Bohemian Rhapsody.mid"));
  
  lastc = new Circle[player.channelCount];
  circles = new Circle[player.channelCount][12];
  for (int i=0; i<player.channelCount; i++) {
    x = 100+((width-200)/(player.channelCount-1))*i;
    y = height/2;
    for (int j = 0; j<12; j++) {
      circles[i][j] = new Circle(x, y, i, j);
    }
    println(x, y);
  }
  
  player.start();
}

void draw() {
  if (ch)
    background(255);
    
  int xn = 255-(player.maxN-player.minN);
  int xv = 255-(player.maxV-player.minV);

  for (Note n: player.getNotes()) {
  
    displayChannel = player.list.indexOf(n.channel);

    Circle c = circles[displayChannel][n.noteClass];
    // Velocity: 0-127
    size = map(n.velocity, player.minV, player.maxV, 75, 250);
    //size = (16*size/player.channelCount) - n.living*2;
    //alpha = 255/(size*0.01);
   
    //println(n.noteClass, n.octave, displayChannel, n.velocity, n.living, n.dying);
    
    color dc = color(
      map(n.noteClass, 0, 12, 0, 255),  // Hue (13 values to prevent duplication)
      //Saturation
      map(n.velocity, player.minV, player.maxV, xv, 255),
      // Brightness 
      map(n.note, player.minN, player.maxN, xn, 255)
      //255, 255
    );
    
    if (n.living == 0) {
      c.create(size, dc, n);
      lastc[displayChannel] = c;
    }
  }
   player.update();
  
  int i = 0;
  for (Circle[] cs : circles) {
    for (Circle c: cs) {
      if (lastc[i] == c)
        str = true;
      else
        str = false;
      c.display(str);
    }
    i+=1;
  }
  
}

void keyPressed() {
  if (key=='d')
    debug = !debug;
  else if (key == 'c')
    ch =! ch;
}
