import java.util.Map;

// GLOBALS
int ROWS_OF_TEXT = 2;
int TEXT_LINE_HEIGHT = 14;
int TEXT_OFFSET_TOP = 20;
int TEXT_OFFSET_RIGHT = 280;

// MAP FIDUCIAL FRAME (MFF)

int mff_cols;
int mff_rows;
int mff_x;
int mff_y;
int mff_hw;
int mff_colrow_ratio = 8; // ratio of map fiducial columns
int mff_xy_ratio = 20; // ratio of map square positioning
int mff_hw_ratio = 10; // ratio of map square height and width

// FIDUCIALS
int MAP_FIDUCIAL_STANFORD = 0;
int MAP_FIDUCIAL_PALOALTO = 1;
int MAP_FIDUCIAL_EPA = 2;
int EVENT_FIDUCIAL_PER = 3;
int EVENT_FIDUCIAL_COM = 4;
int EVENT_FIDUCIAL_GLO = 5;
int EVENT_FIDUCIAL_HOME = 11;
int EVENT_FIDUCIAL_SCHOOL = 12;
int EVENT_FIDUCIAL_CHURCH = 13;
int EVENT_FIDUCIAL_TREE = 14;
int EVENT_FIDUCIAL_PROTESTER = 15;
int EVENT_FIDUCIAL_STREET = 16;
int SAVE_FIDUCIAL = 9;

class TUIOMapView {
  PApplet sketchRef;
  DatabaseServer db;
  int cols, rows;
  Frame camera_frame, map_frame, text_frame, map_fiducial_frame;
  MapCellView[][] cell_views;
  PImage[] tiles;
  PImage base_map;
  PImage timeline;
  HashMap<Integer,Fiducial> fiducials;
  int lastMoved;
  String data;
  String mapName;
  boolean inSaveMode;
  
  TUIOMapView(
      PApplet _sketchRef,
      int _cols, int _rows, 
      int x_in, int y_in, int width_in, int height_in, 
      int x_out, int y_out, int width_out, int height_out
  ) {
    sketchRef = _sketchRef;
    cols = _cols;
    rows = _rows;
    mff_cols = _cols/mff_colrow_ratio; 
    mff_rows = _rows/mff_colrow_ratio;
    mff_x = width_out/mff_xy_ratio;
    mff_y = height_out/mff_xy_ratio;
    mff_hw = width_out/mff_hw_ratio; 

    camera_frame = new Frame(cols, rows, x_in, x_out, width_in, height_in);
    map_frame = new Frame(cols, rows, x_out, y_out, width_out, height_out);
    map_fiducial_frame = new Frame(mff_cols, mff_rows, mff_x, mff_y, mff_hw, mff_hw); 
    text_frame = new Frame(
      1, 
      ROWS_OF_TEXT, 
      x_out + width_out - TEXT_OFFSET_RIGHT, 
      y_out + TEXT_OFFSET_TOP, 
      1, 
      ROWS_OF_TEXT * TEXT_LINE_HEIGHT
    );
    fiducials = new HashMap<Integer,Fiducial>();

    base_map = loadImage("stanford.png");;
    timeline = loadImage("timeline.png");
    mapName = "default";

    tiles = new PImage[] {
      loadImage("tiles/blank.png"),
      loadImage("tiles/you_icon.png"), // changed from hospital
      loadImage("tiles/stanford_icon.png"),
      loadImage("tiles/paloaltoicon.png"),
      loadImage("tiles/epaicon.png"),
      loadImage("tiles/personal_icon.png"),
      loadImage("tiles/community_icon.png"),
      loadImage("tiles/global_icon.png"),
      loadImage("tiles/home.png"),
      loadImage("tiles/school.png"),
      loadImage("tiles/church.png"),
      loadImage("tiles/tree.png"),
      loadImage("tiles/protester.png"),
      loadImage("tiles/street.png")
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
    background(255);
    image(base_map, map_frame.x, // edited to make map & timeline fullscreen
          map_frame.y,
          map_frame.frame_width,
          base_map.height * map_frame.frame_width / base_map.width);
    fill(0, 0, 0, 60); // add transparent background to timeline
    stroke(0, 0, 0, 0);
    rect(map_frame.x,  
          map_frame.y + map_frame.frame_height - timeline.height/1.5,
          map_frame.frame_width,
          timeline.height * map_frame.frame_width / timeline.width);
    image(timeline, map_frame.x, 
          map_frame.y + map_frame.frame_height - timeline.height - 60,
          map_frame.frame_width,
          timeline.height * map_frame.frame_width / timeline.width);
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
    
    // Renders text input for any markers that have them
    for (int id: fiducials.keySet()) {
      Fiducial f = fiducials.get(id);
      text(f.getText(), map_frame.get_x(camera_frame.get_row(f.getX())),
           map_frame.get_y(camera_frame.get_col(f.getY())));
    }

    fill(0);
    loadTextPrompt();
  }
  
  void handle_add_fiducial(int id, float x, float y, MapModel model) {
    if (inSaveMode) return;
    if (id == SAVE_FIDUCIAL) {
      if (fiducials.size() > 0) {
        inSaveMode = true;
        db = new DatabaseServer(sketchRef, null, 0);
        db.sendSessionData(mapName, fiducials);
      }
      return;
    }
    lastMoved = id;
    int col = camera_frame.get_col(x);
    int row = camera_frame.get_row(y);
    MapCellModel cell_model = model.cell_models[row][col];
    Fiducial f = new Fiducial(id, cell_model, "", x, y);
    fiducials.put(id, f);
    cell_model.add_hospital();
  }
  
  void handle_remove_fiducial(int id, float x, float y, MapModel model) {
    if (fiducials.size()==0) return;
    if (inSaveMode) {
      if (id == SAVE_FIDUCIAL) inSaveMode = false;
      return;
    }
    lastMoved = -1;
    int col = camera_frame.get_col(x);
    int row = camera_frame.get_row(y);
    MapCellModel cell_model = model.cell_models[row][col];
    fiducials.remove(id);
    cell_model.remove_hospital();
  }
  
  void handle_move_fiducial(int id, float x, float y, MapModel model) {
    if (fiducials.size()==0 || inSaveMode || id == SAVE_FIDUCIAL) return;
    lastMoved = id;
    int col = camera_frame.get_col(x);
    int row = camera_frame.get_row(y);
    Fiducial f = fiducials.get(id);
    MapCellModel new_cell_model = model.cell_models[row][col];
    MapCellModel old_cell_model = f.getModel();
    if (new_cell_model != old_cell_model) {
       old_cell_model.remove_hospital();
       new_cell_model.add_hospital();
       f.setModel(new_cell_model);
    }
  //  println("fiducial id is ", f.id, " fiducial text is ", f.text, " fiducial x is ", f.x, " fiducial y is ", f.y); // test which fiducial
    new_cell_model = changeIcon(id, row, col, new_cell_model);
    f.setX(x);
    f.setY(y);
    fiducials.put(id, f);
  }
  
  void handle_key_pressed(int keyCode) {
    if (fiducials.size() == 0 || inSaveMode) return;
    Fiducial f = fiducials.get(lastMoved);
    if (f == null) return;
    String input = f.getText();
    if (keyCode == BACKSPACE) {
      if (input.length() > 0) {
        input = input.substring(0, input.length()-1);
      }
    } else if (keyCode == DELETE) {
      input = "";
    } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
      input = input + key;
    }
    f.setText(input);
    println(input);
  }

