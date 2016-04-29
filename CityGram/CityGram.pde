//Kameron Christopher 
//Jon He
//CityGram

// Updated for Processing 3
// - JP Yepez


//import de.bezier.data.sql.*;
//import de.bezier.data.sql.mapper.*;

import oscP5.*;
import netP5.*;
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import saito.objloader.*;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;

// full screen
OscP5 oscP5;
NetAddress myRemoteLocation;

PeasyCam cam;
PGL pgl;
Frame frame;
int numMsgs = 3;
int rsdNum = 3;
float [] x = new float[rsdNum];
float [] y = new float[rsdNum];
float [] z = new float[rsdNum];

//MySQL cgdbase;
String [] tableNames = new String [rsdNum];
int [] id = new int [rsdNum];
float [] rms = new float [rsdNum];
float [] centroid = new float [rsdNum];
float [] rZLoc = {
  -300, 150, 650
}; //Levels i.e. rZLoc[0] is level 1, etc...

//Domain setup
int numParticles = 7000;
int frameDim=1100;
int spread = 110;
int imgScale = 1000;
int modScale = 24;

// declare that we need a OBJModel and we'll be calling it "model"
OBJModel model;
RSD[] rsd = new RSD[rsdNum];
Particle[] b = new Particle[numParticles];

PImage particleImage; 
PImage[] map = new PImage[3];

ArrayList<PVector> rsdLocs;
float[] rsdInitPer = new float[rsdNum]; //calculate particle percentage
float[] rsdDistrib = new float[rsdNum]; //distribution percentage


void setup() {
  fullScreen(OPENGL);
  frameRate(30);
  hint(DISABLE_DEPTH_MASK);
  background(0);

  //ConnectServer();
  oscP5 = new OscP5(this, 12345);

  cam = new PeasyCam(this, 3000);
  cam.setMinimumDistance(1000);
  cam.setMaximumDistance(3500);

  frame = new Frame();

  //Floorplan for each level
  map[0] = loadImage("texture_0.png");
  map[1] = loadImage("texture_1.png");
  map[2] = loadImage("texture.png");


  particleImage = loadImage("reflection.png");
  particleImage.resize(64, 64);

  rsdLocs = new ArrayList<PVector>(); //Allow for variable number of RSDs and integration with SQL database

  // making an object called "model" that is a new instance of OBJModel  
  model = new OBJModel(this, "allFloorsStackedUp.obj", "relative", TRIANGLES);
  model.scale(modScale);

  // turning on the debug output (it's all the stuff that spews out in the black box down the bottom)
  //model.enableDebug();

  // third floor

  // machine lab
  x[0] = -650;    
  y[0] = 600;  
  z[0] = rZLoc[1] - 100;

  // lund
  x[1] = -250;   
  y[1] = 300;   
  z[1] = rZLoc[2] - 100;

  // box office
  // x[2] = 50;  
  // y[2] = 250;  
  // z[2] = rZLoc[2] - 100;

  // music office
  // x[3] = -1000;   
  // y[3] = 550; 
  // z[3] = rZLoc[2] - 75;

  // mod
  // x[4] = 530; 
  // y[4] = 90;  
  // z[4] = rZLoc[2] - 125;

  // print lab
  x[2] = -600;  
  y[2] = 600;  
  z[2] = rZLoc[0] - 100;

  // rod
  // x[6] = -575;  
  // y[6] = 650;  
  // z[6] = rZLoc[2] - 100;
  
  // mod lobby
  // x[7] = 200;     
  // y[7] = 90;  
  // z[7] = rZLoc[2] - 50;
  
  // rod lobby
  // x[8] = -525;  
  // y[8] = 450;  
  // z[8] = rZLoc[2] - 100;

  // third floor
  // behind box office,          50,    250,   rZLoc[2] - 100);
  // mod,                        300,   90,    rZLoc[2] - 50);  
  // lund,                       -250,  300,   rZLoc[2] - 100);
  // cafe,                       300,   -400,  rZLoc[2] - 100);
  // music office,               -1000, 550,   rZLoc[2] - 100);  
  // rod                         -575,  650,   rZLoc[2] - 100);

  // second floor
  // bijou                        0,    200,   rZLoc[1] - 100);
  // machine lab                  -650, 600,   rZLoc[1] - 100); 
  // super shop                   -700, -300,  rZloc[1] - 100); 
  // behind the tatum counter,    325,  -575,  rZLoc[1] - 100);

  // print lab
  // scene shop                    500,  100,  550                   

    // wild beast                   -850,  900,  -300;                           

  for (int i = 0; i<rsd.length; i++) {
    PVector local = new PVector(x[i], y[i], z[i]);
    rsd[i] = new RSD(local);
    rsdLocs.add(rsd[i].location);
    //println(rsdLocs);
    rsd[i].setRMS(random(1));
  }

  for (int j=0; j<numParticles; j++) {
    b[j]=new Particle(new PVector(random(-spread, spread), random(-spread, spread), random(-spread, spread)), new PVector(random(-spread, spread), random(-spread, spread), random(-spread, spread)));
    b[j].velocity.normalize();
    b[j].velocity.mult(2);
  }

  model.enableTexture();
  model.enableMaterial();
  model.scale(modScale);
}

