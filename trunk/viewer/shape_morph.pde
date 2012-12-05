/**
 * morph between two meshed
 */
class ShapeMorph {
  CornerTable A;
  Edge[] edges_A;
  CornerTable B;
  Edge[] edges_B;
  boolean[][] faces_to_verts;
  boolean[][] verts_to_faces;
  boolean[][] verts_to_verts;
  boolean[][] edges_to_edges;
  int[][] edges_index_B;
  int[][] edges_index_A;
  
  /**
   * constructor
   */
  ShapeMorph(CornerTable A, CornerTable B) {
    this.A = A;
    this.B = B;
  }
  
  /**
   * initialize maps
   */
  void init() {
    this.faces_to_verts = new boolean[A.num_triangles][B.num_corners];
    this.verts_to_faces = new boolean[A.num_corners][B.num_triangles];
    this.verts_to_verts = new boolean[A.num_corners][B.num_corners];
    this.edges_A = this.getEdgeList(A);
    this.edges_B = this.getEdgeList(B);
    this.edges_index_A = this.getEdgeIndexList(A);
    this.edges_index_B = this.getEdgeIndexList(B);
    this.edges_to_edges = new boolean[this.edges_A.length][this.edges_B.length];
    this.map_FacesToVerts();
    this.map_VertsToFaces();
  }
  
  /**
   * 
   */
  Edge[] getEdgeList(CornerTable C) {
    Edge[] edges_C = new Edge[C.num_triangles*3/2];
    int edges_C_size = 0;
    for (int i = 0; i < C.num_triangles; i++) {
      // build triangle edges
      Edge e1 = new Edge(C.G[C.V[3*i]], C.G[C.V[3*i+1]]);
      Edge e2 = new Edge(C.G[C.V[3*i]], C.G[C.V[3*i+2]]);
      Edge e3 = new Edge(C.G[C.V[3*i+1]], C.G[C.V[3*i+2]]);
      // check if edges exist
      boolean e1_match = false;
      boolean e2_match = false;
      boolean e3_match = false;
//      println("e1:" + e1_match + "\ne2:" + e2_match + "\ne3:" + e3_match);
//      for (int j = 0; j < edges_C_size; j++) {
//        e1_match = e1.equals(edges_C[j]);
//        e2_match = e2.equals(edges_C[j]);
//        e3_match = e3.equals(edges_C[j]);
//      }
      int j=0;
      while ((!e1_match) && j<edges_C_size){
          e1_match = e1.equals(edges_C[j]);
          j++;
      }
      if (!e1_match) {
        edges_C[edges_C_size++] = e1;
      }
      j=0;
      while ((!e2_match) && j<edges_C_size){
          e2_match = e2.equals(edges_C[j]);
          j++;
      }
      if (!e2_match) {
        edges_C[edges_C_size++] = e2;
      }
      j=0;
      while ((!e3_match) && j<edges_C_size){
          e3_match = e3.equals(edges_C[j]);
          j++;
      }
      if (!e3_match) {
        edges_C[edges_C_size++] = e3;
      }
    }
//    for(int i = 0; i<edges_C_size; i++){
//      println("A");
//      println(edges_C[i].A.x);
//      println(edges_C[i].A.y);
//      println(edges_C[i].A.z);
//      println("B");
//      println(edges_C[i].B.x);
//      println(edges_C[i].B.y);
//      println(edges_C[i].B.z);
//    }
    return edges_C;
  }
  
