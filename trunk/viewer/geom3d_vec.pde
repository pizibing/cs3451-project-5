/**
 * get mouse drag vector
 * @return drag vector
 */
Vector getMouseDrag() {
  return new Vector(mouseX - pmouseX, mouseY - pmouseY, 0);
}

/**
 * Vector class
 */
class Vector {
  float x;
  float y;
  float z;
  
  /**
   * constructor
   * creates vector of length zero
   */
  Vector() {
    this.x = 0.0;
    this.y = 0.0;
    this.z = 0.0;
  }
  
  /**
   * constructor
   * create vector of given components
   * @param x x component
   * @parma y y component
   * @parma z z component
   */
  Vector(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /**
   * copy constructor
   * @param other vector to copy
   */
  Vector(Vector other) {
    this.x = other.x;
    this.y = other.y;
    this.z = other.z;
  }
  
  /**
   * constructor
   * create vector between points A and B
   * @param A start point
   * @param B end point
   */
  Vector(Point A, Point B) {
    this.x = B.x - A.x;
    this.y = B.y - A.y;
    this.z = B.z - A.z;
  }
  
  /**
   * set vector to given components
   * @param x z component
   * @param y y component
   * @param z z component
   */
  void set(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /**
   * set vector to given vector's components
   * @param V vector to set equal to
   */
  void set(Vector v) {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  }
  
  /**
   * add vectors
   * @param V vector to add
   * @return this
   */
  Vector add(Vector V) {
    this.x += V.x;
    this.y += V.y;
    this.z += V.z;
    return this;
  }
  
  /**
   * subtract vectors
   * @param V vector to subtract
   * @return this
   */
  Vector sub(Vector V) {
    this.x -= V.x;
    this.y -= V.y;
    this.z -= V.z;
    return this;
  }
  
  /**
   * multiply vector by scalar
   * @param s scalar to multiply by
   * @return this
   */
  Vector mult(float s) {
    this.x *= s;
    this.y *= s;
    this.z *= s;
    return this;
  }
  
  /**
   * divide vector by scalar
   * @param s scalar to divide by
   * @return this
   */
  Vector div(float s) {
    this.x /= s;
    this.y /= s;
    this.z /= s;
    return this;
  }
  
  /**
   * find dot product
   * @param V vector to dot
   * @return dot product
   */
  float dot(Vector V) {
    return (this.x * V.x) + (this.y * V.y) + (this.z * V.z);
  }
  
  /**
   * cross product (normal to both this and V)
   * @param V vector to cross with
   * @return this
   */
  Vector cross(Vector V) {
    float x_new = (this.y * V.z) - (this.z * V.y);
    float y_new = (this.z * V.x) - (this.x * V.z);
    float z_new = (this.x * V.y) - (this.y * V.x);
    this.x = x_new;
    this.y = y_new;
    this.z = z_new;
    return this;
  }
  
  /**
   * find vector magnitude
   * @return magnitude of vector
   */
  float norm() {
    return sqrt(sq(this.x) + sq(this.y) + sq(this.z));
  }
  
  /**
   * normalize a vector
   * @return this
   */
  Vector normalize() {
    float n = this.norm();
    if(n > 0.000001) {
      this.div(n);
    }
    return this;
  }
  
  /**
   * rotate a vector
   * @param s
   * @param I
   * @param J
   * @return this
   */
  Vector rotate(float a, Vector I, Vector J) {
    float x = this.dot(I);
    float y = this.dot(J);
    float c = cos(a);
    float s = sin(a);
    Vector I_new = new Vector(I);
    Vector J_new = new Vector(J);
    I_new.mult(x * c - x - y * s);
    J_new.mult(x * s + y * c - y);
    this.add(J_new);
    this.add(I_new);
    return this;
  }
  
  /**
   * copy a vector
   * @return copy of vector
   */
  Vector copy() {
    Vector copy = new Vector();
    copy.set(this);
    return copy;
  }
}

/**
 * add two vectors
 * @param U vector to add
 * @param V vector to add
 * @return solution U + V
 */
Vector add(Vector U, Vector V) {
  Vector sol = U.copy();
  sol.add(V);
  return sol;
}

/**
 * subtract two vectors
 * @param U vector to subtract
 * @param V vector to subtract
 * @return solution U - V
 */
Vector sub(Vector U, Vector V) {
  Vector sol = U.copy();
  sol.sub(V);
  return sol;
}

/**
 * multiply vector and scalar
 * @param V vector to scale
 * @param s scalar to multiply by
 * @return solution s*V
 */
Vector mult(Vector V, float s) {
  Vector sol = V.copy();
  sol.mult(s);
  return sol;
}

/**
 * divide vector and scalar
 * @param V vector to scale
 * @param s scalar to divide by
 * @return solution (1/s)*V
 */
Vector div(Vector V, float s) {
  Vector sol = V.copy();
  sol.div(s);
  return sol;
}

/**
 * find dot product of two vectors
 * @param U vector to dot
 * @param V vector to dot
 * @return solution U.V
 */
float dot(Vector U, Vector V) {
  return U.dot(V);
}

/**
 * find cross produce of two vectors
 * @param U vector to cross
 * @param V vectro to cross
 * @return solution UxV
 */
Vector cross(Vector U, Vector V) {
  Vector sol = U.copy();
  sol.cross(V);
  return sol;
}

/**
 * find magnitude of vector
 * @param V vector to find magnitude of
 * @return magnitude of V
 */
float norm(Vector V) {
  return V.norm();
}

/**
 * determin if B is left of A
 */
boolean isLeft(Point A, Point B, Point C) {
  return ((B.x - A.x) * (C.y - A.y) - (B.y - A.y) * (C.x - A.x)) > 0;
}
