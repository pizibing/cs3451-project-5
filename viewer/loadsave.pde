/**
 * load scene
 */
void loadScene() {
  try {
    String in_path = selectInput();
    if (in_path != null) {
      loadScene(in_path);
    }
  }
  catch (Exception e) {
    println(e);
    println("ERROR: couldn't load scene");
  }
}

/**
 * load scene
 * @param path file to load
 */
void loadScene(String path) throws IOException {
  BufferedReader in = createReader(path);
  // scene specific
  for (int i = 0; i < num_shapes; i++) {
    load(shapes[i], in);
    shapes[i].createOutlineAndMesh();
  }
  // END scene specific
  in.close();
}

/**
 * save scene
 */
void saveScene() {
  try {
    String out_path = selectOutput();
    if (out_path != null) {
      saveScene(out_path);
    }
  }
  catch (Exception e) {
    println(e);
    println("ERROR: couldn't save scene");
  }
}

/**
 * save scene
 * @param path file to save
 */
void saveScene(String path) throws IOException {
  PrintWriter out = createWriter(path);
  // scene specific
  for (int i = 0; i < num_shapes; i++) {
    save(shapes[i], out);
  }
  // END scene specific
  out.close();
}

/**
 * load a point from file
 * @param P point to load
 * @param in file buffer to read from
 */
void load(Point P, BufferedReader in) throws IOException {
  P.x = (new Float(in.readLine())).floatValue();
  P.y = (new Float(in.readLine())).floatValue();
  P.z = (new Float(in.readLine())).floatValue();
}

/**
 * load a vector from file
 * @param V vector to load
 * @param in file buffer to read from
 */
void load(Vector V, BufferedReader in) throws IOException {
  V.x = (new Float(in.readLine())).floatValue();
  V.y = (new Float(in.readLine())).floatValue();
  V.z = (new Float(in.readLine())).floatValue();
}

/**
 * load a shape frame from file
 * @param shape_frame shape to load
 * @param in file buffer to read from
 */
void load(ShapeFrame shape_frame, BufferedReader in) throws IOException {
  shape_frame.spin_angle = (new Float(in.readLine())).intValue();
  shape_frame.num_sides = (new Integer(in.readLine())).intValue();
  load(shape_frame.origin, in);
  shape_frame.frame_size = (new Integer(in.readLine())).intValue();
  if (shape_frame.frame_size < 1) {
    return;
  }
  Point[] frame = new Point[shape_frame.frame_size];
  for (int i = 0; i < shape_frame.frame_size; i++) {
    shape_frame.frame[i] = new Point();
    load(shape_frame.frame[i], in);
  }
}

/**
 * save point to file
 * @param P point to save
 * @param out file buffer to write to
 */
void save(Point P, PrintWriter out) throws IOException {
  out.println(((Float)P.x).toString());
  out.println(((Float)P.y).toString());
  out.println(((Float)P.z).toString());
}

/**
 * save vector to file
 * @param V vector to save
 * @param out file buffer to write to
 */
void save(Vector V, PrintWriter out) throws IOException {
  out.println(((Float)V.x).toString());
  out.println(((Float)V.y).toString());
  out.println(((Float)V.z).toString());
}

/**
 * save a shape frame to file
 * @param shape_frame shape to save
 * @param out file buffer to write to
 */
void save(ShapeFrame shape_frame, PrintWriter out) throws IOException {
  out.println(((Float)shape_frame.spin_angle).toString());
  out.println(((Integer)shape_frame.num_sides).toString());
  save(shape_frame.origin, out);
  out.println(((Integer)shape_frame.frame_size).toString());
  for (int i = 0; i < shape_frame.frame_size; i++) {
    save(shape_frame.frame[i], out);
  }
}
