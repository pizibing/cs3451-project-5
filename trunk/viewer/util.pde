/**
 * write text at top of screen
 * @param s text to write
 * @param i line to write on (from top)
 */
void scribe(String s, int i) {
  text(s, 10, i * 15 + 20);
}

/**
 * write text at bottom of screen
 * @param s text to write
 * @param i line to write on (from bottom)
 */
void scribeFooter(String s, int i) {
  text(s, 10, height - 20 - i * 15);
}

/**
 * draw image at given position
 * @param pic picture to draw
 * @param x x-coordinate
 * @param y y-coordinate
 */
void drawImage(PImage pic, float x, float y) {
  image(pic, x, y, pic.width / 2, pic.height / 2);
}

color red,
      dred,
      magenta,
      dmagenta,
      blue,
      dblue,
      cyan,
      dcyan,
      green,
      dgreen,
      yellow,
      dyellow,
      orange,
      dorange,
      brown,
      dbrown,
      white,
      black,
      grey,
      metal;

void setColors() {
  red = color(250, 0, 0);
  dred = color(150, 0, 0);
  magenta = color(250, 0, 250);
  dmagenta = color(150, 0, 150);
  blue = color(0, 0, 250);
  dblue = color(0, 0, 150);
  cyan = color(0, 250, 250);
  dcyan = color(0, 150, 150);
  green = color(0, 250, 0);
  dgreen = color(0, 150, 0);
  yellow = color(250, 250, 0);
  dyellow = color(150, 150, 0);
  orange = color(250, 150, 0);
  dorange = color(150, 50, 0);
  brown = color(150, 150, 0);
  dbrown = color(50, 50, 0);
  white = color(250, 250, 250);
  black = color(0, 0, 0);
  grey = color(100, 100, 100);
  metal = color(150, 150, 250);
}
