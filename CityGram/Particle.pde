class Particle {


  PVector location;
  PVector velocity;
  PVector acceleration;
  int state;
  float mass;
  color col;
  float drag;
  ArrayList<PVector> rsdLoc;
  float randVal;
  int switchy;

  Particle(PVector p, PVector v) {
    location=p.get();
    velocity=v.get();
    col=color(120, 120, 180);
    mass= .4;
    acceleration = new PVector(0, 0, 0);
    drag = random(0.95, 0.998);
    randVal = random(1);
  }

  void rsdLocation(ArrayList<PVector> rsd) {
    rsdLoc=rsd;
  }

  void applyForce() {

    PVector force = new PVector(0, 0, 0);

    //change this according to the number of RSDs
    //i.e if (... < ...[n]) force = ...get(n);
    //   else if (... < ...[n+1]) force = ...get(n+1);
    // and so on, and so forth. 
    
    if (randVal < rsdDistrib[0]) {
      force = rsdLoc.get(0);
    } 
    else if (randVal < rsdDistrib[1]) {
      force = rsdLoc.get(1);
    } 
    else if (randVal < rsdDistrib[2]) {
      force = rsdLoc.get(2);
    } 
    else if (randVal < rsdDistrib[3]) {
      force = rsdLoc.get(3);
    } 
    else if (randVal < rsdDistrib[4]) {
      force = rsdLoc.get(4);
    } 
    else if (randVal < rsdDistrib[5]) {
      force = rsdLoc.get(5);
    } 
    else if (randVal < rsdDistrib[6]) {
      force = rsdLoc.get(6);
    } 
    else if (randVal < rsdDistrib[7]) {
      force = rsdLoc.get(7);
    } 
    else if (randVal < rsdDistrib[8]) {
      force = rsdLoc.get(8);
    } 
    else if (randVal < rsdDistrib[9]) {
      force = rsdLoc.get(9);
    } 
    else if (randVal < rsdDistrib[10]) {
      force = rsdLoc.get(10);
    } 
    else {
      force = rsdLoc.get(11);
    }

    PVector f = PVector.sub(force, location);
    f.normalize();
    acceleration.add(f);
    acceleration.mult(0.6);
  }

  void update() {
    velocity.mult(drag);
    velocity.add(acceleration);
    location.add(velocity);
    checkEdges();
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y, location.z); // offset
    scale(mass);// rescale image
    
    //follow image according to camera perspective
    rotateX(cam.getRotations()[0]); 
    rotateY(cam.getRotations()[1]);
    rotateZ(cam.getRotations()[2]);
    
    translate(-particleImage.width/2, -particleImage.height/2);// offset from left-top corner to center of image, apply before rescaling image
    tint((col >> 16) & 0xFF, (col >> 8) & 0xFF, col & 0xFF, 255-0.5 * 0);
    image(particleImage, 0, 0);
    popMatrix();

  }
  
  //Edge Detection to contain particles within frame's domain
  void checkEdges() {
    if (location.x<-frameDim) { 
      location.x=-2*frameDim-location.x;
      velocity.x*=-1;
    }
    if (location.y<-frameDim) { 
      location.y=-2*frameDim-location.y;
      velocity.y*=-1;
    } 
    if (location.z<-frameDim) { 
      location.z=-2*frameDim-location.z;
      velocity.z*=-1;
    }

    if (location.x>=frameDim) { 
      location.x=2*frameDim-location.x;
      velocity.x*=-1;
    }
    if (location.z>=frameDim) { 
      location.z=2*frameDim-location.z;
      velocity.z*=-1;
    }
    if (location.y>=frameDim) { 
      location.y=2*frameDim-location.y;
      velocity.y*=-1;
    }
  }
}

