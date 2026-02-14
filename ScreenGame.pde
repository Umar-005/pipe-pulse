class ScreenGame extends Screen {
  GameManager game;
  boolean endlessMode = false;
  int selectedLevel;

  ScreenGame(AppManager app, boolean endlessMode, int selectedLevel) {
    super(app, app.res);  
    this.endlessMode = endlessMode;
    this.selectedLevel = selectedLevel;

    // Create GameManager
    game = new GameManager(app, selectedLevel);

    // Sets game mode
    if (endlessMode) {
      game.endlessMode = true;
      game.setLevel(0);  // set endless to level 0
    } else {
      game.endlessMode = false;
      game.setLevel(selectedLevel);  
    }
  }

  void update() {}

  void draw() {
    game.updateAndDraw();
  }

  void handleMousePressed() {
    game.handleMouse(mouseX, mouseY);
  }

  void handleKeyPressed() {
    game.handleKey(key);
  }

  void handleKeyTyped() {}
}
