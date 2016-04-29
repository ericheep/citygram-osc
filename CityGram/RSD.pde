class RSD {

  PVector location;
  float siz;
  float rms;
  float mass;
  float G;
  float hue;

  RSD(PVector loc) {
    location = loc.get();
    rms = 0;
    mass = 20;
    G = 0.4;
  }

  void setHue(float h) {
      hue = h;
  }

  void display() {
    colorMode(HSB, 255);
    stroke(hue, 255, 255, 25); // color of RSD visually represented
    colorMode(RGB, 255);
    noFill();
    pushMatrix();
    translate(location.x, location.y, location.z);
    sphere(20); //can be any other 3D objects
    //ellipse(location.x, location.y, 20, 20);
    popMatrix();
  }

  PVector getLocation()
  {
    return location;
  }

  float getRMS()
  {
    return rms;
  }

  void setRMS(float m_rms) {

    rms = m_rms;
  }
}

