import TUIO.*;
import processing.net.*; 

TuioProcessing tuioClient;
Client c;

MapModel model;
TUIOMapView view;

String data;

int[][] terrain = {
  { 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 }, 
  { 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 }, 
  { 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 }, 
  { 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 }, 
  { 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0 }, 
  { 0, 0, 0, 0, 1, 0, 0, 0, 2, 2, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 0, 0, 1, 0, 0, 0, 2, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 0, 0, 1, 0, 0, 2, 2, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0 },
  { 0, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
  { 0, 0, 2, 2, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
  { 0, 0, 2, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
  { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 2, 0, 2, 0, 0, 0 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 2, 2, 2, 2, 0, 2 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 2, 2, 2, 2, 2 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 2, 2 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
};

void settings() {
  size(576, 576);
}

void setup() {
   tuioClient  = new TuioProcessing(this);
   model = new MapModel(terrain, 3);
   view = new TUIOMapView(24, 24, 0, 0, 1, 1, 0, 0, 576, 576);

   c = new Client(this, "sharedstory.herokuapp.com", 80);
   c.write("GET / HTTP/1.1\r\n");
   c.write("Host: sharedstory.herokuapp.com\r\n");
   c.write("\r\n");
}

void draw() {
  view.render(model);
  if (c.available() > 0) {
    data += c.readString();
    println(data);
  }
}

void addTuioObject(TuioObject obj) {
  int id = obj.getSymbolID();
  float x = obj.getX();
  float y = obj.getY();

  println("ADD", id);
  String postBody = 0 + " " + id + " " + x + " " + y + "\n"; // TODO POST request
  view.handle_add_fiducial(id, x, y, model);
}

void removeTuioObject(TuioObject obj) {
  int id = obj.getSymbolID();
  float x = obj.getX();
  float y = obj.getY();

  println("REMOVE", id);
  String postBody = 1 + " " + id + " " + x + " " + y + "\n"; // TODO POST request
  view.handle_remove_fiducial(id, x, y, model);
}

void updateTuioObject(TuioObject obj) {
  int id = obj.getSymbolID();
  float x = obj.getX();
  float y = obj.getY();

  println("MOVE", id, x, y);
  String postBody = 2 + " " + id + " " + x + " " + y + "\n"; // TODO POST Request
  view.handle_move_fiducial(id, x, y, model);
}

void keyPressed() {
  view.handle_key_pressed(keyCode);
}