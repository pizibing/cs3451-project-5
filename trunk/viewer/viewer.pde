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
Vector vI;
Vector vJ;
Vector vK;
Point vQ;
Point vF;
Point vE;
Vector vU;
// display help
boolean show_help = false;
// shading mode
boolean smooth_shading = false;
// display mode
boolean show_mesh = false;
boolean show_tnorm = false;
boolean show_vnorm = false;
// edit mode
boolean mode_edit = false;
Point selected = null;
// shapes
int curr_shape = 0;
int num_shapes = 4;
int num_sides = 6;
ShapeFrame[] shapes = new ShapeFrame[num_shapes];
ShapeMorph morph;

void initView() {
  vQ = new Point(0, 0, 0);
  vI = new Vector(1, 0, 0);
  vJ = new Vector(0, 1, 0);
  vK = new Vector(0, 0, 1);
  vF = new Point(0, 0, 0);
  vE = new Point(0, 0, 3000);
  vU = new Vector(0, 1, 0);
  setFrame(vQ, vI, vJ, vK);
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
  for (int i = 0; i < num_shapes; i++) {
    shapes[i] = new ShapeFrame(num_sides);
  }
  morph = new ShapeMorph(shapes[0].corner_table, shapes[1].corner_table);
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
  scribeFooter("display: " + ((show_mesh) ? "SOLID" : "PROFILE") + ", " +
               "shading: " + ((smooth_shading) ? "SMOOTH" : "FLAT"), footer_line++);
  scribeFooter("current shape: " + curr_shape + ", num sides = " + shapes[curr_shape].num_sides, footer_line++);
  if (show_help) {
    scribe("VIEW", header_line++);
    scribe("  drag:  mousedrag", header_line++);
    scribe("  zoom:  'd' + mousedrag", header_line++);
    scribe("  mesh:  'm' (toggle)", header_line++);
    scribe("  shade: 'g' (toggle)", header_line++);
    scribe("  vnorm: 'v' (toggle)", header_line++);
    scribe("  tnorm: 't' (toggle)", header_line++);
    scribe("  move the origin: 'p' + mousedrag", header_line++);
    scribe("  move the axis: 'o' + mousedrag", header_line++);
    scribe("  rotate the shape: 'l' + mousedrag", header_line++);
    scribe("EDIT SHAPE (toggle with 'e')", header_line++);
    scribe("  change shape: '1'-'4'", header_line++);
    scribe("  add: 'i' + mouseclick", header_line++);
    scribe("  del: 'd' + mouseclick", header_line++);
    scribe("  sel: mouseclick", header_line++);
    scribe("  mov: sel + mousedrag", header_line++);
    scribe("  make convex: 'C'", header_line++);
  }
  else {
    scribe("CS3451-A Fall 2012 - Project 5", header_line++);
  }
  // edit shape
  if (mode_edit) {
    stroke(red);
    fill(red);
    shapes[curr_shape].drawFrame();
    noStroke();
    fill(black);
    scribeFooter("--EDIT SHAPE (" + (curr_shape + 1) + ")--", footer_line++);
    noFill();
  }
  // move view
  else {
    boolean moved = true;
    if (!keyPressed && mousePressed) {
      vE = rotate(vE, PI * float(mouseX - pmouseX) / width, vI, vK, vF);
      vE = rotate(vE, -PI * float(mouseY - pmouseY) / width, vJ, vK, vF);
      moved = true;
    }
    if (keyPressed && key == 'd'&& mousePressed) {
      vE.add(mult(vK, -float(mouseY - pmouseY)));
      moved = true;
    }
    if (moved) {
      setFrame(vQ, vI, vJ, vK);
    }
  }
  // enable z-buffer
  hint(ENABLE_DEPTH_TEST);
  // setup scene lights
  Vector Li = add(new Vector(vE, vF), mult(vJ, 0.1 * (new Vector(vE, vF)).norm()));
  directionalLight(255, 255, 255, Li.x, Li.y, Li.z);
  specular(255, 255, 0);
  shininess(5);
  // move camera
  camera(vE.x, vE.y, vE.z, vF.x, vF.y, vF.z, vU.x, vU.y, vU.z);
  // draw mesh
  if (show_mesh) {
    fill(cyan);
    stroke(black);
    shapes[curr_shape].drawMesh(smooth_shading);
    noFill();
    noStroke();
  }
  else {
    stroke(black);
    shapes[curr_shape].drawOutline();
    noStroke();
  }
  if (show_tnorm) {
    stroke(orange);
    shapes[curr_shape].corner_table.drawTriangleNormals();
    noStroke();
  }
  if (show_vnorm) {
    stroke(orange);
    shapes[curr_shape].corner_table.drawVertexNormals();
    noStroke();
  }
}

