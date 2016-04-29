//Frame in which particles will exist within, similar to "Domain" in Blender/ Unity. 
class Frame {

  float nearZ=0.91f; 
  float farZ=0.97f;
  float dZ=farZ-nearZ;
  int level=140;

  Frame() {
  }

  void display() {
    frameDim+=10;
    noFill();
    strokeWeight(2);
    beginShape(QUADS);
    stroke(level-(screenZ(frameDim, frameDim, frameDim)-nearZ)/dZ*level, 200);
    vertex(frameDim, frameDim, frameDim);
    stroke(level-(screenZ(-frameDim, frameDim, frameDim)-nearZ)/dZ*level, 200);
    vertex(-frameDim, frameDim, frameDim);
    stroke(level-(screenZ(-frameDim, -frameDim, frameDim)-nearZ)/dZ*level, 200);
    vertex(-frameDim, -frameDim, frameDim);
    stroke(level-(screenZ(frameDim, -frameDim, frameDim)-nearZ)/dZ*level, 200);
    vertex(frameDim, -frameDim, frameDim);

    stroke(level-(screenZ(frameDim, frameDim, -frameDim)-nearZ)/dZ*level, 200);
    vertex(frameDim, frameDim, -frameDim);
    stroke(level-(screenZ(-frameDim, frameDim, -frameDim)-nearZ)/dZ*level, 200);
    vertex(-frameDim, frameDim, -frameDim);
    stroke(level-(screenZ(-frameDim, -frameDim, -frameDim)-nearZ)/dZ*level, 200);
    vertex(-frameDim, -frameDim, -frameDim);
    stroke(level-(screenZ(frameDim, -frameDim, -frameDim)-nearZ)/dZ*level, 200);
    vertex(frameDim, -frameDim, -frameDim);
    endShape();

    beginShape(LINES);
    stroke(level-(screenZ(frameDim, frameDim, frameDim)-nearZ)/dZ*level, 200);
    vertex(frameDim, frameDim, frameDim);
    stroke(level-(screenZ(frameDim, frameDim, -frameDim)-nearZ)/dZ*level, 200);
    vertex(frameDim, frameDim, -frameDim);
    stroke(level-(screenZ(frameDim, -frameDim, -frameDim)-nearZ)/dZ*level, 200);
    vertex(frameDim, -frameDim, -frameDim);
    stroke(level-(screenZ(frameDim, -frameDim, frameDim)-nearZ)/dZ*level, 200);
    vertex(frameDim, -frameDim, frameDim);
    stroke(level-(screenZ(-frameDim, frameDim, frameDim)-nearZ)/dZ*level, 200);
    vertex(-frameDim, frameDim, frameDim);
    stroke(level-(screenZ(-frameDim, frameDim, -frameDim)-nearZ)/dZ*level, 200);
    vertex(-frameDim, frameDim, -frameDim);
    stroke(level-(screenZ(-frameDim, -frameDim, -frameDim)-nearZ)/dZ*level, 200);
    vertex(-frameDim, -frameDim, -frameDim);
    stroke(level-(screenZ(-frameDim, -frameDim, frameDim)-nearZ)/dZ*level, 200);
    vertex(-frameDim, -frameDim, frameDim);
    endShape();

    fill(0);
    frameDim-=10;
  }
}

