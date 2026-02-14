class GameManager {
  AppManager app;
  ResourceManager res;

  PImage pipeImg, coreImg, bgImg, heartImg, baseBallImg, heartBallImg, decoyBallImg, deathBallImg, powerBallImg;

  ArrayList<Pipe> pipes = new ArrayList<Pipe>();
  ArrayList<Ball> balls = new ArrayList<Ball>();
  ArrayList<Level> levels = new ArrayList<Level>();
  Level currentLevel;

  int currentLevelIndex;
  int ballsFiredThisLevel;
  int ballsRemaining;
  int lives = 5;
  boolean gameOver = false;
  boolean endlessMode = false;
  int score = 0;
  boolean levelComplete = false;

  // Pulse timing
  boolean isPaused = false;
  boolean isPulsing = false;
  boolean ballFired = false;
  int activePipe = -1;
  float pulseStartTime = 0;
  float pulseDuration = 0.3f;

  // score commit guard
  boolean scoreSaved = false;

  // Endless difficulty scaling
  float difficultyTimer = 0;
  float difficultyLevel = 1;
  float difficultyIncreaseRate = 0.02f;
  float maxDifficulty = 3.0f;
  
  // Power outage effect
  boolean screenDark = false;
  float darkStartTime = 0;
  float darkDuration = 1200; 


  // UI Buttons
  Button resumeBtn, restartBtn, menuBtn, nextLevelBtn;

  GameManager(AppManager app,int currentLevelIndex) {
    this.app = app;
    this.res = app.res;
    this.currentLevelIndex = currentLevelIndex;

    this.pipeImg = res.pipe;
    this.coreImg = res.core;
    this.bgImg = res.background;
    this.heartImg = res.heart;
    this.baseBallImg = res.baseBall;
    this.heartBallImg = res.heartBall;
    this.decoyBallImg = res.decoyBall;
    this.deathBallImg = res.deathBall;
    this.powerBallImg = res.powerBall;

    setupPipes();
    setupLevels();
    currentLevel = levels.get(1);
    ballsRemaining = currentLevel.totalBalls;

    resumeBtn   = new Button(res, width / 2, height / 2 + 50,  "Resume");
    restartBtn  = new Button(res, width / 2, height / 2 + 150, "Restart");
    menuBtn     = new Button(res, width / 2, height / 2 + 250, "Menu");
    nextLevelBtn= new Button(res, width / 2, height / 2 + 100, "Next Level");
  }

  // level setup
  void setupLevels() {
    levels.clear();
    levels.add(new Level(0, "Endless", 10, 13, 999999, 0.9f));
    levels.add(new Level(1, "Level 1", 6, 10, 1, 2.0f));
    levels.add(new Level(2, "Level 2", 6, 9, 1, 1.8f));
    levels.add(new Level(3, "Level 3", 7, 10, 25, 1.7f));
    levels.add(new Level(4, "Level 4", 8, 11, 30, 1.6f));
    levels.add(new Level(5, "Level 5", 9, 12, 35, 1.5f));
    levels.add(new Level(6, "Level 6", 10, 13, 40, 1.4f));
    levels.add(new Level(7, "Level 7", 11, 14, 45, 1.3f));
    levels.add(new Level(8, "Level 8", 12, 15, 50, 1.2f));
    levels.add(new Level(9, "Level 9", 13, 16, 55, 1.1f));
    levels.add(new Level(10, "Level 10", 14, 17, 60, 1.0f));
  }

  void setupPipes() {
    PVector center = new PVector(width / 2, height / 2);
    float edgeOffset = 0, bottomOffset = 40;
    for (int i = 0; i < 2; i++) pipes.add(new Pipe(map(i, 0, 1, width * 0.25f, width * 0.75f), edgeOffset, center, pipeImg));
    for (int i = 0; i < 2; i++) pipes.add(new Pipe(width - edgeOffset, map(i, 0, 1, height * 0.33f, height * 0.66f), center, pipeImg));
    for (int i = 0; i < 2; i++) pipes.add(new Pipe(map(i, 0, 1, width * 0.25f, width * 0.75f), height - bottomOffset, center, pipeImg));
    for (int i = 0; i < 2; i++) pipes.add(new Pipe(edgeOffset, map(i, 0, 1, height * 0.33f, height * 0.66f), center, pipeImg));
  }

  void setLevel(int index) {
    currentLevel = levels.get(index);
    ballsFiredThisLevel = 0;
    ballsRemaining = currentLevel.totalBalls;
    lives = 5;
  }

  // main game loop
  void updateAndDraw() {
    image(bgImg, width / 2, height / 2, width, height);
    image(coreImg, width / 2, height / 2);
    drawHearts(heartImg, lives);
    drawUI();
    drawPauseButton();

    if (levelComplete) {
      drawLevelComplete();
      return;
    }

    if (gameOver) {
      commitScoreIfNeeded();
      drawGameOver();
      return;
    }

    if (isPaused) {
      drawPauseOverlay();
      return;
    }

    float now = millis() / 1000.0f;

    // Increases the pulse inteval by the difficulty increase rate amount every second no matter the fps
    if (endlessMode && !isPaused && !gameOver) {
      difficultyTimer += (1.0f / frameRate);
      difficultyLevel = constrain(1 + difficultyTimer * difficultyIncreaseRate, 1, maxDifficulty);
    }

    // Pulse logic
    if (isPulsing) {
      float elapsed = now - pulseStartTime;
      for (int i = 0; i < pipes.size(); i++) {
        if (i == activePipe && elapsed < pulseDuration)
          pipes.get(i).animatePulse(elapsed, pulseDuration);
        else
          pipes.get(i).display();
      }

      // Fire ball halfway through pulse
      if (!ballFired && elapsed >= pulseDuration * 0.5f) {
        Pipe p = pipes.get(activePipe);
        PVector spawn = p.getMouthPosition();
        PVector dir = new PVector(width / 2f - spawn.x, height / 2f - spawn.y).normalize(); // keeps the direcion the same but makes the magnitude 1 

        Ball b = spawnRandomBall(spawn.x, spawn.y, dir, p.pipeWidth * 0.20f, currentLevel, coreImg, lives);

        if (endlessMode) b.speed *= difficultyLevel;

        balls.add(b);
        ballsFiredThisLevel++;
        ballFired = true;
      }

      if (elapsed >= pulseDuration) {
        isPulsing = false;
        pulseStartTime = now;
      }
    } else {
      float dynamicInterval = endlessMode ? currentLevel.pulseInterval / difficultyLevel : currentLevel.pulseInterval;

      if (now - pulseStartTime >= dynamicInterval) {
        if (!endlessMode) {
          if (ballsFiredThisLevel < currentLevel.totalBalls) firePulse(now);
          else if (balls.isEmpty() && ballsRemaining <= 0) levelComplete = true;
        } else firePulse(now);
      }
      for (Pipe p : pipes) p.display();
    }

    drawBalls();
    
    // Power outage effect
if (screenDark) {
  float elapsed = millis() - darkStartTime;

  // Fade in and out
  float alpha;
  if (elapsed < darkDuration / 2) {
    // Fade to black
    alpha = map(elapsed, 0, darkDuration / 2, 0, 255);  // as elapsed goes form 0 to dark duration transparantcy changes form 0 to 255
  } else {
    // Fade back to light
    alpha = map(elapsed, darkDuration / 2, darkDuration, 255, 0);
  }

  // Draw the overlay
  fill(0, 0, 0, alpha);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, height);

  // End blackout after duration
  if (elapsed >= darkDuration) {
    screenDark = false;
  }
}

  }

  // Ball Spawning
  Ball spawnRandomBall(float x, float y, PVector dir, float size, Level level, PImage core, int livesLeft) {
    float r = random(1);
    if (r < 0.75f)  return new BaseBall(x, y, dir, size, level, baseBallImg, core, livesLeft);
    else if (r < 0.83f) return new HeartBall(x, y, dir, size, level, heartBallImg, core, livesLeft);
    else if (r < 0.9f)  return new DecoyBall(x, y, dir, size, level, decoyBallImg, core, livesLeft);
    else if (r < 0.96f) return new DeathBall(x, y, dir, size, level, deathBallImg, core, livesLeft);
    else               return new PowerBall(x, y, dir, size, level, powerBallImg, core, livesLeft);
  }

  // Draw and update balls
  void drawBalls() {
    for (int i = balls.size() - 1; i >= 0; i--) {
      Ball b = balls.get(i);
      b.update();

      if (b.inCore()) {
        lives = b.livesAfterCoreHit(lives);
        balls.remove(i);
        ballsRemaining--;
        if (lives <= 0) {
          gameOver = true;
          commitScoreIfNeeded();
        }
      } else if (b.offScreen()) {
        balls.remove(i);
        ballsRemaining--;
      } else {
        b.display();
      }
    }
  }

  void handleMouse(float mx, float my) {
    if (isPaused) {
      if (resumeBtn.isMouseOver()) isPaused = false;
      else if (restartBtn.isMouseOver()) { restart(); isPaused = false; }
      else if (menuBtn.isMouseOver()) app.switchScreen(new ScreenMenu(app, res));
      return;
    }

    if (levelComplete) {
      app.db.saveLevel(app.currentUser,currentLevelIndex + 1);
      if (nextLevelBtn.isMouseOver()) nextLevel();
      else if (menuBtn.isMouseOver()) app.switchScreen(new ScreenMenu(app, res));
      return;
    }

    if (gameOver) {
      if (restartBtn.isMouseOver()) { restart(); return; }
      else if (menuBtn.isMouseOver()) {
        commitScoreIfNeeded();
        app.switchScreen(new ScreenMenu(app, res));
        return;
      }
    }

    if (mx > width - 100 && mx < width - 20 && my > 30 && my < 100) {
      isPaused = !isPaused;
      return;
    }

for (int i = balls.size() - 1; i >= 0; i--) {
  Ball b = balls.get(i);
  if (b.clicked(mx, my)) {
    lives = b.livesAfterClicked(lives);
    balls.remove(i);
    ballsRemaining--;

    // If its a PowerBall trigger blackout
    if (b instanceof PowerBall) {
      screenDark = true;
      darkStartTime = millis();
    }

    if (endlessMode) score += 100;
    if (lives <= 0) {
      gameOver = true;
      commitScoreIfNeeded();
    }
    break;
  }
}

  }


  void firePulse(float currentTime) {
    activePipe = (int) random(pipes.size());
    pulseStartTime = currentTime;
    isPulsing = true;
    ballFired = false;
  }

  void commitScoreIfNeeded() {
    if (!endlessMode || scoreSaved || app == null || app.db == null) return;
    if (app.currentUser == null || app.currentUser.length() == 0) return;

    app.db.saveHighScore(app.currentUser, score);
    app.db.updateTop10(app.currentUser, score);
    scoreSaved = true;
  }

  void handleKey(char key) {
    if (gameOver && (key == 'r' || key == 'R')) restart();
    if (gameOver && (key == 'm' || key == 'M')) { commitScoreIfNeeded(); app.switchScreen(new ScreenMenu(app, res)); }
    if (key == 'p' || key == 'P') isPaused = !isPaused;
    if (!gameOver && (key == 'n' || key == 'N')) nextLevel();
  }

  void nextLevel() {
    currentLevelIndex++;
    if (currentLevelIndex >= levels.size()) endlessMode = true;
    else {
      currentLevel = levels.get(currentLevelIndex);
      ballsFiredThisLevel = 0;
      ballsRemaining = currentLevel.totalBalls;
      lives = 5;
      levelComplete = false;
    }
  }

  void restart() {
    int resetIndex = endlessMode ? 0 : currentLevel.id;
    setLevel(resetIndex);
    balls.clear();
    isPulsing = false;
    ballFired = false;
    activePipe = -1;
    pulseStartTime = millis() / 1000.0f;
    score = 0;
    lives = 5;
    gameOver = false;
    levelComplete = false;
    scoreSaved = false;
    difficultyTimer = 0;
    difficultyLevel = 1;
  }

  void drawUI() {
    fill(255);
    textSize(32);
    textAlign(LEFT, TOP);
    if (!endlessMode) {
      text(currentLevel.name, 30, 30);
      text("Balls Remaining: " + max(0, ballsRemaining), 30, 70);
    } else {
      text("Score: " + score, 30, 30);
    }
  }

  void drawHearts(PImage heart, int lives) {
    int heartGap = 70, totalHearts = 5;
    for (int i = 0; i < lives; i++) {
      int x = width / 2 - ((totalHearts - 1) * heartGap) / 2 + i * heartGap;
      image(heart, x, 970);
    }
  }

  void drawPauseButton() {
    float bx = width - 80, by = 60, bw = 15, bh = 40, gap = 25;
    noStroke();
    fill(255, 255, 255, 200);
    rectMode(CORNER);
    rect(bx, by, bw, bh, 5);
    rect(bx + gap, by, bw, bh, 5);
    rectMode(CENTER);
  }

  void drawPauseOverlay() {
    rectMode(CORNER);
    fill(0, 0, 0, 180);
    rect(0, 0, width, height);
    rectMode(CENTER);

    fill(0, 200, 255);
    textAlign(CENTER, CENTER);
    textSize(80);
    text("PAUSED", width / 2, height / 2 - 100);

    boolean overResume = resumeBtn.isMouseOver();
    boolean overRestart = restartBtn.isMouseOver();
    boolean overMenu = menuBtn.isMouseOver();
    cursor((overResume || overRestart || overMenu) ? HAND : ARROW);

    resumeBtn.draw(overResume);
    restartBtn.draw(overRestart);
    menuBtn.draw(overMenu);
  }

  void drawLevelComplete() {
    rectMode(CORNER);
    fill(0, 0, 0, 180);
    rect(0, 0, width, height);
    rectMode(CENTER);

    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(80);
    text("LEVEL COMPLETE", width / 2, height / 2 - 100);

    boolean overNext = nextLevelBtn.isMouseOver();
    boolean overMenu = menuBtn.isMouseOver();
    cursor((overNext || overMenu) ? HAND : ARROW);

    if (currentLevelIndex < 10) nextLevelBtn.draw(overNext);
    menuBtn.draw(overMenu);
  }

  void drawGameOver() {
    rectMode(CORNER);
    fill(0, 0, 0, 180);
    rect(0, 0, width, height);
    rectMode(CENTER);

    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(100);
    text("GAME OVER", width / 2, height / 2 - 150);

    fill(255);
    textSize(40);
    if (endlessMode) text("Final Score: " + score, width / 2, height / 2 - 80);
    else text("You reached " + currentLevel.name, width / 2, height / 2 - 80);

    boolean overRestart = restartBtn.isMouseOver();
    boolean overMenu = menuBtn.isMouseOver();
    cursor((overRestart || overMenu) ? HAND : ARROW);

    restartBtn.draw(overRestart);
    menuBtn.draw(overMenu);
  }
}
