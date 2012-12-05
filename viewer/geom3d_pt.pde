/**
 * get mouse screen position (2d)
 * @return 2d mouse position
 */
Point getMouse() {
  return new Point(mouseX, mouseY, 0);
}

/**
 * Point class
 */
class Point {
  float x;
  float y;
  float z;
  
  /**
   * constructor
   * create point at origin
   */
  Point() {
    this.x = 0.0;
    this.y = 0.0;
    this.z = 0.0;
  }
  
  /**
   * constructor
   * create point at given coordinates
   * @param x x-coordinate
   * @param y y-coordinate
   * @param z z-coordinate
   */
  Point(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /**
   * copy constructor
   * @param other point to copy
   */
  Point(Point other) {
    this.x = other.x;
    this.y = other.y;
    this.z = other.z;
  }
  
  /**
   * set point to given coordinates
   * @param x x-coordinate
   * @param y y-coordinate
   * @param z z-coordinate
   */
  void set(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /**
   * set point to given point
   * @param P point to set equal to
   */
  void set(Point P) {
    this.x = P.x;
    this.y = P.y;
    this.z = P.z;
  }
  
  /**
   * check if two points are equal
   * @param other point to check equality with
   * @return true: equal, else false
   */
  boolean equals(Point other) {
    if (!(abs(this.x - other.x) < 0.0001)) {
      return false;
    }
    else if (!(abs(this.y - other.y) < 0.0001)) {
      return false;
    }
    else if (!(abs(this.z - other.z) < 0.0001)) {
      return false;
    }
    return true;
  }
  
  /**
   * add points
   * @param P point to add
   * @return this
   */
  Point add(Point P) {
    this.x += P.x;
    this.y += P.y;
    this.z += P.z;
    return this;
  }
  
  /**
   * add vector to point
   * @param V vector to add
   * @return this
   */
  Point add(Vector V) {
    this.x += V.x;
    this.y += V.y;
    this.z += V.z;
    return this;
  }
  
  /**
   * subtract points
   * @param P point to subtract
   * @return this
   */
  Point sub(Point P) {
    this.x -= P.x;
    this.y -= P.y;
    this.z -= P.z;
    return this;
  }
  
  /**
   * multiply point by scalar
   * @param s scalar to multiply by
   * @return this
   */
  Point mult(float s) {
    this.x *= s;
    this.y *= y;
    this.z *= z;
    return this;
  }
  
  /**
   * divide point by scalar
   * @param s scalar to divide by
   * @return this
   */
  Point div(float s) {
    this.x /= s;
    this.y /= s;
    this.z /= s;
    return this;
  }
  
  /**
   * distance between points
   * @param P point to find distance to
   * @return distance to P
   */
  float dist(Point P) {
    float dx = P.x - this.x;
    float dy = P.y - this.y;
    float dz = P.z - this.z;
    return sqrt(sq(dx) + sq(dy) + sq(dz));
  }
  
  /**
   * copy point
   * @return copy of this
   */
  Point copy() {
    Point copy = new Point();
    copy.set(this);
    return copy;
  }
}

/**
 * add two points
 * @param A point to add
 * @param B point to add
 * @return solution A + B
 */
Point add(Point A, Point B) {
  Point sol = A.copy();
  sol.add(B);
  return sol;
}

/**
 * add point and vector
 * @param A point to add
 * @param V vector to add
 * @return solution A + V
 */
Point add(Point A, Vector V) {
  Point sol = A.copy();
  sol.add(V);
  return sol;
}

/**
 * subtract two points
 * @param A point to subtract
 * @param B point to subtract
 * @return solution A - B
 */
Point sub(Point A, Point B) {
  Point sol = A.copy();
  sol.sub(B);
  return sol;
}

/**
 * multiply point by scalar
 * @param A point to scale
 * @param s scalar to multiply by
 * @return solution s*A
 */
Point mult(Point A, float s) {
  Point sol = A.copy();
  sol.mult(s);
  return sol;
}

/**
 * divide point by scalar
 * @param A point to scale
 * @param s scalar to divide by
 * @return solution (1/s)*A
 */
Point div(Point A, float s) {
  Point sol = A.copy();
  sol.div(s);
  return sol;
}

/**
 * rotate a vector around a plane
 * @param V vector to rotate
 * @param a angle to rotate by
 * @param I vector defining the plane
 * @param J vector defining the plane
 * @return rotated vector
 */
Vector rotate(Vector V, float a, Vector I, Vector J) {
  float x = V.dot(I);
  float y = V.dot(J);
  float c = cos(a);
  float s = sin(a);
  return add(V, add(mult(I, x * c - x - y * s), mult(J, x * s + y * c - y)));
}

/**
 * rotate a point around another point in a plane
 * @param P point to rotate
 * @param a angle to rotate by
 * @param I vector defining the plane
 * @param J vector definish the plane
 * @param G point to rotate around
 * @return rotated point
 */
Point rotate(Point P, float a, Vector I, Vector J, Point G) {
  float x = dot(new Vector(G, P), I);
  float y = dot(new Vector(G, P), J);
  float c = cos(a);
  float s = sin(a);
  return add(add(P, mult(I, x * c - x - y * s)), mult(J, x * s + y * c - y));
}

/**
 * find the midpoint of the two points
 * @param A point to find midpoint of
 * @param B point to find midpoint of
 * @return midpoint
 */
Point midpoint(Point A, Point B) {
  return new Point((A.x + B.x) / 2, (A.y + B.y) / 2, (A.z + B.z) / 2);
}

/**
 * linearly interpolate the given points by the given scalar value
 * @param A Point to linearly interpolate
 * @param s scalar to interpolate by
 * @param B Point to linearly interpolate 
 * @return interpolated Point
 */
public Point linearlyInterpolate(Point A, Point B, float s) {
  return add(A, mult(new Vector(A, B), s));
}

/**
 * calculate a point along the Neville curve
 * @param A key point
 * @param B key point
 * @param C key point
 * @param s interpolation amount
 * @return point along the curve at s
 */
public Point neville(Point A, Point B, Point C, float s) {
  Point P = linearlyInterpolate(A, B, s);
  Point Q = linearlyInterpolate(B, C, s - 1);
  return linearlyInterpolate(P, Q, s / 2);
}

/**
 * calculate a point along the Neville curve
 * @param A key point
 * @param B key point
 * @param C key point
 * @param D key point
 * @param s interpolation amount
 * @return point along the curve at s
 */
public Point neville(Point A, Point B, Point C, Point D, float s) {
  Point P = neville(A, B, C, s);
  Point Q = neville(B, C, D, s - 1);
  return linearlyInterpolate(P, Q, s / 2);
}

/**
 * Calculates the centroid
 */
 public Point centroid(Point[] A, int size){
   Point sum = new Point();
   Point ret = new Point();
   float sizef = float(size);
   
   for(int i = 0; i < size; i++){
     sum = add(sum,A[i]);      
   }  
   return div(sum, sizef);  
 }
 
 /**
 * Rotate a polygon
 */
 public Point[] polyRotate(Point[] A, int size, float angle){
   Point[] newG = new Point[size];
   Point centroid = new Point();
   centroid = centroid(A,size);
   println(centroid.x + " " + centroid.y + " " + centroid.z);
   for(int i = 0; i < size; i++){    
     newG[i] = rotate(A[i], angle, vI, vJ, centroid);      
   }  
   return newG;
 }
