import java.util.Map;
import processing.net.*;

class DatabaseServer {
  int PORTNO = 80;
  String SERVER = "sharedstory.herokuapp.com";

  Client c;
  String data;

  // DatabaseServer(this, host=null, port=0);
  DatabaseServer(PApplet parent, String host, int port) {
    c = new Client(parent, (host == null) ? SERVER : host, (port == 0) ? PORTNO : port);
  }

  String getData() {
    if (c.available() > 0) return c.readString();
    return null;
  }
  
  void sendSimpleGetRequest() {
    c.write("GET / HTTP/1.1\r\n");
    c.write("Host: " + SERVER + "\r\n");
    c.write("\r\n");
  }

  void sendSessionData(String map, HashMap<Integer,Fiducial> fiducials) {
    println("SENDING SESSION DATA");
    String jsonBody = createJsonString(map, fiducials);
    c.write("POST /session/add HTTP/1.1\r\n");
    c.write("Host: " + SERVER + "\r\n");
    c.write("Content-Type: application/json\r\n");
    c.write("Content-Length: " + jsonBody.length() + "\r\n");
    c.write("\r\n");
    c.write(jsonBody + "\r\n");
    c.write("\r\n");
  }

  private String createJsonString(String map, HashMap<Integer,Fiducial> fiducials) {
    JSONObject json = new JSONObject();
    json.put("map", map);
  
    JSONArray markers = new JSONArray();
    int i = 0;
    for (int id: fiducials.keySet()) {
      Fiducial f = fiducials.get(id);
      JSONObject item = new JSONObject();
      item.put("x", f.getX());
      item.put("y", f.getY());
      item.put("text", f.getText());
      markers.setJSONObject(i++, item);
    }
    json.put("markers", markers);
  
    return json.toString();
  }
}