    int[][] getEdgeIndexList(CornerTable C) {
    int[][] edges_C = new int[C.num_triangles*3/2][2];
    int edges_C_size = 0;
    for (int i = 0; i < C.num_triangles; i++) {
      // build triangle edges
      int p1 = C.V[3*i];
      int p2 = C.V[3*i+1];
      int p3 = C.V[3*i+2];
     
      int[] e1 = new int[2];
      int[] e2 = new int[2];
      int[] e3 = new int[2];
      e1[0] = p1;
      e1[1] = p2;
      e2[0] = p1;
      e2[1] = p3;
      e3[0] = p2;
      e3[1] = p3;
     
      // check if edges exist
      boolean e1_match = false;
      boolean e2_match = false;
      boolean e3_match = false;
//      println("e1:" + e1_match + "\ne2:" + e2_match + "\ne3:" + e3_match);
//      for (int j = 0; j < edges_C_size; j++)
//        e1_match = e1.equals(edges_C[j]);
//        e2_match = e2.equals(edges_C[j]);
//        e3_match = e3.equals(edges_C[j]);
//      }
      int j=0;
      while ((!e1_match) && j<edges_C_size){
          if ((e1[0]==edges_C[j][0] && e1[1]==edges_C[j][1]) || (e1[0]==edges_C[j][1] && e1[1]==edges_C[j][0]) ){
            e1_match = true;
          }
          j++;
      }
      if (!e1_match) {
        edges_C[edges_C_size++] = e1;
      }
      j=0;
      while ((!e2_match) && j<edges_C_size){
          if ((e2[0]==edges_C[j][0] && e2[1]==edges_C[j][1]) || (e2[0]==edges_C[j][1] && e2[1]==edges_C[j][0]) ){
            e2_match = true;
          }
          j++;
      }
      if (!e2_match) {
        edges_C[edges_C_size++] = e2;
      }
      j=0;
      while ((!e3_match) && j<edges_C_size){
          if ((e3[0]==edges_C[j][0] && e3[1]==edges_C[j][1]) || (e3[0]==edges_C[j][1] && e3[1]==edges_C[j][0]) ){
            e3_match = true;
          }
          j++;
      }
      if (!e3_match) {
        edges_C[edges_C_size++] = e3;
      }
    }
//    for(int i = 0; i<edges_C_size; i++){
//      println("A");
//      println(edges_C[i].A.x);
//      println(edges_C[i].A.y);
//      println(edges_C[i].A.z);
//      println("B");
//      println(edges_C[i].B.x);
//      println(edges_C[i].B.y);
//      println(edges_C[i].B.z);
//    }
    return edges_C;
  }
  
  /**
   * map all faces in A to vertices in B
   */
  void map_FacesToVerts() {
    for (int i = 0; i < A.num_triangles; i++) {
      Vector N = A.Nt[i]; // get triangle normal
      for (int j = 0; j < B.num_vertices; j++) {
        Point V = B.G[j]; // get vertex
        boolean flag = true;
        Vector E;
        for (Edge e: edges_B){
          if (e.A.equals(V)) {
             E = new Vector(e.A, e.B);
             if (N.dot(E) >= 0){
               flag = false;
             }
          }
          else if (e.B.equals(V)) {
            E = new Vector(e.B, e.A);
            if (N.dot(E) >= 0) {
              flag = false;
            }
          }
        }
        this.faces_to_verts[i][j] = flag;
        if (flag == true){
           for(int k = 0; k<3; k++){
             this.verts_to_verts[A.V[i*3+k]][j] = true;
           }
        }
      }
    }
  }
  
  /**
   * map all vertices in A to faces in B
   */
  void map_VertsToFaces() {
    for (int i = 0; i < B.num_triangles; i++) {
      Vector N = B.Nt[i]; // get triangle normal
      for (int j = 0; j < A.num_vertices; j++) {
        Point V = A.G[j]; // get vertex
        boolean flag = true;
        Vector E;
        for (Edge e: edges_A){
          if (e.A.equals(V)) {
             E = new Vector(e.A, e.B);
             if (N.dot(E) >= 0) {
               flag = false;
             }
          }
          else if (e.B.equals(V)) {
            E = new Vector(e.B, e.A);
            if (N.dot(E) >= 0) {
              flag = false;
            }
          }
        }
        this.verts_to_faces[j][i] = flag;
        if (flag == true){
           for(int k = 0; k<3; k++){
             this.verts_to_verts[j][B.V[i*3+k]] = true;
           }
        }
      }
    }
  }
  
