// Source code for additional window: https://gist.github.com/atduskgreg/666e46c8408e2a33b09a
// Source code for keyboard: https://amnonp5.wordpress.com/2012/01/28/25-life-saving-tips-for-processing/
String myText = "Type something";

class TextInputWindow extends PApplet {
  TextInputWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void setup() {
    background(255);
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(0);
  }

  void draw() {
    background(255);
    text(myText, 0, 0, width, height);
  }

  void mousePressed() {
    println("mousePressed in secondary window");
  }
  
  void keyPressed() {
  if (keyCode == BACKSPACE) {
    if (myText.length() > 0) {
      myText = myText.substring(0, myText.length()-1);
    }
  } else if (keyCode == DELETE) {
    myText = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    myText = myText + key;
  }
}
}