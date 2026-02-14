AppManager app;

void setup() {
  size(1920, 1080);
  background(0);
  app = new AppManager();  // creates a new instance of app which will handle everything
}

void draw() {
  app.update();
  app.draw();
}

void mousePressed() {
  app.mousePressed();
}

void keyPressed() {
  app.keyPressed();
}

void keyTyped() {
 app.keyTyped();
}