  /**
   * map all edges in A to edges in B
   */
  void map_EdgeToEdge() {
    for (int i = 0; i<edges_index_A.length; i++){
      for (int j = 0; j<edges_index_B.length; j++){
        if (verts_to_verts[edges_index_A[i][0]][edges_index_B[j][0]] && verts_to_verts[edges_index_A[i][0]][edges_index_B[j][1]] && verts_to_verts[edges_index_A[i][1]][edges_index_B[j][0]] && verts_to_verts[edges_index_A[i][1]][edges_index_B[j][1]]){
          this.edges_to_edges[i][j] = true;
        }
      }
    }
  }
  
  /**
   * edge made by 2 points
   */
  class Edge {
    Point A;
    Point B;
    
    Edge(Point A, Point B) {
      this.A = A;
      this.B = B;
    }
    
    boolean equals(Edge other) {
      return (this.A.equals(other.A) && this.B.equals(other.B)) || (this.B.equals(other.A) && this.A.equals(other.B));
    }
  }
  
  CornerTable animate(float t) {
    CornerTable result = new CornerTable();
    for (int i = 0; i < faces_to_verts.length; i++) {
      for (int j = 0; j < faces_to_verts[i].length; j++) {
        // faces to verts
        if (faces_to_verts[i][j]) {
          Point A1 = A.G[A.V[3*i]];
          Point A2 = A.G[A.V[3*i+1]];
          Point A3 = A.G[A.V[3*i+2]];
          Point B1 = B.G[B.V[j]];
          A1 = linearlyInterpolate(A1, B1, t);
          A2 = linearlyInterpolate(A2, B1, t);
          A3 = linearlyInterpolate(A3, B1, t);
          int a1 = result.addVertex(A1);
          int a2 = result.addVertex(A2);
          int a3 = result.addVertex(A3);
          result.addColorTriangle(a1, a2, a3, red);
        }
        // verts to faces
        if (verts_to_faces[j][i]) {
          Point B1 = B.G[B.V[3*i]];
          Point B2 = B.G[B.V[3*i+1]];
          Point B3 = B.G[B.V[3*i+2]];
          Point A1 = A.G[A.V[j]];
          B1 = linearlyInterpolate(B1, A1, 1-t);
          B2 = linearlyInterpolate(B2, A1, 1-t);
          B3 = linearlyInterpolate(B3, A1, 1-t);
          int b1 = result.addVertex(B1);
          int b2 = result.addVertex(B2);
          int b3 = result.addVertex(B3);
          result.addColorTriangle(b1, b2, b3, green);
        }
      }
    }
    for (int i = 0; i < this.edges_to_edges.length; i++) { // edges_A index
      for (int j = 0; j < this.edges_to_edges[i].length; j++) { // edges_B index
        if (edges_to_edges[i][j]) {
          println("adding tri");
          Point A1 = A.G[edges_index_A[i][0]];
          Point A2 = A.G[edges_index_A[i][1]];
          Point B1 = B.G[edges_index_B[j][0]];
          Point B2 = B.G[edges_index_B[j][1]];
          Point A11 = linearlyInterpolate(A1, B1, t);
          Point A12 = linearlyInterpolate(A1, B2, t);
          Point B11 = linearlyInterpolate(A2, B1, t);
          Point B12 = linearlyInterpolate(A2, B2, t);
          int a11 = result.addVertex(A11);
          int a12 = result.addVertex(A12);
          int b11 = result.addVertex(B11);
          int b12 = result.addVertex(B12);
          result.addColorTriangle(a11, a12, b11,blue);
          result.addColorTriangle(a12, b11, b12,blue);
        }
      }
    }
    return result;
  }
}
