/**
 * 2d frame defining a 3d shape that is symetric around an axis
 */
class ShapeFrame {
  Point[] frame;
  int frame_size;
 
  /**
   * constructor
   */
  ShapeFrame() {
    this.frame = new Point[5];
    this.frame_size = 0;
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
  void add(Point A) {
    // resize
    if (frame_size >= frame.length) {
      Point[] tframe = new Point[2 * this.frame.length];
      for (int i = 0; i < this.frame.length; i++) {
        tframe[i] = this.frame[i];
      }
      this.frame = tframe;
    }
    if (this.frame_size < 2) {
      this.frame[frame_size++] = A;
    }
    else {
      this.frame[this.frame_size] = this.frame[this.frame_size - 1];
      this.frame[this.frame_size - 1] = A;
      this.frame_size++;
    }
    this.alignEdge();
  }
  
  /**
   * get closest point to given
   * @param A point to find closest to
   * @return closest point
   */
  Point getClosest(Point A) {
    int closest = 0;
    for (int i = 1; i < frame_size; i++) {
      if (A.dist(frame[i]) < A.dist(frame[closest])) {
        closest = i;
      }
    }
    return frame[closest];
  }
  
  /**
   * delete point closest to given
   */
  void deleteClosest(Point A) {
    if (this.frame_size < 4) {
      return;
    }
    // find closest
    int closest = 0;
    for (int i = 1; i < this.frame_size; i++) {
      if (A.dist(this.frame[i]) < A.dist(this.frame[closest])) {
        closest = i;
      }
    }
    // shift points
    for (int i = closest + 1; i < frame_size; i++) {
      this.frame[i - 1] = this.frame[i];
    }
    // remove point
    this.frame_size--;
    this.alignEdge();
  }
  
  /**
   * draw the frame
   */
  void draw() {
    pushMatrix();
    for (int i = 0; i < this.frame_size; i++) {
      show(this.frame[i], 5.0);
    }
    noFill();
    beginShape();
    for (int i = 0; i < this.frame_size; i++) {
      vertex(this.frame[i].x, this.frame[i].y, this.frame[i].z);
    }
    endShape();
    popMatrix();
  }
}
