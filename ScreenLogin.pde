class ScreenLogin extends Screen {
  InputField usernameField;
  InputField passwordField;
  ShowButton showButton;
  Button loginButton;
  Button backButton;

  boolean showPassword = false;
  boolean usernameWrong = false;

  ScreenLogin(AppManager app, ResourceManager res) {
    super(app, res);

    float centerX = width / 2;

    usernameField = new InputField(centerX, 300, 280, 50, "Username");
    passwordField = new InputField(centerX, 400, 280, 50, "Password");
    showButton    = new ShowButton(res, centerX + 200, 400, 100, 40);
    loginButton   = new Button(res, centerX, 500, "Login");
    backButton    = new Button(res, centerX, 600, "Back");

    usernameField.setActive(true);   //  Auto focus username on open
  }

  void draw() {
    background(res.background);

    fill(255);
    textFont(res.mainFont);
    textSize(80);
    textAlign(CENTER, CENTER);
    text("Login", width/2, 130);

    usernameField.draw();
    String displayedPass = showPassword 
      ? passwordField.text 
      : passwordField.text.replaceAll(".", "*");
    passwordField.draw(displayedPass);

    showButton.draw(showPassword);

    boolean overShow = showButton.isMouseOver();
    boolean overLogin = loginButton.isMouseOver();
    boolean overBack = backButton.isMouseOver();
    cursor((overShow || overLogin || overBack) ? HAND : ARROW);
    
    loginButton.draw(overLogin);
    backButton.draw(overBack);

    if (usernameWrong) {
      fill(255, 0, 0);
      textSize(40);
      text("Username or password is incorrect!", width/2, 700);
    }
  }

  void handleMousePressed() {
    usernameField.setActive(usernameField.isMouseOver());
    passwordField.setActive(passwordField.isMouseOver());

    if (showButton.isMouseOver()) showPassword = !showPassword;

    if (loginButton.isMouseOver()) attemptLogin(); 

    if (backButton.isMouseOver()) {
      usernameField.clear();
      passwordField.clear();
      app.switchScreen(new ScreenLoginMenu(app, res));
    }
  }

  // key input
  void handleKeyTyped() {
    if (usernameField.active) usernameField.handleKeyTyped(key);
    else if (passwordField.active) passwordField.handleKeyTyped(key);
  }

  void handleKeyPressed() {
    //  When Enter is pressed, auto move to next step
    if (keyCode == ENTER) {
      if (usernameField.active) {
        usernameField.setActive(false);
        passwordField.setActive(true);
      } else if (passwordField.active) {
        attemptLogin();
      }
    }
  }

  void attemptLogin() {
  String username = trim(usernameField.text);
  String password = passwordField.text;
  usernameWrong = false;

  if (app.db.checkLogin(username, password)) {
    app.currentUser = username;
    usernameField.clear();
    passwordField.clear();
    app.switchScreen(new ScreenMenu(app, res));
  } else {

    usernameWrong = true;
    usernameField.clear();
    passwordField.clear();
    passwordField.setActive(false);
    usernameField.setActive(true);
  }
}


  void update() {
  
  }
}
