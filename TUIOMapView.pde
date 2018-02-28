import java.util.Map;

int ROWS_OF_TEXT = 2;
int TEXT_LINE_HEIGHT = 14;
int TEXT_OFFSET_TOP = 20;
int TEXT_OFFSET_RIGHT = 180;

class TUIOMapView {
  int cols, rows;
  Frame camera_frame, map_frame, text_frame, map_fiducial_frame;
  MapCellView[][] cell_views;
  PImage[] tiles;
  PImage base_map;
  PImage timeline;
  HashMap<Integer,MapCellModel> fiducials;
  
  TUIOMapView(
      int _cols, int _rows, 
      int x_in, int y_in, int width_in, int height_in, 
      int x_out, int y_out, int width_out, int height_out
  ) {
    cols = _cols;
    rows = _rows;
    camera_frame = new Frame(cols, rows, x_in, x_out, width_in, height_in);
    map_frame = new Frame(cols, rows, x_out, y_out, width_out, height_out);
    map_fiducial_frame = new Frame(3, 3, 30, 20, 55, 55);
    text_frame = new Frame(
      1, 
      ROWS_OF_TEXT, 
      x_out + width_out - TEXT_OFFSET_RIGHT, 
      y_out + TEXT_OFFSET_TOP, 
      1, 
      ROWS_OF_TEXT * TEXT_LINE_HEIGHT
    );
    fiducials = new HashMap<Integer,MapCellModel>();

    base_map = loadImage("sf-map.png");;
    timeline = loadImage("timeline.png");

    tiles = new PImage[] {
      loadImage("tiles/blank.png"),
      loadImage("tiles/hospital.png")
    };

    cell_views = new MapCellView[rows][cols];
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        cell_views[j][i] = new MapCellView(
          map_frame.get_x(i), 
          map_frame.get_y(j),
          map_frame.cell_width, 
          map_frame.cell_height, 
          tiles
        );
      }
    }
  }
  
  void render(MapModel model) {
    background(0);
    image(base_map, map_frame.x, 
          map_frame.y,
          map_frame.frame_width,
          base_map.height * map_frame.frame_width / base_map.width);
    image(timeline, map_frame.x, 
          map_frame.y + map_frame.frame_width - timeline.height,
          map_frame.frame_width,
          base_map.height * map_frame.frame_width / base_map.width);
     // Create the map-fiducial-holder square 
    stroke(0, 0, 0);
    fill(0, 0, 0, 20);
    rect(map_fiducial_frame.x, 
        map_fiducial_frame.y, 
        map_fiducial_frame.frame_width, 
        map_fiducial_frame.frame_height, 
        7);
    fill(0);
    text("Place map fiducial here", map_fiducial_frame.x, map_fiducial_frame.y);

    // Checks if has hospital, then renders
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        if (model.cell_models[j][i].has_hospital) {
          cell_views[j][i].render(model.cell_models[j][i]);
        }
      }
    }    
    fill(0);
    int row = 0;
    text("Place markers on your home", text_frame.x, text_frame.get_y(row++));
    text("and other significant places", text_frame.x, text_frame.get_y(row++));
  }
  
  void handle_add_fiducial(int id, float x, float y, MapModel model) {
    int col = camera_frame.get_col(x);
    int row = camera_frame.get_row(y);
    MapCellModel cell_model = model.cell_models[row][col];
    fiducials.put(id, cell_model);
    cell_model.add_hospital();
  }
  
  void handle_remove_fiducial(int id, float x, float y, MapModel model) {
    int col = camera_frame.get_col(x);
    int row = camera_frame.get_row(y);
    MapCellModel cell_model = model.cell_models[row][col];
    fiducials.remove(id);
    cell_model.remove_hospital();
  }
  
  void handle_move_fiducial(int id, float x, float y, MapModel model) {
    int col = camera_frame.get_col(x);
    int row = camera_frame.get_row(y);
    MapCellModel new_cell_model = model.cell_models[row][col];
    MapCellModel old_cell_model = fiducials.get(id);
    if (new_cell_model != old_cell_model) {
       fiducials.put(id, new_cell_model);
       old_cell_model.remove_hospital();
       new_cell_model.add_hospital(); 
    }
//  Change map based on fiducial in map square
    if ((id == 0) &&
        (col >= 1) && (col <= 3) && 
        (row >= 1) && (row <= 3)){
      base_map = loadImage("sf-map.png");;
    }
    if ((id == 1) &&
        (col >= 1) && (col <= 3) && 
        (row >= 1) && (row <= 3)){
      base_map = loadImage("palo_alto.png");;
    }
    if ((id == 2) &&
        (col >= 1) && (col <= 3) && 
        (row >= 1) && (row <= 3)){
      base_map = loadImage("east_palo_alto.png");;
        
    }
  }
}