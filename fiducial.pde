class Fiducial {
  int id;
  MapCellModel model;
  String text;
  int x;
  int y;
  
  Fiducial(int _id, MapCellModel _model, String _text, int _x, int _y) {
    id = _id;
    model = _model;
    text = _text;
    x = _x;
    y = _y;
  }

  int getId() { return id; }
  MapCellModel getModel() { return model; }
  void setModel(MapCellModel _model) { model = _model; }
  String getText() { return text; }
  void setText(String _text) { text = _text; }
  int getX() { return x; }
  void setText(int _x) { x = _x; }
  int getY() { return y; }
  void setY(int _y) { y = _y; }
}