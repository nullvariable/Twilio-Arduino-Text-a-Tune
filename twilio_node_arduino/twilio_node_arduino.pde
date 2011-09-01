
int incomingByte = 0;
String songs = "";
int speakerPin = 9;
int tempo = 300;


//c,c,d,c,f,e,,c,c,d,c,g,,f,,,,END
void makeAsong(String song) {
  Serial.println("phase1: " + song);
  char curNote = 0;
  int curBeats = 0;
  int songLen = 0;
  char curChar = 0;
  songLen = song.length() - 3;
  delay(1000);
  Serial.println(songLen);
  for (int i = 0; i < songLen; i++) {
    curChar = song.charAt(i);
   if (curNote == 0) { curNote = curChar; }
   if (curChar == ',') {
     curBeats++;  
   } else {
     if (curBeats > 0) {
       if (curNote == ' ') {
         delay(tempo*curBeats); //pause for spaces
       } else {
         playNote(curNote, curBeats*tempo); //play the note according to our preset tempo
       }
         curNote = curChar;
         curBeats = 0;
     }
   }
   Serial.println("curNote: " + String(curNote) + " curBeats: " + String(curBeats) + " curChar: " + String(curChar));
  }//end for
  
}
//source: http://www.oomlout.com/a/products/ardx/circ-06
void playNote(char note, int duration) {
  Serial.println("playing: " + note);
  char names[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C' };
  int tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956 };
  
  // play the tone corresponding to the note name
  for (int i = 0; i < 8; i++) {
    if (names[i] == note) {
      playTone(tones[i], duration);
    }
  }
}
void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);
  }
}

void setup() 
{ 
  pinMode(speakerPin, OUTPUT);
  Serial.begin(9600); 
  delay(100);
  // signal that we're ready
  Serial.println(" Ready "); 
  playNote('c', 1 * tempo);
  playNote('C', 1 * tempo);
} 

void loop() 
{ 
  if (Serial.available() > 0) {
		// read the incoming byte:
		incomingByte = Serial.read();

		// say what you got:
		Serial.print("I received: " );
                Serial.println(incomingByte, BYTE); // print as a raw byte value
                
                char thisChar = char(incomingByte);
                songs += thisChar;
                if (songs.endsWith("END")) {
                  Serial.println("Playing: " + songs);
                  makeAsong(songs);
                  songs = "";
                }
	}
}


