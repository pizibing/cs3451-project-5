class Curve {
  Point A;
  Point B;
  Point C;
  Point D;
  Point[] curve;
  
  /**
   *constructor
   */
  Curve(Point A, Point B, Point C, Point D) {
    this.A = A;
    this.B = B;
    this.C = C;
    this.D = D;
    this.buildCurve(100);
  }
  
  /**
   * build a neville curve
   */
  void buildCurve(int resolution) {
    this.curve = new Point[resolution];
    float max_time = 3.0;
    float delta_time = 3.0 / this.curve.length;
    float curr_time = 0.0;
    for (int i = 0; i < this.curve.length; i++) {
      this.curve[i] = neville(A, B, C, D, curr_time);
      curr_time += delta_time;
    }
  }
  
  /**
   * draw the neville curve
   */
  void draw() {
    beginShape(LINES);
    for (int i = 0; i < this.curve.length; i++) {
      vertex(this.curve[i].x, this.curve[i].y, this.curve[i].z);
    }
    endShape();
  }
}
