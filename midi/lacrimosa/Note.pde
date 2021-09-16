class Note {
  
  int id;
  
  int note;
  int noteClass;
  int octave;
  int channel;
  
  int velocity;
  int living;
  int dying;
  
  Note(int ID, int n, int c, int v) {
    
    id = ID;
    note = n;
    noteClass = n%12;
    octave = floor(n/12);
    channel = c;
    velocity = v;
  }
}
