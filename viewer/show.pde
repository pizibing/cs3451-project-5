/**
 * show point as sphere
 * @param P sphere center
 * @param r sphere radius
 */
void show(Point P, float r) {
  pushMatrix();
  translate(P.x, P.y, P.z);
  sphere(r);
  popMatrix();
}
