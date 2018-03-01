// Source code for additional window: https://gist.github.com/atduskgreg/666e46c8408e2a33b09a
// Source code for keyboard: https://amnonp5.wordpress.com/2012/01/28/25-life-saving-tips-for-processing/
String prompt = "Enter an event description:";
String input = "";

class TextInputWindow extends PApplet {
  TextInputWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  public void settings() {
    size(576, 576);
  }

  void setup() {
    background(255);
    textAlign(CENTER);
    textSize(14);
    fill(0);
  }

  void draw() {
    background(255);
    text(prompt, 0, 0, width, height);
    text(input, 0, 50, width, height);
  }

  void mousePressed() {
    println("mousePressed in secondary window");
  }
  
  void keyPressed() {
    if (keyCode == BACKSPACE) {
      if (input.length() > 0) {
        input = input.substring(0, input.length()-1);
      }
    } else if (keyCode == DELETE) {
      input = "";
    } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
      input = input + key;
    }
  }

  String getInput() {
    return input;
  }

  void setInput(String _input) {
    input = _input;
  }
}