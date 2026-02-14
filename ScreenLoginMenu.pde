class ScreenLoginMenu extends Screen {
  Button loginBtn;
  Button signupBtn;

  ScreenLoginMenu(AppManager app, ResourceManager res) {
    super(app, res);

    // Position buttons relative to screen size
    float logoY = res.logo.height / 2 + 50;
    float startY = logoY + res.logo.height / 2 + 50;

    loginBtn = new Button(res, width / 2, startY, "Login");
    signupBtn = new Button(res, width / 2, startY + 120, "Sign Up");
  }

  void update() {
  }

  void draw() {
    drawBackground();

    // Draw logo
    float logoY = res.logo.height / 2 + 50;
    imageMode(CENTER);
    image(res.logo, width / 2, logoY);

    // Update cursor
    boolean hoverLogin = loginBtn.isMouseOver();
    boolean hoverSignup = signupBtn.isMouseOver();
    cursor((hoverLogin || hoverSignup) ? HAND : ARROW);

    // Draw buttons
    loginBtn.draw(hoverLogin);
    signupBtn.draw(hoverSignup);
  }

  void handleMousePressed() {
    if (loginBtn.isMouseOver()) {
      app.switchScreen(new ScreenLogin(app, res)); // navigate to Login
    }
    if (signupBtn.isMouseOver()) {
      app.switchScreen(new ScreenSignUp(app, res)); // navigate to Signup
    }
  }

  void handleKeyPressed() {}
  void handleKeyTyped(){}
}
