// Constants

// MapCellModel manages state for one map cell. 
class MapCellModel {
  
  int id, i, j, terrain; //is_city;
  float distance;
  boolean has_hospital;
  
  // Constructor
  MapCellModel(int _i, int _j, int _terrain) {
    i = _i; 
    j = _j; 
    terrain = _terrain;
    has_hospital = false;
    is_city = 0;
  }
  
  // Adds a hospital
  void add_hospital() {
    has_hospital = true;
  }
  
  void remove_hospital() {
     has_hospital = false; 
  }
  
/*  //detects which city if map fiducial
  void is_sf() {
    is_city = 2;
  }
  
  void is_pa() {
    is_city = 3;
  }
  
  void is_epa() {
    is_city = 4;
  } */
  
  
  // Defines how MapCellModels should be compared with each other
  // for equality. Here, two MapCellModels are equal if they 
  // share i and j. 
  boolean equals(MapCellModel other) {
   return i == other.i && j == other.j; 
  }
  
  // Returns true when there is no town or hospital here.
  boolean is_free() {
    return !has_hospital;
  }
}