/**
 *
 */
class CornerTable {
  // geometry
  Point[] G;
  // triangles
  int[] V;
  // opposites
  int[] O;
  // vector normals
  Vector[] Nv;
  // triangle normals
  Vector[] Nt;
  // centroids
  Point[] C;
  // sizes
  int num_vertices;
  int num_triangles;
  int num_corners;
  
  /**
   * constructor
   */
  CornerTable() {
    this.initTables();
  }
  
  /**
   * initialize all tables
   */
  void initTables() {
    this.G = new Point[30];
    this.V = new int[30];
    this.O = new int[30];
    this.Nv = new Vector[30];
    this.Nt = new Vector[30];
    this.C = new Point[30];
    this.num_vertices = 0;
    this.num_triangles = 0;
    this.num_corners = 0;
  }
  
  /**
   * triangle of corner
   */
  int tri(int c) {
    return c / 3;
  }
  
  /**
   * next corner in the same triangle
   */
  int next(int c) {
    return 3 * this.tri(c) + (c + 1) % 3;
  }
  
  /**
   * previous corner of in the same triangle
   */
  int prev(int c) {
    return this.next(this.next(c));
  }
  
  /**
   * id of the vertex of c
   */
  int vert(int c) {
    return this.V[c];
  }
  
  /**
   * opposite (or self of no opposite)
   */
  int opposite(int c) {
    return this.O[c];
  }
  
  /**
   * left neighbor (or next if next(c) has no opposite)
   */
  int left(int c) {
    return this.opposite(this.next(c));
  }
  
  /**
   * right neighbor (or next if next(c) has no opposite)
   */
  int right(int c) {
    return this.opposite(this.prev(c));
  }
  
  /**
   * swing around vertex(c) or around a border loop
   */
  int swing(int c) {
     return this.next(this.left(c)); 
  }
  
  /**
   * unswing around vertex(c) or around a border loop
   */
  int unswing(int c) {
    return this.prev(this.right(c));
  }
  
  /**
   * get corresponding geomerty
   */
  Point geom(int c) {
    return G[vert(c)];
  }
  
  /**
   * add a vertex to the table
   * @param P vertex to add to the list
   * @return index of the new vertex
   */
  int addVertex(Point P) {
    // resize
    if (this.num_vertices >= this.G.length) {
      Point[] temp1 = new Point[this.G.length * 2];
      Vector[] temp2 = new Vector[this.G.length * 2];
      for (int i = 0; i < this.num_vertices; i++) {
        temp1[i] = this.G[i];
        temp2[i] = this.Nv[i];
      }
      this.G = temp1;
      this.Nv = temp2;
    }
    // add vertex
    int g_i = this.num_vertices++;
    this.G[g_i] = P;
    this.Nv[g_i] = new Vector();
    return g_i;
  }
  
  /**
   * add triangle from vertex indices
   * @param a triangle vertex
   * @param b triangle vertex
   * @param c triangle vertex
   */
  int addTriangle(int a, int b, int c) {
    // resize
    if (this.num_corners + 2 >= this.V.length) {
      int[] temp1 = new int[this.V.length * 2];
      int[] temp2 = new int[this.V.length * 2];
      for (int i = 0; i < this.num_corners; i++) {
        temp1[i] = this.V[i];
        temp2[i] = this.O[i];
      }
      this.V = temp1;
      this.O = temp2;
    }
    if (this.num_triangles >= this.Nt.length) {
      Vector[] temp1 = new Vector[this.Nt.length * 2];
      Point[] temp2 = new Point[this.Nt.length * 2];
      for (int i = 0; i < this.num_triangles; i++) {
        temp1[i] = this.Nt[i];
        temp2[i] = this.C[i];
      }
      this.Nt = temp1;
      this.C = temp2;
    }
    // add triangle
    int a_i = this.num_corners++;
    this.V[a_i] = a;
    this.O[a_i] = a;
    int b_i = this.num_corners++;
    this.V[b_i] = b;
    this.O[b_i] = b;
    int c_i = this.num_corners++;
    this.V[c_i] = c;
    this.O[c_i] = c;
    // build opposite table
    // TODO 
    // calculate normals
    Point P0 = new Point(G[V[a_i]]);
    Point P1 = new Point(G[V[a_i+1]]);
    Point P2 = new Point(G[V[a_i+2]]);
    this.C[this.num_triangles++] = div(add(add(P0, P1), P2), 3);
    //this.Nt[c_i] = new Vector();
    calcTriangleNormals();
    calcVertexNormals();
    // return triangle index
    return a_i;
  }
  
  /**
   * calculate triangle normals
   */
  void calcTriangleNormals() {
    Point P0;
    Point P1;
    Point P2;
    Vector V = new Vector();
    Vector U = new Vector();
    for (int i = 0; i < this.num_triangles; i++) {
      P0 = this.G[this.V[i*3]];
      P1 = this.G[this.V[i*3+1]];
      P2 = this.G[this.V[i*3+2]];
      V = new Vector(P0, P1);
      U = new Vector(P0, P2);
      Nt[i] = V.cross(U);
    }
  }
  
  /**
   * calculate vector normals
   */
  void calcVertexNormals() {
    // clear old
    for (int i = 0; i < this.num_vertices; i++) {
      this.Nv[i] = new Vector();
    }
    // calculate new normals
    for (int i = 0; i < this.num_corners; i++) {
      Nv[vert(i)].add(Nt[tri(i)]);
      Nv[vert(i)].normalize();
    }
  }
  
  /**
   * draw all triangles
   */
  void drawTriangles(boolean smooth) {
    beginShape(TRIANGLES);
    int curr = 0;
    int vi = 0;
    int vni = 0;
    int vpi = 0;
    for (int i = 0; i < this.num_corners; i += 3) {
      vi = vert(i);
      vni = vert(next(i));
      vpi = vert(prev(i));
      if (smooth) {
        normal(Nv[vi].x, Nv[vi].y, Nv[vi].z);
        vertex(G[vi].x, G[vi].y, G[vi].z);
        normal(Nv[vni].x, Nv[vni].y, Nv[vni].z);
        vertex(G[vni].x, G[vni].y, G[vni].z);
        normal(Nv[vpi].x, Nv[vpi].y, Nv[vpi].z);
        vertex(G[vpi].x, G[vpi].y, G[vpi].z);
      }
      else {
        vertex(G[vi].x, G[vi].y, G[vi].z);
        vertex(G[vni].x, G[vni].y, G[vni].z);
        vertex(G[vpi].x, G[vpi].y, G[vpi].z);
      }
    }
    endShape();
  }
  
  /**
   * draw vertex normals
   */
  void drawVertexNormals() {
    Point result = null;
    for (int i = 0; i < this.num_vertices; i++) {
       result = add(this.G[i], mult(this.Nv[i], 50));
       beginShape(LINE);
       vertex(this.G[i].x, this.G[i].y, this.G[i].z);
       vertex(result.x, result.y, result.z);
       endShape();
    }
  }
  
  /**
   * draw triangle normals
   */
  void drawTriangleNormals() {
    Point result = null;
    for (int i = 0; i < this.num_triangles; i++) {
      result = add(this.C[i], this.Nt[i]);
      beginShape(LINE);
      vertex(this.C[i].x, this.C[i].y, this.C[i].z);
      vertex(result.x, result.y, result.z);
      endShape();
    }
  }
}
