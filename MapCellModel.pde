// Constants

// MapCellModel manages state for one map cell. 
class MapCellModel {
  
  int id, i, j, terrain;
  float distance;
  boolean has_hospital;
  
  // Constructor
  MapCellModel(int _i, int _j, int _terrain) {
    i = _i; 
    j = _j; 
    terrain = _terrain;
    has_hospital = false;
  }
  
  // Adds a hospital
  void add_hospital() {
    has_hospital = true;
  }
  
  void remove_hospital() {
     has_hospital = false; 
  }
  
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