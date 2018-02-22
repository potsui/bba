// Constants
int TOWN = 3;
int HOSPITAL = 4;

// MapCellView takes care of rendering one cell on the map. 
class MapCellView {
  
  int x, y, cell_width, cell_height;
  PImage[] tiles;
  
  // Constructor
  MapCellView(int _x, int _y, int _cell_width, int _cell_height, PImage[] _tiles) {
    x = _x; 
    y = _y;
    cell_width = _cell_width;
    cell_height = _cell_height;
    tiles = _tiles;
  }
  
  // Renders this cell
  void render(MapCellModel model) {
    image(tiles[model.terrain], x, y, cell_width, cell_height);
    if (model.has_hospital) {
       image(tiles[HOSPITAL], x, y, cell_width, cell_height);
    }
  }
}