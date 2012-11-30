/**
 * 2d frame defining a 3d shape that is symetric around an axis
 */
class ShapeFrame {
  int num_sides;
  Point[] frame;
  int frame_size;
  CornerTable corner_table;
  Point[][] outline;
  Point origin;
  float spin_angle;
  Vector axis;
 
  /**
   * constructor
   */
  ShapeFrame(int num_sides) {
    this.num_sides = num_sides;
    this.frame = new Point[5];
    this.frame_size = 0;
    this.corner_table = new CornerTable();
    this.outline = new Point[0][0];
    this.origin = new Point();
    this.spin_angle = 0;
    this.axis = new Vector(0, 1, 0);
  }
  
  /**
   * move shape position
   * @param V displacement
   */
  void moveBy(Vector V) {
    this.origin.add(V);
  }
  
  /**
   * rotate shape axis
   * @param angle rotation angle
   * @param I vector defining rotation plane
   * @param J vector defining rotation plane
   */
  void rotateAxis(float angle, Vector I, Vector J) {
    println("rot angle=" + angle);
    this.axis.rotate(angle, I, J);
  }
  
  /**
   * spin shape
   * @param angle spin angle
   */
  void spin(float angle) {
    this.spin_angle += angle;
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
    int ind = this._getClosestIndex(A);
    if (ind < 0) {
      return null;
    }
    return this.frame[ind];
  }
  
  /**
   * remove given index
   */
  void _deleteIndex(int index) {
    for (int i = index + 1; i < frame_size; i++) {
      this.frame[i - 1] = this.frame[i];
    }
    // remove point
    this.frame_size--;
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
    this._deleteIndex(closest);
  }
  
  /**
   * make the shape convex
   */
  void makeConvex() {
    boolean finished = false; 
    while(finished == false){    
      finished = true;
      for(int k = 0; k < this.frame_size-1; k++){
        if(this.frame[0].y < this.frame[k].y){
         this.frame[0].y = this.frame[k].y;
         finished = false;
       }
      }    
      for(int l = 0; l < this.frame_size-1; l++){
        if(this.frame[this.frame_size-1].y > this.frame[l].y){
          this.frame[this.frame_size-1].y = this.frame[l].y;
          finished = false;
        }
      }
      for (int j = 1; j < this.frame_size-1; j++){
        if ( isLeft(this.frame[j-1], this.frame[j], this.frame[j+1])) {
          this._deleteIndex(j);
          j--;
          finished = false;
        }
      }
      createOutlineAndMesh();
    }  
  }
  
  /**
   * create a triangle mesh for the shape
   */
  void createOutlineAndMesh() {
    if (this.frame_size < 3) {
      return;
    }
    // build outline
    this.outline = new Point[num_sides][this.frame_size];
    // fill in top and bottom
    for (int i = 0; i < num_sides; i++) {
      this.outline[i][0] = (new Point(this.frame[0])).add(this.origin);
    }
    // fill in first
    for (int i = 1; i < this.frame_size; i++) {
      this.outline[0][i] = this.frame[i];
    }
    // calc displacements
    Vector rI = new Vector(1, 0, 0);
    Vector rK = new Vector(0, 0, 1);
    Vector[] disp = new Vector[this.frame_size - 1];
    for (int i = 0; i < disp.length; i++) {
      disp[i] = (new Vector(this.frame[0], this.frame[i + 1])).rotate(this.spin_angle, rI, rK);
    }
    // rotate displacements
    float angle = (2.0 * PI) / num_sides;
    for (int i = 0; i < num_sides; i++) {
      for (int j = 0; j < disp.length; j++) {
        this.outline[i][j+1] = add(this.outline[i][0], disp[j]);
        disp[j].rotate(angle, rI, rK);
      }
    }
    // build mesh from outline
    this.corner_table.initTables();
    for (int i = 0; i < this.outline.length; i++) {
      int j = 0;
      int n = (i + 1) % this.outline.length;
      // start triangle
      int a = this.corner_table.addVertex(this.outline[i][j]);
      int b = this.corner_table.addVertex(this.outline[i][j+1]);
      int c = this.corner_table.addVertex(this.outline[n][j+1]);
      this.corner_table.addTriangle(a, b, c);
      // middle triangles
      for (j = 1; j < this.outline[i].length - 2; j++) {
        a = this.corner_table.addVertex(this.outline[n][j]);
        b = this.corner_table.addVertex(this.outline[i][j]);
        c = this.corner_table.addVertex(this.outline[i][j+1]);
        this.corner_table.addTriangle(a, b, c);
        a = this.corner_table.addVertex(this.outline[n][j]);
        b = this.corner_table.addVertex(this.outline[i][j+1]);
        c = this.corner_table.addVertex(this.outline[n][j+1]);
        this.corner_table.addTriangle(a, b, c);
      }
      // end triangle
      a = this.corner_table.addVertex(this.outline[n][j]);
      b = this.corner_table.addVertex(this.outline[i][j]);
      c = this.corner_table.addVertex(this.outline[i][j+1]);
      this.corner_table.addTriangle(a, b, c);
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
    /*for (int i = 0; i < this.outline[0].length; i++) {
      beginShape(LINES);
      for (int j = 0; j < this.outline.length - 1; j++) {
        vertex(outline[j][i].x, outline[j][i].y, outline[j][i].z);
        vertex(outline[j+1][i].x, outline[j+1][i].y, outline[j+1][i].z);
      }
      endShape(CLOSE);
    }*/
    beginShape(LINES);
    stroke(green);
    vertex(this.frame[0].x, this.frame[0].y, this.frame[this.frame_size-1].z);
    vertex(this.axis.x * 200.0, this.axis.y * 200.0, this.axis.z * 200.0);
    endShape();
  }
  
  /**
   * draw the mesh
   */
  void drawMesh(boolean smooth) {
    this.corner_table.drawTriangles(smooth);
  }
  
  /**
   * draw mesh normals
   */
  void drawNormals() {
    this.corner_table.drawVertexNormals();
    this.corner_table.drawTriangleNormals();
  }
}