  // Change map and event icon based on fiducial id
  MapCellModel changeIcon(int id, int row, int col, MapCellModel new_cell_model) {
    boolean inMapSquare = inMapSquare(row, col);
    
    if (id == MAP_FIDUCIAL_STANFORD) {
      if (inMapSquare) {
        base_map = loadImage("stanford.png");
        mapName = "stanford";
      }
      new_cell_model.is_sf();
    } else if (id == MAP_FIDUCIAL_PALOALTO) {
      if (inMapSquare) {
        base_map = loadImage("palo_alto.png");
        mapName = "paloalto";
      }
      new_cell_model.is_pa(); // Change icon to PA
    } else if (id == MAP_FIDUCIAL_EPA) {
      if (inMapSquare) {
        base_map = loadImage("east_palo_alto.png");
        mapName = "epa";
      }
      new_cell_model.is_epa(); // Change icon to PA
    } else if (id == EVENT_FIDUCIAL_PER){ 
      new_cell_model.is_per();
    } else if (id == EVENT_FIDUCIAL_COM){ 
      new_cell_model.is_com();
    } else if (id == EVENT_FIDUCIAL_GLO){ 
      new_cell_model.is_glo();
    } else if (id == EVENT_FIDUCIAL_HOME){ 
      new_cell_model.is_home();
    } else if (id == EVENT_FIDUCIAL_SCHOOL){ 
      new_cell_model.is_school();
    } else if (id == EVENT_FIDUCIAL_CHURCH){ 
      new_cell_model.is_church();
    } else if (id == EVENT_FIDUCIAL_TREE){ 
      new_cell_model.is_tree();
    } else if (id == EVENT_FIDUCIAL_PROTESTER){ 
      new_cell_model.is_protester();
    } else if (id == EVENT_FIDUCIAL_STREET){ 
      new_cell_model.is_street();
    }
    return new_cell_model;
  }

  boolean inMapSquare(int row, int col) {
    return col >= 1 && col <= mff_cols && row >= 1 && row <= mff_rows;
  }

  void loadTextPrompt() {
    int row = 3;
    text("Place markers on your home", text_frame.x, text_frame.get_y(row++));
    text("and other significant places.", text_frame.x, text_frame.get_y(row++));
    text("Type to add text to the marker", text_frame.x, text_frame.get_y(row++));
    text("you last touched.", text_frame.x, text_frame.get_y(row++));
  }
}