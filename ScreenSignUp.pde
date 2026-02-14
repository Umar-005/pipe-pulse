class ScreenSignUp extends Screen {
  InputField usernameField;
  InputField passwordField;
  InputField confirmPasswordField;
  ShowButton showButton;
  Button signUpButton;
  Button backButton;

  boolean showPassword = false;
  boolean usernameShort = false;
  boolean usernameExists = false;
  boolean usernameInvalid = false;
  boolean passwordsDontMatch = false;

  final int MIN_USERNAME_LEN = 3;
  final int MIN_PASSWORD_LEN = 3;

  ScreenSignUp(AppManager app, ResourceManager res) {
    super(app, res);
    float centerX = width / 2;

    usernameField = new InputField(centerX, 300, 280, 50, "Username");
    passwordField = new InputField(centerX, 400, 280, 50, "Password");
    confirmPasswordField = new InputField(centerX, 500, 280, 50, "Confirm Password");

    showButton = new ShowButton(res, centerX + 200, 400, 100, 40);
    signUpButton = new Button(res, centerX, 600, "Sign Up");
    backButton = new Button(res, centerX, 700, "Back");

    usernameField.setActive(true); // Auto focus username field
  }

  void update() {
  
  }

  void draw() {
    drawBackground();

    fill(255);
    textFont(res.mainFont);
    textSize(80);
    textAlign(CENTER, CENTER);
    text("Sign Up", width / 2, 130);

    // Input fields
    usernameField.draw();
    String passDisplay = showPassword ? passwordField.text : passwordField.text.replaceAll(".", "*");
    String confirmDisplay = showPassword ? confirmPasswordField.text : confirmPasswordField.text.replaceAll(".", "*");
    passwordField.draw(passDisplay);
    confirmPasswordField.draw(confirmDisplay);

    //Buttons
    showButton.draw(showPassword);
    signUpButton.draw(signUpButton.isMouseOver());
    backButton.draw(backButton.isMouseOver());
    cursor((showButton.isMouseOver() || signUpButton.isMouseOver() || backButton.isMouseOver()) ? HAND : ARROW);

    // Error messages
    fill(255, 0, 0);
    textSize(40);
    if (usernameShort) text("Username or password is too short!", width / 2, 800);
    if (usernameInvalid) text("Username can only contain letters, numbers, or _", width / 2, 800);
    if (passwordsDontMatch) text("Passwords do not match!", width / 2, 800);
    if (usernameExists) text("Username already exists!", width / 2, 800);
  }

  void handleMousePressed() {
    usernameField.setActive(usernameField.isMouseOver());
    passwordField.setActive(passwordField.isMouseOver());
    confirmPasswordField.setActive(confirmPasswordField.isMouseOver());

    if (showButton.isMouseOver()) showPassword = !showPassword;
    if (signUpButton.isMouseOver()) attemptSignUp();

    if (backButton.isMouseOver()) {
      clearTextErrors();
      app.switchScreen(new ScreenLoginMenu(app, res));
      clearInputFields();
    }
  }

  void handleKeyTyped() {
    if (usernameField.active) usernameField.handleKeyTyped(key);
    else if (passwordField.active) passwordField.handleKeyTyped(key);
    else if (confirmPasswordField.active) confirmPasswordField.handleKeyTyped(key);
  }

  void handleKeyPressed() {
    if (keyCode == ENTER) {
      // Move focus or attempt signup
      if (usernameField.active) {
        usernameField.setActive(false);
        passwordField.setActive(true);
      } 
      else if (passwordField.active) {
        passwordField.setActive(false);
        confirmPasswordField.setActive(true);
      } 
      else if (confirmPasswordField.active) {
        attemptSignUp();
      }
    }
  }

  void attemptSignUp() {
    clearTextErrors();
    String username = trim(usernameField.text);
    String password = passwordField.text;
    String confirm = confirmPasswordField.text;

    if (username.length() < MIN_USERNAME_LEN || password.length() < MIN_PASSWORD_LEN) {
      usernameShort = true;
    } else if (!password.equals(confirm)) {
      passwordsDontMatch = true;
    } else if (!username.matches("[A-Za-z0-9_]+")) {
      usernameInvalid = true;
    } else if (app.db.addUser(username, password)) {
      app.currentUser = username;
      clearInputFields();
      app.switchScreen(new ScreenMenu(app, res));
      return;
    } else {
      usernameExists = true;
    }


    passwordField.clear();
    confirmPasswordField.clear();
    usernameField.clear();
    usernameField.setActive(true);
    passwordField.setActive(false);
    confirmPasswordField.setActive(false);
  }

  void clearTextErrors() {
    usernameShort = false;
    usernameExists = false;
    usernameInvalid = false;
    passwordsDontMatch = false;
  }

  void clearInputFields() {
    usernameField.clear();
    passwordField.clear();
    confirmPasswordField.clear();
  }
}
