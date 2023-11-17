String audio_input = "/home/simon/Documents/GitHub/processing-squares/01 - En Calme Au Large.wav";
String image_input = "/home/simon/Documents/GitHub/processing-squares/cover.png";

import ddf.minim.analysis.BeatDetect;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
BeatDetect beat;

int maxpal = 812;
int numpal = 0;
color[] goodcolor = new color[maxpal];
int size = 95;
int cols, rows;
ArrayList<PVector> usedPositions = new ArrayList<PVector>();
int marginh, marginv;

PGraphics img;

void setup() {
  size(1280, 800);
  background(0);

  cols = width / size;
  rows = height / size;
  marginh = int((width - cols * size) / 2);
  marginv = int((height - rows * size) / 2);

  minim = new Minim(this);
  
  player = minim.loadFile(audio_input);
  
  player.play();
  
  beat = new BeatDetect();
  beat.setSensitivity(550);

  img = createGraphics(width, height);
  pickColourFromPallet(image_input);
}

void draw() {
  beat.detect(player.mix);
  if (beat.isOnset()) {
    beatAction();
  }
}

void beatAction() {
  int xCoord, yCoord;
  PVector newCoord;

  do {
    xCoord = int(random(cols)) * size;
    yCoord = int(random(rows)) * size;
    newCoord = new PVector(xCoord, yCoord);
  } while (positionAlreadyUsed(newCoord));

  fill(goodcolor[int(random(numpal))]);
  rect(marginh + xCoord, marginv + yCoord, size, size);

  usedPositions.add(newCoord);
}

boolean positionAlreadyUsed(PVector pos) {
  for (PVector usedPos : usedPositions) {
    if (pos.equals(usedPos)) {
      return true;
    }
  }
  return false;
}

void pickColourFromPallet(String fn) {
  PImage loadedImage = loadImage(fn);
  for (int x = 0; x < loadedImage.width; x++) {
    for (int y = 0; y < loadedImage.height; y++) {
      color c = loadedImage.get(x, y);
      boolean exists = false;
      for (int n = 0; n < numpal; n++) {
        if (c == goodcolor[n]) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        if (numpal < maxpal) {
          goodcolor[numpal] = c;
          numpal++;
        }
      }
    }
  }
}
