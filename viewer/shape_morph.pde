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
    this.faces_to_verts = new boolean[A.num_triangles][B.num_vertices];
    this.verts_to_faces = new boolean[A.num_vertices][B.num_triangles];
    this.edges_A = this.getEdgeList(A);
    this.edges_B = this.getEdgeList(B);
    this.map_FacesToVerts();
    this.map_VertsToFaces();
  }
  
  /**
   * 
   */
  Edge[] getEdgeList(CornerTable C) {
    Edge[] edges_C = new Edge[C.num_triangles*3];
    int edges_C_size = 0;
    for (int i = 0; i < C.num_triangles; i++) {
      println("i:" + i);
      // build triangle edges
      Edge e1 = new Edge(C.G[C.V[3*i]], C.G[C.V[C.next(3*i)]]);
      Edge e2 = new Edge(C.G[C.V[C.prev(3*i)]], C.G[C.V[3*i]]);
      Edge e3 = new Edge(C.G[C.V[C.next(3*i)]], C.G[C.V[C.prev(3*i)]]);
      // check if edges exist
      boolean e1_match = false;
      boolean e2_match = false;
      boolean e3_match = false;
      println("e1:" + e1_match + "\ne2:" + e2_match + "\ne3:" + e3_match);
      for (int j = 0; j < edges_C_size; j++) {
        e1_match = e1.equals(edges_C[j]);
        e2_match = e2.equals(edges_C[j]);
        e3_match = e3.equals(edges_C[j]);
      }
      if (!e1_match) {
        edges_C[edges_C_size++] = e1;
      }
      if (!e2_match) {
        edges_C[edges_C_size++] = e2;
      }
      if (!e3_match) {
        edges_C[edges_C_size++] = e3;
      }
    }
    Edge[] temp = new Edge[edges_C_size];
    for (int i = 0; i < edges_C_size; i++) {
      temp[i] = edges_C[i];
    }
    return temp;
  }
  
  /**
   * map all faces in A to vertices in B
   */
  void map_FacesToVerts() {
    for (int i = 0; i < A.num_triangles; i++) {
      for (int j = 0; j < B.num_vertices; j++) {
        boolean flag = true;
        Vector v;
        for (Edge e: edges_B){
          if (e.A.equals(B.G[j])){
             v = new Vector(e.A, e.B);
             if (v.dot(A.Nt[i])>0){
               flag = false;
             }
             else if (v.dot(A.Nt[i])==0){
                if (norm(new Vector(A.C[i],e.B)) < norm(new Vector(A.C[i],e.A))){
                    flag = false;
                }
             }
          }
          else if (e.B.equals(B.G[j])){
             v = new Vector(e.B, e.A);
             if (v.dot(A.Nt[i])>0){
               flag = false;
             }
             else if (v.dot(A.Nt[i])==0){
                if (norm(new Vector(A.C[i],e.A)) < norm(new Vector(A.C[i],e.B))){
                    flag = false;
                }
             }
          }
        }
        this.faces_to_verts[i][j] = flag;
          //this.faces_to_verts[i][j] = true;
      }
    }
  }
  
  /**
   * map all vertices in A to faces in B
   */
  void map_VertsToFaces() {
    for (int i = 0; i < B.num_triangles; i++) {
      for (int j = 0; j < A.num_vertices; j++) {
        boolean flag = true;
        Vector v;
        for (Edge e: edges_A){
          if (e.A.equals(A.G[j])){
             v = new Vector(e.A, e.B);
             if (v.dot(B.Nt[i])>0){
               flag = false;
             }
             else if (abs(v.dot(B.Nt[i])) < 0.001){
                if (norm(new Vector(B.C[i],e.B)) < norm(new Vector(B.C[i],e.A))){
                    flag = false;
                }
             }
          }
          else if (e.B.equals(A.G[j])){
             v = new Vector(e.B, e.A);
             if (v.dot(B.Nt[i])>0){
               flag = false;
             }
             else if (abs(v.dot(B.Nt[i])) < 0.001){
                if (norm(new Vector(B.C[i],e.A)) < norm(new Vector(B.C[i],e.B))){
                    flag = false;
                }
             }
          }
        }
        this.verts_to_faces[j][i] = flag;
          //this.verts_to_faces[j][i] = true;
      }
    }
  }
  
  /**
   * map all edges in A to edges in B
   */
  void map_EdgeToEdge() {
    
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
    // faces to verts
    for (int i = 0; i < faces_to_verts.length; i++) {
      for (int j = 0; j < faces_to_verts[i].length; j++) {
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
          result.addTriangle(a1, a2, a3);
        }
      }
    }
//    // verts to faces
//    for (int i = 0; i < verts_to_faces.length; i++) {
//      for (int j = 0; j < verts_to_faces[i].length; j++) {
//        if (verts_to_faces[i][j]) {
//          Point B1 = B.G[B.V[3*j]];
//          Point B2 = B.G[B.V[3*j+1]];
//          Point B3 = B.G[B.V[3*j+2]];
//          Point A1 = A.G[A.V[i]];
//          B1 = linearlyInterpolate(B1, A1, 1-t);
//          B2 = linearlyInterpolate(B2, A1, 1-t);
//          B3 = linearlyInterpolate(B3, A1, 1-t);
//          int b1 = result.addVertex(B1);
//          int b2 = result.addVertex(B2);
//          int b3 = result.addVertex(B3);
//          result.addTriangle(b1, b2, b3);
//        }
//      }
//    }
//    // edges to edges
//    for (int i = 0; i < edges_A.length; i++) {
//      for (int j = 0; j < edges_B.length; j++) {
//        Point A1 = edges_A[i].A;
//        Point A2 = edges_A[i].B;
//        Point B1 = edges_B[j].A;
//        Point B2 = edges_B[j].B;
//        Point A11 = linearlyInterpolate(A1, B1, t);
//        Point A12 = linearlyInterpolate(A1, B2, t);
//        Point B11 = linearlyInterpolate(A2, B1, t);
//        Point B12 = linearlyInterpolate(A2, B2, t);
//        int a11 = result.addVertex(A11);
//        int a12 = result.addVertex(A12);
//        int b11 = result.addVertex(B11);
//        int b12 = result.addVertex(B12);
//        result.addTriangle(a11, a12, b11);
//        result.addTriangle(a12, b11, b12);
//      }
//    }
    return result;
  }
}
