/**
 * Robert Kernan
 * Qiqin Xie
 * Raymond Garrison  
 */

import processing.opengl.*;
import javax.media.opengl.*; 
import javax.media.opengl.glu.*; 
import java.nio.*;

GL gl; 
GLU glu;

// view
Vector I;
Vector J;
Vector K;
Point Q;
Point F;
Point E;
Vector U;
// display help
boolean show_help = false;
// edit mode
boolean mode_edit = false;
Point selected = null;
// shapes
int curr_shape = 0;
int NUM_SHAPES = 4;
ShapeFrame[] shapes = new ShapeFrame[NUM_SHAPES];

void initView() {
  Q = new Point(0, 0, 0);
  I = new Vector(1, 0, 0);
  J = new Vector(0, 1, 0);
  K = new Vector(0, 0, 1);
  F = new Point(0, 0, 0);
  E = new Point(0, 0, 12000);
  U = new Vector(0, 1, 0);
  setFrame(Q, I, J, K);
}

void setup() {
  size(1024, 768, OPENGL); 
  setColors();
  sphereDetail(12);
  rectMode(CENTER);
  glu = ((PGraphicsOpenGL)g).glu;
  PGraphicsOpenGL pgl = (PGraphicsOpenGL)g;
  gl = pgl.beginGL();
  pgl.endGL();
  // load font
  textFont(loadFont("Courier-14.vlw"), 12);
  // init view
  initView();
  // init
  for (int i = 0; i < NUM_SHAPES; i++) {
    shapes[i] = new ShapeFrame();
  }
}

void draw() {
  hint(DISABLE_DEPTH_TEST);
  background(white);
  // ui
  camera();
  lights();
  fill(black);
  int header_line = 0;
  int footer_line = 0;
  scribeFooter("press '?' to toggle help", footer_line++);
  if (show_help) {
    scribe("VIEW", header_line++);
    scribe("  drag: mousedrag", header_line++);
    scribe("  zoom: 'd' + mousedrag", header_line++);
    scribe("EDIT SHAPE (toggle with 'e')", header_line++);
    scribe("  change shape: '1'-'4'", header_line++);
    scribe("  add: 'a' + mouseclick", header_line++);
    scribe("  del: 'x' + mouseclick", header_line++);
    scribe("  sel: mouseclick", header_line++);
    scribe("  mov: sel + mousedrag", header_line++);
  }
  else {
    scribe("CS3451-A Fall 2012 - Project 5", header_line++);
  }
  // edit shape
  if (mode_edit) {
    stroke(red);
    fill(red);
    shapes[curr_shape].draw();
    noStroke();
    fill(black);
    scribeFooter("--EDIT SHAPE (" + (curr_shape + 1) + ")--", footer_line++);
    noFill();
  }
  // move view
  boolean moved = false;
  if (!keyPressed && mousePressed) {
    // rotate E around F
    E = rotate(E, PI * float(mouseX - pmouseX) / width, I, K, F);
    E = rotate(E, PI * float(mouseY - pmouseY) / width, J, K, F);
  }
  // draw everything else
  hint(ENABLE_DEPTH_TEST);
  
}

void mousePressed() {
  if (mode_edit) {
    if (keyPressed) {
      // add point
      if (key == 'a') {
        shapes[curr_shape].add(getMouse());
      }
      // remove point
      if (key == 'x') {
        shapes[curr_shape].deleteClosest(getMouse());
      }
    }
    // select point
    else {
      selected = shapes[curr_shape].getClosest(getMouse());
    }
  }
} 

void mouseDragged() {
  if (mode_edit) {
    // move selected point
    if (selected != null) {
      selected.add(getMouseDrag());
      shapes[curr_shape].alignEdge();
    }
  }
}

void keyReleased() {
  // toggle edit mode
  if (key == 'e') {
    mode_edit = !mode_edit; 
  }
  // toggle help dialog
  if (key == '?') {
    show_help = !show_help;
  }
}

void keyPressed() {
  // switch current shape
  if (key == '1') {
    curr_shape = 0;
  }
  else if (key == '2') {
    curr_shape = 1;
  }
  else if (key == '3') {
    curr_shape = 2;
  }
  else if (key == '4') {
    curr_shape = 3;
  }
}
