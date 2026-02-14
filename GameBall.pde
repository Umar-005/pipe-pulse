abstract class Ball {
  float x, y, size, speed;
  PVector dir;
  PImage img;
  PImage core;
  Level level;
  int livesLeft;
  
  Ball(float x, float y, PVector dir, float size, Level level, PImage img, PImage core, int livesLeft) {
    this.x = x;
    this.y = y;
    this.dir = dir.copy();
    this.size = size;
    this.level = level;
    this.img = img;
    this.core = core;
    this.speed = random(level.minBallSpeed, level.maxBallSpeed);
    this.livesLeft = livesLeft;
  }

  void display() {
    imageMode(CENTER);
    image(img, x, y, size * 1.5f, size * 1.5f);
  }
  
  // detects if ball is ofscreen
  boolean offScreen() {
    return (x < -size || x > width + size || y < -size || y > height + size);
  }

  // detects if ball is in the core
  boolean inCore() {
    return dist(x, y, width / 2, height / 2) < core.width * 0.25f;
  }

  // detects if the ball has been clicked
  boolean clicked(float mx, float my) {
    return dist(mx, my, x, y) < size / 2;
  }

  abstract void update();  // handles ball speed and direction
  abstract int livesAfterCoreHit(int currentLives);
  abstract int livesAfterClicked(int currentLives);
}

class BaseBall extends Ball {
  BaseBall(float x, float y, PVector dir, float size, Level level, PImage img, PImage core, int livesLeft) {
    super(x, y, dir, size, level, img, core, livesLeft);
  }
  void update() {
    x += dir.x * speed;
    y += dir.y * speed;
  }
  int livesAfterCoreHit(int currentLives) { return currentLives - 1; }
  int livesAfterClicked(int currentLives) { return currentLives; }
}

class HeartBall extends Ball {
  HeartBall(float x, float y, PVector dir, float size, Level level, PImage img, PImage core, int livesLeft) {
    super(x, y, dir, size, level, img, core, livesLeft);
  }
  void update() {
    x += dir.x * speed;
    y += dir.y * speed;
  }
  int livesAfterCoreHit(int currentLives) { return currentLives - 1; }
  int livesAfterClicked(int currentLives) {
    if (currentLives < 5) return currentLives + 1;
    return currentLives;
  }
}

class DecoyBall extends Ball {
  DecoyBall(float x, float y, PVector dir, float size, Level level, PImage img, PImage core, int livesLeft) {
    super(x, y, dir, size, level, img, core, livesLeft);
  }
  void update() {
    x += dir.x * speed;
    y += dir.y * speed;
  }
  int livesAfterCoreHit(int currentLives) { return currentLives; }
  int livesAfterClicked(int currentLives) { return currentLives; }
}


class DeathBall extends Ball {
  DeathBall(float x, float y, PVector dir, float size, Level level, PImage img, PImage core, int livesLeft) {
    super(x, y, dir, size, level, img, core, livesLeft);
  }
  void update() {
    x += dir.x * speed * 0.5f;
    y += dir.y * speed * 0.5f;
  }
  int livesAfterCoreHit(int currentLives) { return 0; } // instant death
  int livesAfterClicked(int currentLives) { return currentLives; }
}


class PowerBall extends Ball {
  PowerBall(float x, float y, PVector dir, float size, Level level, PImage img, PImage core, int livesLeft) {
    super(x, y, dir, size, level, img, core, livesLeft);
  }
  void update() {
    x += dir.x * speed * 0.5f;
    y += dir.y * speed * 0.5f;
  }
  int livesAfterCoreHit(int currentLives) { return currentLives; }
  int livesAfterClicked(int currentLives) {return currentLives;}
}
