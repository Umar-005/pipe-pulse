class ScreenMenu extends Screen {
  Button levelsBtn;
  Button endlessBtn;
  Button leaderboardBtn;
  Button logoutBtn;
  int buttonHeight = 70;
  int buttonSpacing = 30;
  int userHighScore = 0;

  ScreenMenu(AppManager app, ResourceManager res) {
    super(app, res);

    float logoY = res.logo.height / 2 + 20;
    float startY = logoY + res.logo.height / 2 + 50;
    
    userHighScore = app.db.getUserHighScore(app.currentUser);

    levelsBtn = new Button(res, width / 2, startY, "Levels");
    endlessBtn = new Button(res, width / 2, startY + buttonHeight + buttonSpacing, "Endless");
    leaderboardBtn = new Button(res, width / 2, startY + 2 * (buttonHeight + buttonSpacing), "Leaderboard");
    logoutBtn = new Button(res, width / 2, startY + 3 * (buttonHeight + buttonSpacing), "Logout");
  }

  void update() {}

  void draw() {
    drawBackground();
    


    float logoY = res.logo.height / 2 + 20;
    imageMode(CENTER);
    image(res.logo, width / 2, logoY);
    textAlign(CENTER);
      fill(255);
      textSize(50);
      text("High Score: " + userHighScore, width / 2, logoY + res.logo.height / 2 - 30);

    boolean overLevels = levelsBtn.isMouseOver();
    boolean overEndless = endlessBtn.isMouseOver();
    boolean overLeaderboard = leaderboardBtn.isMouseOver();
    boolean overLogout = logoutBtn.isMouseOver();

    cursor((overLevels || overEndless || overLeaderboard || overLogout) ? HAND : ARROW);

    levelsBtn.draw(overLevels);
    endlessBtn.draw(overEndless);
    leaderboardBtn.draw(overLeaderboard);
    logoutBtn.draw(overLogout);
  }

  void handleMousePressed() {
    if (levelsBtn.isMouseOver()) {
      app.switchScreen(new ScreenLevels(app, res));
    } 
    else if (endlessBtn.isMouseOver()) {
       app.switchScreen(new ScreenGame(app, true, 0)); 
    } 
    else if (leaderboardBtn.isMouseOver()) {
      app.switchScreen(new ScreenLeaderboard(app, res));
    } 
    else if (logoutBtn.isMouseOver()) {
      app.currentUser = "";
      app.switchScreen(new ScreenLoginMenu(app, res));
    }
  }

  void handleKeyTyped() {}
  void handleKeyPressed() {}
}
