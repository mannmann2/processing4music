import java.util.concurrent.ConcurrentHashMap;
import java.util.Set;
import java.util.HashSet;

class Player implements Receiver {
  Sequencer sequencer;
  // Concurrent, so it can be accessed by the Processing main thread, and the
  // midi player thread without crashing.
  ConcurrentHashMap<Integer, Note> midiData = new ConcurrentHashMap<Integer, Note>();
  Set<Integer> channels = new HashSet<Integer>();
  List<Integer> list;
  int channelCount;
  
  public void load(String path) {
    File midiFile = new File(path);
    try {
      sequencer = MidiSystem.getSequencer();
      if (sequencer == null) {
        println("No midi sequencer");
        exit();
      } else {
        sequencer.open();
        Transmitter transmitter = sequencer.getTransmitter();
        transmitter.setReceiver(this);
        Sequence seq = MidiSystem.getSequence(midiFile);
        sequencer.setSequence(seq);
        
        Track[] tracks = seq.getTracks();
        println("No. of tracks:", tracks.length);
        
        for (int i = 0; i<tracks.length; i++) {
          Track myTrack = tracks[i];
          println("Track", i + ":", myTrack.size(), "events");
          for (int j = 0; j< myTrack.size(); j++) {

            MidiEvent ev = myTrack.get(j);
            if (ev.getMessage() instanceof ShortMessage) {
              ShortMessage m =  (ShortMessage) ev.getMessage();
      
              int cmd = m.getCommand();
              if (cmd == ShortMessage.NOTE_ON) {
                channels.add(m.getChannel());
                break;
              }
              
              // log note-on or note-off events
              //if (cmd == ShortMessage.NOTE_OFF || cmd == ShortMessage.NOTE_ON) {
              //  print( (cmd==ShortMessage.NOTE_ON ? "NOTE_ON" : "NOTE_OFF") + "; ");
              //  print("channel: " + m.getChannel() + "; ");
              //  print("note: " + m.getData1() + "; ");
              //  println("velocity: " + m.getData2());
              //}
            }
          }
        }
        list = new ArrayList<Integer>(channels);
        channelCount = list.size();
        println("Channels:", channelCount);
      }
    } 
    catch(Exception e) {
      e.printStackTrace();
      exit();
    }
  }

  public void start() {
    sequencer.start();
  }

  public void update() {
    for (Note n : midiData.values()) {
      if (n.dying > 0) {
        //n.dying++;
        //if (n.dying > 10) {
          midiData.remove(n.id);
        //}
      } else {
        n.living++;
      }
    }
  }

  public float getBPM() {
    return sequencer.getTempoInBPM();
  }

  public Collection<Note> getNotes() {
    return midiData.values();
  }

  public void send(MidiMessage message, long t) {
    if (message instanceof ShortMessage) {
      ShortMessage sm = (ShortMessage) message;
      int cmd = sm.getCommand(); 
      if (cmd == ShortMessage.NOTE_ON || cmd == ShortMessage.NOTE_OFF) {
        int channel = sm.getChannel();      
        int note = sm.getData1();
        int velocity = sm.getData2();
        int id = channel * 1000 + note;
        if (cmd == ShortMessage.NOTE_ON && velocity > 0) {
          //println("add-", channel, note, velocity);
          midiData.put(id, new Note(id, note, channel, velocity));
        } else {
          midiData.get(id).dying++;
        }
      }
    }
  }

  @Override public void close() {
  }
}
