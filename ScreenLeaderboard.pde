class ScreenLeaderboard extends Screen {
  Button backButton;
  boolean overBack = false;

  ScreenLeaderboard(AppManager app, ResourceManager res) {
    super(app, res);
    backButton = new Button(res,width / 2, height - 120, "Back");
  }

  void update() {}

  void draw() {
    drawBackground();

    int tableW = 800, tableH = 700, rowH = 60, startY = 100;
    float left = width / 2f - tableW / 2f;
    float top = startY;
    float centerY = top + tableH / 2f;
    float colRank = left + 60, colScore = left + tableW * 35/100, colUser = left + tableW * 65/100;

    noStroke();
    fill(0, 10, 40, 160);
    rect(width / 2f, centerY, tableW, tableH, 25);

    noFill();
    stroke(200);
    strokeWeight(3);
    rect(width / 2f, centerY, tableW, tableH, 25);

    fill(180, 220, 255);
    textFont(res.mainFont);
    textSize(36);
    textAlign(LEFT, CENTER);
    float headerY = top + 60;
    text("#", colRank, headerY);
    text("Score", colScore, headerY);
    text("Username", colUser, headerY);

    stroke(150, 150, 180, 150);
    strokeWeight(1);
    for (int i = 0; i <= 10; i++) line(left, top + 100 + i * rowH, left + tableW, top + 100 + i * rowH);
    line(colScore - 20, top + 10, colScore - 20, top + tableH - 10);
    line(colUser - 20, top + 10, colUser - 20, top + tableH - 10);

    ArrayList<String[]> leaderboard = app.db.getTop10();
    fill(255);
    textFont(res.buttonFont);
    textSize(30);
    textAlign(LEFT, CENTER);

    if (leaderboard != null && leaderboard.size() > 0) {
      for (int i = 0; i < leaderboard.size(); i++) {
        String[] row = leaderboard.get(i);
        float rowY = top + 120 + (i * rowH);
        text((i + 1) + ")", colRank, rowY);
        text(row[1], colScore, rowY);
        text(row[0], colUser, rowY);
      }
    } else {
      textAlign(CENTER, CENTER);
      text("No leaderboard data available", width / 2f, centerY);
    }

    overBack = backButton.isMouseOver();
    cursor(overBack ? HAND : ARROW);
    backButton.draw(overBack);
  }

  void handleMousePressed() {
    if (overBack) app.switchScreen(new ScreenMenu(app, res));
  }

  void handleKeyTyped() {}
  void handleKeyPressed(){}
    
    
    
}
