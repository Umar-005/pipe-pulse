abstract class Screen {
  AppManager app;
  ResourceManager res;

  Screen(AppManager app, ResourceManager res) {
    this.app = app;
    this.res = res;
  }
   void drawBackground() {
    imageMode(CENTER);
    image(res.background, width/2, height/2, width, height);
  }

  abstract void update();
  abstract void draw();
  abstract void handleMousePressed();
  abstract void handleKeyPressed();
  abstract void handleKeyTyped();
}
