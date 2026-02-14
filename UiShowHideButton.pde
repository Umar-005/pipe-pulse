class ShowButton {
  float x, y, w, h;
  boolean hovered = false;
  boolean showing = false;
  ResourceManager res;

  ShowButton(  ResourceManager res, float x, float y, float w, float h) {
    this.res = res;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void draw(boolean showing) {
    rectMode(CENTER);
    stroke(isMouseOver() ? color(255, 200, 100) : 200);
    strokeWeight(2);
    fill(40, 60, 80, 200);
    rect(x, y, w, h, 8);
    fill(255);
    textFont(res.buttonFont);
    textSize(18);
    textAlign(CENTER, CENTER);
    text(showing ? "Hide" : "Show", x, y);
  }


  boolean isMouseOver() {
    hovered = mouseX > x - w / 2 && mouseX < x + w / 2 &&
               mouseY > y - h / 2 && mouseY < y + h / 2;
    return hovered;
  }


  void toggle(){
    showing = !showing;
  }
}
