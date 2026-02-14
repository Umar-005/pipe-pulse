class Button {
  float x, y;
  float width, height;
  String label;
  ResourceManager res;

  Button(ResourceManager res,float x, float y, String label) {
    this.res = res;
    this.x = x;
    this.y = y;
    this.width = 300;   // default width 
    this.height = 80;   // default height
    this.label = label;
  }

Button(ResourceManager res, float x, float y, float width, float height, String label) {
  this.res = res;
  this.x = x;
  this.y = y;
  this.width = width;
  this.height = height;
  this.label = label;
}



void draw(boolean hovered) {
  pushStyle(); // Save current fill stroke text settings

  // Off screen graphics for gradient background
  PGraphics pg = createGraphics((int)width, (int)height);
  pg.beginDraw();
  pg.noStroke();

  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    int c1 = color(90, 100, 120);
    int c2 = color(50, 60, 80);
    int c = lerpColor(c1, c2, inter);
    pg.stroke(c);
    pg.line(0, i, width, i);
  }

  if (hovered) {
    pg.noStroke();
    pg.fill(250, 220, 220, 30);
    pg.rectMode(CENTER);
    pg.rect(width / 2, height / 2, width, height, 20);
  }

  pg.endDraw();

  // Create rounded mask
  PGraphics mask = createGraphics((int)width, (int)height);
  mask.beginDraw();
  mask.background(0);
  mask.fill(255);
  mask.noStroke();
  mask.rectMode(CENTER);
  mask.rect(width / 2, height / 2, width, height, 20);
  mask.endDraw();
  pg.mask(mask);

  // Draw button to main screen
  imageMode(CENTER);
  image(pg, x, y);

  // Border
  stroke(0);
  strokeWeight(5);
  noFill();
  rectMode(CENTER);
  rect(x, y, width, height, 20);

  // Label
  textFont(res.buttonFont);
  textSize(36);
  fill(hovered ? color(0, 10, 50) : 255);
  textAlign(CENTER, CENTER);
  text(label, x, y - 3);

  popStyle(); // Restore previous fill stroke text
}


  boolean isMouseOver() {
    return mouseX > x - width / 2 &&
           mouseX < x + width / 2 &&
           mouseY > y - height / 2 &&
           mouseY < y + height / 2;
  }
}
