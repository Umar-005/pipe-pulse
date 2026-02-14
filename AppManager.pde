class AppManager {
  Database db;
  ResourceManager res;
  Screen currentScreen;
  String currentUser;
  

  AppManager() {
    db = new Database(); // creates / gets database
    res = new ResourceManager();      // Load all assets 
    currentScreen = new ScreenLoginMenu(this, res);  // Sets the starting screen to login menu
  }
  
  
  // sets all event handlers to the current screens event handlers

  void update() {
    if (currentScreen != null)
      currentScreen.update();
  }

  void draw() {
    if (currentScreen != null)
      currentScreen.draw();
  }

  void mousePressed() {
    if (currentScreen != null)
      currentScreen.handleMousePressed();
  }

  void keyPressed() {
    if (currentScreen != null)
      currentScreen.handleKeyPressed();
  }
  void keyTyped() {
      if (currentScreen != null)
      currentScreen.handleKeyTyped();
  
  }

  void switchScreen(Screen newScreen) {
    currentScreen = newScreen;
  }
  
}
