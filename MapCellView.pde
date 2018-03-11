// Constants
int BLANK = 0;
int HOSPITAL = 1;
// City tiles
int SF = 2;
int PA = 3;
int EPA = 4;

// Event tiles (not equivalent to fiducial numbers)
int PER = 5;
int COM = 6;
int GLO = 7;
int HOME = 8;
int SCHOOL = 9;
int CHURCH = 10;
int TREE = 11;
int PROTESTER = 12;
int STREET = 13;


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
  
  // Renders this cell and chooses the fiducial icon
  void render(MapCellModel model) {
    image(tiles[BLANK], x, y, cell_width, cell_height);
    if (model.has_hospital) {
       if (model.tile_type == 0) {
         image(tiles[HOSPITAL], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 2){
         image(tiles[SF], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 3){
         image(tiles[PA], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 4){
         image(tiles[EPA], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 5){
         image(tiles[PER], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 6){
         image(tiles[COM], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 7){
         image(tiles[GLO], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 11){
         image(tiles[HOME], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 12){
         image(tiles[SCHOOL], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 13){
         image(tiles[CHURCH], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 14){
         image(tiles[TREE], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 15){
         image(tiles[PROTESTER], x, y, cell_width, cell_height);
       }
       if (model.tile_type == 16){
         image(tiles[STREET], x, y, cell_width, cell_height);
       } 
    }
    
  }
}