void mousePressed() {
  if (mode_edit) {
    if (keyPressed) {
      // add point
      if (key == 'i') {
        shapes[curr_shape].addVertex(getMouse());
        shapes[curr_shape].alignEdge();
        shapes[curr_shape].createOutlineAndMesh();
      }
      // remove point
      if (key == 'd') {
        shapes[curr_shape].deleteClosestVertex(getMouse());
        shapes[curr_shape].alignEdge();
        shapes[curr_shape].createOutlineAndMesh();
      }
    }
    // select point
    else {
      selected = shapes[curr_shape].getClosestVertex(getMouse());
    }
  }
} 

void mouseDragged() {
  if (mode_edit) {
    // scale the shape
    if (keyPressed && key == 'C') {
      float xscale = mouseX - pmouseX;
      float yscale = mouseY - pmouseY;
      //shapes[curr_shape].scaleBy(new Vector(((xscale >= 0) ? xscale : 0), ((yscale >= 0) ? yscale : 0), 0));
      shapes[curr_shape].alignEdge();
      shapes[curr_shape].createOutlineAndMesh();
    }
    // move the shape
    if (keyPressed && key == 'o') {
      
    }
    // move the origin
    if (keyPressed && key == 'p') {
      shapes[curr_shape].moveBy(add(mult(vI, 0.5 * (mouseX - pmouseX)), mult(vJ, -0.5 * (mouseY - pmouseY))));
      shapes[curr_shape].createOutlineAndMesh();
    }
    // move the origin
    
    // move selected point
    else if (selected != null) {
      selected.add(getMouseDrag());
      shapes[curr_shape].alignEdge();
      shapes[curr_shape].createOutlineAndMesh();
    }
  }
}

void keyReleased() {
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
  // toggle display mode
  if (key == 'm') {
    show_mesh = !show_mesh;
  }
  // toggle shading mode
  if (key == 'g') {
    smooth_shading = !smooth_shading;
  }
  // toggle edit mode
  if (key == 'e') {
    mode_edit = !mode_edit;
  }
  // toggle help dialog
  if (key == '?') {
    show_help = !show_help;
  }
  // toggle triangle normals
  if (key == 't') {
    show_tnorm = !show_tnorm;
  }
  // toggle vertex normals
  if (key == 'v') {
    show_vnorm = !show_vnorm;
  }
  // make convex
  if (key == 'C') {
    shapes[curr_shape].makeConvex();
  }
  // write shapes
  if (key == 'W') {
    String filename = "data/start.pts";
    try {
      saveScene(filename);
      println("saved scene to file: " + filename);
    }
    catch (IOException ioe) {
      println(ioe);
      println("ERROR: couldn't save to file: " + filename);
    }
  }
  // load shapes
  if (key == 'L') {
    String filename = "data/start.pts";
    try {
      loadScene(filename);
      println("loaded scene from file: " + filename);
    }
    catch (IOException ioe) {
      println(ioe.toString());
      println("ERROR: couldn't load from file: " + filename);
    }
  }
}

void keyPressed() {
  if (key == ',') {
    shapes[curr_shape].num_sides = (shapes[curr_shape].num_sides - 1 < 3) ? 3 : shapes[curr_shape].num_sides - 1;
    shapes[curr_shape].createOutlineAndMesh();
  }
  if (key == '.') {
    shapes[curr_shape].num_sides++;
    shapes[curr_shape].createOutlineAndMesh();
  }
}
