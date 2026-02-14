class ResourceManager {
  
  PImage background;
  PImage core;
  PImage pipe;
  PImage heart;
  PImage baseBall;
  PImage heartBall;
  PImage decoyBall;
  PImage deathBall;
  PImage powerBall;
  PImage lockIcon;
  PImage logo;

  PFont mainFont;
  PFont buttonFont;

  ResourceManager() {
    loadImages();
    loadFonts();
  }
  void loadImages() {
    background = loadImage("Assets/Images/background.png");
    core = loadImage("Assets/Images/core.png");
    pipe = loadImage("Assets/Images/pipe.png");
    heart = loadImage("Assets/Images/heart.png");
    baseBall = loadImage("Assets/Images/baseBall.png");
    heartBall = loadImage("Assets/Images/heartBall.png");
    decoyBall = loadImage("Assets/Images/decoyBall.png");
    deathBall = loadImage("Assets/Images/deathBall.png");
    powerBall = loadImage("Assets/Images/powerBall.png");
    lockIcon = loadImage("Assets/Images/lock.png");
    logo = loadImage("Assets/Images/logo.png");
  }
  void loadFonts() {
    mainFont = createFont("Assets/Fonts/Orbitron-VariableFont_wght.ttf", 48);
    buttonFont = createFont("Assets/Fonts/Rajdhani-Regular.ttf", 32);
  }

}
