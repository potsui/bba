// Source: https://gist.github.com/atduskgreg/666e46c8408e2a33b09a

class PWindow extends PApplet {
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void setup() {
    background(255);
  }

  void draw() {
    
  }

  void mousePressed() {
    println("mousePressed in secondary window");
  }
}