void draw() {
  background(0); 
  smooth();

  //getData();

  translate(0, 0, 0);

  pushMatrix();
  rotateX(4.7);
  noStroke();
  model.draw();
  popMatrix();

  pgl = beginPGL();
  blendMode(ADD);
  frame.display();
  endPGL();

  for (int i = 0; i < rsdNum; i++) {
    rsd[i].display(); //draw RSDs
  }

  //Iterate through each particle and ...
  for (int j=0; j<numParticles; j++) {
    b[j].rsdLocation(rsdLocs); //get info on RSD's location 
    b[j].update(); //update location info, and move this particle
    b[j].display(); //draw the particle
  }

  rsdDistribution(); //distribute particles according to rms power of each RSD

  //maps of each level
  translate(-1150, -1520, -475);
  image(map[0], 0, 0, map[0].width * 4, map[0].height * 4);

  translate(40, 132, 480);
  image(map[1], 0, 0, map[1].width * 3.8, map[1].height * 3.8);

  translate(-200, -160, 465);
  image(map[2], 0, 0, map[2].width * 4, map[2].height * 4);
}

void rsdDistribution() {
  float sum = 0;

  for (int i = 0; i < rsdInitPer.length; i++) {
    sum += rsd[i].getRMS();
  }

  for (int j = 0; j < rsd.length; j++) {
    rsdInitPer[j] = rsd[j].getRMS() / sum;
  }

  for (int k = 0; k < rsdDistrib.length; k++) {
    if (k >= 1)
      rsdDistrib[k] = (rsdDistrib[k-1] + rsdInitPer[k]);
    else
      rsdDistrib[k] = rsdInitPer[k];
  }

  for (int l=0; l<numParticles; l++) {
    b[l].applyForce();
  }
}

/*void ConnectServer() {
 
 String user     = "webserver";
 String pass     = "openup00";
 
 String database = "citygram";
 
 // connect to database of server "localhost"
 //
 cgdbase = new MySQL( this, "citygram.calarts.edu", database, user, pass );
 
 if (cgdbase.connect())
 {
 tableNames = cgdbase.getTableNames();
 for (int i = 0; i < tableNames.length; i++)
 {
 println(tableNames[i] + "\t" + i);
 }
 cgdbase.query( "SELECT * FROM %s", tableNames[0]);
 String[] columnNames = cgdbase.getColumnNames();
 for (int j = 0; j < columnNames.length; j++)
 {
 println(columnNames[j] + "\t" + j);
 }
 cgdbase.query( "SELECT * FROM %s", tableNames[2]);
 }
 else
 {
 println("connection failed !");
 }
 }
 
 void getData() {
 
 if (frameCount % 60 == 0)
 {
 
 for (int i = 0; i < 11; i++) {
 cgdbase.query( "SELECT * FROM %s", tableNames[i]);
 while (cgdbase.next ()) {
 if ( i != 9 ) {
 if (cgdbase.getFloat("td_rms") != 0) {
 rms[i] = cgdbase.getFloat("td_rms");
 
 //rsd[i].setRMS(random(1));
 //rsd[i].setRMS(rms[i]);
 //println("RSD:" + " " + (i+1) + "\t" + "RMS:" + " " + rms[i]);
 }
 }
 }
 }
 }
 }*/

//Test methods
void keyPressed() {
  //randomly set rms values for each RSD
  if ( key == 'r') {
    for (int i = 0; i < rsd.length; i++) {
      rsd[i].setRMS(random(1));
    }
  } 
  else if ( key == 'e') { //set all rms value for each RSD to be the same
    for (int i = 0; i < rsd.length; i++) {
      rsd[i].setRMS(.083);
    }
  } 
  else if (key == 'p') { //print rms values of each RSD to console
    for (int i = 0; i < rsdDistrib.length; i++) {
      print(rsdDistrib[i] + " ");
    }
    println();
  }
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/ids") == true) {
    numMsgs = msg.get(0).intValue();
  }
  if (msg.checkAddrPattern("/rms") == true) {
    for (int i = 0; i < numMsgs; i++) {
      rsd[i].setRMS(msg.get(i).floatValue()/2.0);
    }
  }
  if (msg.checkAddrPattern("/centroid") == true) {
    for (int i = 0; i < numMsgs; i++) {
      rsd[i].setHue((msg.get(i).floatValue()/4000.0 * 255) % 255);
    }
  }
}