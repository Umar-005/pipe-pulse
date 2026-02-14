class ScreenLevels extends Screen {
  Button backButton;
  int totalLevels = 10;
  int levelsPerColumn = 5;
  int buttonHeight = 70;
  int buttonWidth = 300;
  int buttonSpacing = 70;
  int shakeLevelIndex = -1;
  int shakeDuration = 500;
  int shakeStartTime = 0;
  int locked = app.db.getLevel(app.currentUser); // gets users level

  ScreenLevels(AppManager app, ResourceManager res) {
    super(app, res);
    backButton = new Button(res, width / 2, 200 + 5 * (buttonHeight + buttonSpacing), "Back");
  }

  void update() {}

  void draw() {
    drawBackground();
    int startY = 200;

    for (int i = 0; i < totalLevels; i++) {
      int col = (i < levelsPerColumn) ? 0 : 1;
      int row = i % levelsPerColumn;
      float x = (col == 0) ? width / 3 : width / 3 * 2;
      float y = startY + row * (buttonHeight + buttonSpacing);

      boolean hovered = mouseX > x - buttonWidth / 2 && mouseX < x + buttonWidth / 2 &&
                        mouseY > y - buttonHeight / 2 && mouseY < y + buttonHeight / 2;

      // shake animation for locked button
      if (i == shakeLevelIndex) {
        float elapsed = millis() - shakeStartTime;
        if (elapsed < shakeDuration) {
          float amp = map(elapsed, 0, shakeDuration, 10, 0); // sets amplitude to 10 at the start of the shake and then 0 at the end
          x += sin(elapsed /20) * amp;
        } else shakeLevelIndex = -1;
      }

      Button tempBtn = new Button(res,x, y,buttonWidth, buttonHeight,  "Level " + (i + 1));
      tempBtn.draw(hovered);

      if (i + 1 > locked) {
        noStroke();
        fill(0, 150);
        rectMode(CENTER);
        rect(x, y, buttonWidth, buttonHeight, 15);
        imageMode(CENTER);
        image(res.lockIcon, x, y, 48, 48);
      }
    }

    boolean overBack = backButton.isMouseOver();
    backButton.draw(overBack);
  }

  void handleMousePressed() {
    if (backButton.isMouseOver()) app.switchScreen(new ScreenMenu(app, res));
    int startY = 200;


    // checks to see if a level is being clicked makes it shake if locked and starts game if unlocked
    for (int i = 0; i < totalLevels; i++) {
      int col = (i < levelsPerColumn) ? 0 : 1;
      int row = i % levelsPerColumn;
      float x = (col == 0) ? width / 3 : width / 3 * 2;
      float y = startY + row * (buttonHeight + buttonSpacing);

      if (mouseX > x - buttonWidth / 2 && mouseX < x + buttonWidth / 2 &&
          mouseY > y - buttonHeight / 2 && mouseY < y + buttonHeight / 2) {
        if (i + 1 > locked) {
          shakeStartTime = millis();  // gets the time when the animation begins
          shakeLevelIndex = i;
        } else   app.switchScreen(new ScreenGame(app, false, i + 1));
      }
    }
  }

  void handleKeyTyped() {}
    void handleKeyPressed(){}
}
