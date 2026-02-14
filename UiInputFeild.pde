class InputField {
  float x, y, w, h;
  String text = "";
  String placeholder;
  boolean active = false;
  final int MAX_LENGTH = 9; // character cap

  InputField(float x, float y, float w, float h, String placeholder) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.placeholder = placeholder;
  }

  // draw normally using its own text
  void draw() {
    draw(text);
  }

  // draw using an externally provided string 
  void draw(String displayText) {
    stroke(active ? color(255, 200, 100) : 200);
    strokeWeight(3);
    fill(40, 60, 80, active ? 180 : 220);
    rectMode(CENTER);
    rect(x, y, w, h, 10);

    fill(255);
    textSize(24);
    textAlign(LEFT, CENTER);
    if (displayText.length() > 0) text(displayText, x - w/2 + 10, y);
    else { 
      fill(180); 
      text(placeholder, x - w/2 + 10, y); 
    }
    textAlign(CENTER, CENTER);
  }

  boolean isMouseOver() {
    return mouseX > x - w/2 && mouseX < x + w/2 &&
           mouseY > y - h/2 && mouseY < y + h/2;
  }
  
  void setActive(boolean val) {
    active = val; 
  }
  
  

  void handleKeyTyped(char key) {
    if (!active) return;

    if (key == BACKSPACE && text.length() > 0) {
      text = text.substring(0, text.length() - 1);
    } 
    else if (key != BACKSPACE && key != ENTER && text.length() < MAX_LENGTH) {
      text += key;
    }
  }
  


  void clear() { 
    text = ""; 
  }
}
