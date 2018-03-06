import TUIO.*;
import processing.net.*; 

int SCREEN_WIDTH = 576;
int SCREEN_HEIGHT = 576;
int PORTNO = 80;
String SERVER = "sharedstory.herokuapp.com";

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
  if (view == null) view = createMapView();
  if (c == null) c = new Client(this, SERVER, PORTNO);
  sendSimpleGetRequest();
  sendSessionData();
}

void draw() {
  view.render(model);
  if (c.available() > 0) {
    data += c.readString();
    println(data);
  }
}

void addTuioObject(TuioObject obj) {
  if (view == null) view = createMapView();
  int id = obj.getSymbolID();
  float x = obj.getX();
  float y = obj.getY();

  println("ADD", id);
  view.handle_add_fiducial(id, x, y, model);
}

void removeTuioObject(TuioObject obj) {
  if (view == null) view = createMapView();
  int id = obj.getSymbolID();
  float x = obj.getX();
  float y = obj.getY();

  println("REMOVE", id);
  view.handle_remove_fiducial(id, x, y, model);
}

void updateTuioObject(TuioObject obj) {
  if (view == null) view = createMapView();
  int id = obj.getSymbolID();
  float x = obj.getX();
  float y = obj.getY();

  println("MOVE", id, x, y);
  view.handle_move_fiducial(id, x, y, model);
}

void keyPressed() {
  view.handle_key_pressed(keyCode);
}

void sendSimpleGetRequest() {
  if (c == null) c = new Client(this, SERVER, PORTNO);
  c.write("GET / HTTP/1.1\r\n");
  c.write("Host: " + SERVER + "\r\n");
  c.write("\r\n");
}

void sendSessionData() {
  if (c == null) c = new Client(this, SERVER, PORTNO);
  c.write("POST /session/add HTTP/1.1\r\n");
  c.write("Host: " + SERVER + "\r\n");
  c.write("Content-Type: application/json\r\n");
  c.write("\r\n");
  c.write("{\"key\": \"value\"}\r\n");
  c.write("\r\n");
}

TUIOMapView createMapView() {
  return new TUIOMapView(24, 24, 0, 0, 1, 1, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}