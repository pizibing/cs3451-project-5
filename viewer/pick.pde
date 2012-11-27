Point Pick() { 
  ((PGraphicsOpenGL)g).beginGL(); 
  int viewport[] = new int[4]; 
  double[] proj = new double[16]; 
  double[] model = new double[16]; 
  gl.glGetIntegerv(GL.GL_VIEWPORT, viewport, 0); 
  gl.glGetDoublev(GL.GL_PROJECTION_MATRIX, proj,0); 
  gl.glGetDoublev(GL.GL_MODELVIEW_MATRIX, model,0); 
  FloatBuffer fb = ByteBuffer.allocateDirect(4).order(ByteOrder.nativeOrder()).asFloatBuffer();
  int x = mouseX;
  int y = height - mouseY;
  gl.glReadPixels(x, y, 1, 1, GL.GL_DEPTH_COMPONENT, GL.GL_FLOAT, fb); 
  fb.rewind(); 
  double[] mousePosArr=new double[4];
  glu.gluUnProject((double)x, (double)y, (double)fb.get(0), model, 0, proj, 0, viewport, 0, mousePosArr, 0); 
  ((PGraphicsOpenGL)g).endGL(); 
  Point M = new Point((float)mousePosArr[0], (float)mousePosArr[1], (float)mousePosArr[2]);
  return M;
}

// sets Q where the mouse points to and I, J, K to be aligned with the screen (I right, J up, K towards thre viewer)
void setFrame(Point Q, Vector I, Vector J, Vector K) { 
  glu = ((PGraphicsOpenGL)g).glu;
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  
  float modelviewm[] = new float[16];
  gl = pgl.beginGL();
  gl.glGetFloatv(GL.GL_MODELVIEW_MATRIX, modelviewm, 0);
  pgl.endGL();
  Q.set(Pick()); 
  I.set(modelviewm[0], modelviewm[4], modelviewm[8]);
  J.set(modelviewm[1], modelviewm[5], modelviewm[9]);
  K.set(modelviewm[2], modelviewm[6], modelviewm[10]);
}
