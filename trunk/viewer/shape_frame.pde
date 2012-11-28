/**
 * 2d frame defining a 3d shape that is symetric around an axis
 */
class ShapeFrame {
  Point[] frame;
  int frame_size;
  CornerTable corner_table;
  Point[][] outline;
 
  /**
   * constructor
   */
  ShapeFrame() {
    this.frame = new Point[5];
    this.frame_size = 0;
    this.corner_table = new CornerTable();
    this.outline = new Point[0][0];
  }
  
  /**
   * alight the shape's edge to the y-axis
   */
  void alignEdge() {
    if (frame_size == 0) {
      return;
    }
    this.frame[0].x = 0.0;
    this.frame[frame_size - 1].x = 0.0;
    for(int i = 1; i < this.frame_size - 1; i++) {
      if (this.frame[i].x < 0) {
        this.frame[i].x = 0;
      }
    }
  }
  
  /**
   * add point to frame
   */
  void addVertex(Point A) {
    // resize
    if (this.frame_size >= this.frame.length) {
      Point[] tframe = new Point[2 * this.frame.length];
      for (int i = 0; i < this.frame.length; i++) {
        tframe[i] = this.frame[i];
      }
      this.frame = tframe;
    }
    // add
    if (this.frame_size < 1) {
      this.frame[frame_size] = A;
    }
    else {
      // find closest edge
      int closest = this._getClosestIndex(A);
      for (int i = this.frame_size; i > closest; i--) {
        this.frame[i] = this.frame[i - 1];
      }
      this.frame[closest] = A;
    }
    this.frame_size++;
  }
  
  /**
   * get index of closest point (internal)
   * @param A point to find closest to
   * @return index of closest
   */
  int _getClosestIndex(Point A) {
    int closest = 0;
    for (int i = 1; i < frame_size; i++) {
      if (A.dist(frame[i]) < A.dist(frame[closest])) {
        closest = i;
      }
    }
    return closest;
  }
  
  /**
   * get closest point to given
   * @param A point to find closest to
   * @return closest point
   */
  Point getClosestVertex(Point A) {
    return this.frame[this._getClosestIndex(A)];
  }
  
  /**
   * delete point closest to given
   */
  void deleteClosestVertex(Point A) {
    if (this.frame_size < 4) {
      return;
    }
    // find closest
    int closest = this._getClosestIndex(A);
    // shift points
    for (int i = closest + 1; i < frame_size; i++) {
      this.frame[i - 1] = this.frame[i];
    }
    // remove point
    this.frame_size--;
  }
  
  /**
   * create a triangle mesh for the shape
   * @param resolution number of sides in final mesh
   */
  void createOutlineAndMesh(int resolution) {
    if (this.frame_size < 3) {
      return;
    }
    // build outline
    this.outline = new Point[resolution][this.frame_size];
    // fill in top and bottom
    for (int i = 0; i < resolution; i++) {
      this.outline[i][0] = new Point(this.frame[0]);
      this.outline[i][this.frame_size - 1] = new Point(this.frame[this.frame_size - 1]);
    }
    // fill in first
    for (int i = 1; i < this.frame_size - 1; i++) {
      this.outline[0][i] = this.frame[i];
    }
    // calc displacements
    Vector[] disp = new Vector[this.frame_size - 2];
    for (int i = 0; i < disp.length; i++) {
      disp[i] = new Vector(this.frame[0], this.frame[i + 1]);
    }
    // rotate displacements
    float angle = (2 * PI) / resolution;
    Vector I = new Vector(1, 0, 0);
    Vector J = new Vector(0, 0, 1);
    for (int i = 0; i < resolution; i++) {
      for (int j = 0; j < disp.length; j++) {
        disp[j].rotate(angle, I, J);
        this.outline[i][j+1] = add(this.outline[i][0], disp[j]);
      }
    }
    // build mesh from outline
    this.corner_table.initTables();
    for (int i = 0; i < this.outline.length; i++) {
      int in = (i + 1) % this.outline.length;
      // start triangle
      Point A = this.outline[i][1];
      Point B = this.outline[i][0];
      Point C = this.outline[in][1];
      int ai = this.corner_table.addVertex(A);
      int bi = this.corner_table.addVertex(B);
      int ci = this.corner_table.addVertex(C);
      this.corner_table.addTriangle(ai, bi, ci);
      // end triangle
      int l = this.outline[i].length - 1;
      A = this.outline[i][l-1];
      B = this.outline[in][l-1];
      C = this.outline[in][l];
      ai = this.corner_table.addVertex(A);
      bi = this.corner_table.addVertex(B);
      ci = this.corner_table.addVertex(C);
      this.corner_table.addTriangle(ai, bi, ci);
      // quads
      Point D = null;
      int di = -1;
      for (int j = 1; j < this.outline[i].length - 2; j++) {
        A = this.outline[i][j];
        B = this.outline[in][j];
        C = this.outline[in][j+1];
        D = this.outline[i][j+1];
        ai = this.corner_table.addVertex(A);
        bi = this.corner_table.addVertex(B);
        ci = this.corner_table.addVertex(C);
        di = this.corner_table.addVertex(D);
        this.corner_table.addTriangle(ai, bi, ci);
        this.corner_table.addTriangle(ai, ci, di);
      }
    }
  }
  
  /**
   * draw the frame
   */
  void drawFrame() {
    beginShape(LINES);
    for (int i = 0; i < this.frame_size - 1; i++) {
      vertex(frame[i].x, frame[i].y, frame[i].z);
      vertex(frame[i+1].x, frame[i+1].y, frame[i+1].z);
    }
    endShape();
    for (int i = 0; i < this.frame_size; i++) {
      show(this.frame[i], 5.0);
    }
  }
  
  /**
   * draw the outline
   */
  void drawOutline() {
    if (this.frame_size < 3) {
      return;
    }
    for (int i = 0; i < this.outline.length; i++) {
      beginShape(LINES);
      for (int j = 0; j < this.outline[i].length - 1; j++) {
        vertex(outline[i][j].x, outline[i][j].y, outline[i][j].z);
        vertex(outline[i][j+1].x, outline[i][j+1].y, outline[i][j+1].z);
      }
      endShape(CLOSE);
    }
    for (int i = 0; i < this.outline[0].length; i++) {
      beginShape(LINES);
      for (int j = 0; j < this.outline.length - 1; j++) {
        vertex(outline[j][i].x, outline[j][i].y, outline[j][i].z);
        vertex(outline[j+1][i].x, outline[j+1][i].y, outline[j+1][i].z);
      }
      endShape(CLOSE);
    }
  }
  
  /**
   * draw the mesh
   */
  void drawMesh(boolean smooth) {
    this.corner_table.drawTriangles(smooth);
  }
}
