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
    this.init();
  }
  
  /**
   * initialize maps
   */
  void init() {
    this.faces_to_verts = new boolean[A.num_triangles][B.num_corners];
    this.verts_to_faces = new boolean[A.num_corners][B.num_triangles];
    this.map_FacesToVerts();
    this.map_VertsToFaces();
    this.edges_A = this.getEdgeList(A);
    this.edges_B = this.getEdgeList(B);
  }
  
  /**
   * 
   */
  Edge[] getEdgeList(CornerTable C) {
    Edge[] edges_C = new Edge[C.num_triangles];
    int edges_C_size = 0;
    for (int i = 0; i < C.num_triangles*3; i++) {
      // build triangle edges
      Edge e1 = new Edge(C.G[C.V[i]], C.G[C.V[C.next(i)]]);
      Edge e2 = new Edge(C.G[C.V[C.prev(i)]], C.G[C.V[i]]);
      Edge e3 = new Edge(C.G[C.V[C.next(i)]], C.G[C.V[C.prev(i)]]);
      // check if edges exist
      boolean e1_match = false;
      boolean e2_match = false;
      boolean e3_match = false;
      for (int j = 0; i < edges_C_size; i++) {
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
      for (int j = 0; j < B.num_corners; j++) {
        boolean flag = true;
        Vector v;
        for (Edge e: Edges_B){
          if (e.A.equals(B.G[j])){
             v = Vector(e.A, e.B);
             if (v.dot(A.Nt[i])>0)){
               flag = false;
             }
             else if (v.dot(A.Nt[i])==0){
                if (norm(Vector(A.C[i],e.B)) < norm(Vector(A.C[i],e.A))){
                    flag = false;
                }
             }
          }
          else if (e.B.equals(B.G[j])){
             v = Vector(e.B, e.A);
             if (v.dot(A.Nt[i])>0)){
               flag = false;
             }
             else if (v.dot(A.Nt[i])==0){
                if (norm(Vector(A.C[i],e.A)) < norm(Vector(A.C[i],e.B))){
                    flag = false;
                }
             }
          }
        }
        this.faces_to_verts[i][j] = flag;
      }
    }
  }
  
  /**
   * map all vertices in A to faces in B
   */
  void map_VertsToFaces() {
    for (int i = 0; i < B.num_triangles; i++) {
      for (int j = 0; j < A.num_corners; j++) {
        boolean flag = true;
        Vector v;
        for (Edge e: Edges_A){
          if (e.A.equals(A.G[j])){
             v = Vector(e.A, e.B);
             if (v.dot(B.Nt[i])>0)){
               flag = false;
             }
             else if (v.dot(B.Nt[i])==0){
                if (norm(Vector(B.C[i],e.B)) < norm(Vector(B.C[i],e.A))){
                    flag = false;
                }
             }
          }
          else if (e.B.equals(A.G[j])){
             v = Vector(e.B, e.A);
             if (v.dot(B.Nt[i])>0)){
               flag = false;
             }
             else if (v.dot(B.Nt[i])==0){
                if (norm(Vector(B.C[i],e.A)) < norm(Vector(B.C[i],e.B))){
                    flag = false;
                }
             }
          }
        }
        this.verts_to_faces[j][i] = flag;
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
      return (this.A.equals(other.A) && this.B.equals(other.B));
    }
  }
}
