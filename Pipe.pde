class Pipe {
  float x, y, pipeLength, pipeWidth, angle;
  PImage img;

  Pipe(float x, float y, PVector center, PImage img) {
    this.x = x;
    this.y = y;
    this.img = img;

    PVector dir = PVector.sub(center, new PVector(x, y)); // makes a vector to point to the center
    angle = atan2(dir.y, dir.x) + HALF_PI; // converts the vector to an angle and adds 90 degrees as default img position is vertical
    pipeLength = random(200, 400);
    pipeWidth  = random(350, 500);
  }

  // draws pipe angled towards the center
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    imageMode(CENTER);
    image(img, 0, 0, pipeWidth, pipeLength);
    popMatrix();
  }

  // Pulse animation
  void animatePulse(float elapsed, float duration) {
    float t = constrain(elapsed / duration, 0, 1);  // prvenets t from going out of the range 0 and 1
    float scale = 1.0f + 0.15f * sin(t * PI);  // makes the pipe expand and contract
    // transforms only the pipe
    pushMatrix();
    translate(x, y);
    rotate(angle);
    imageMode(CENTER);
    image(img, 0, 0, pipeWidth * scale, pipeLength * scale);
    popMatrix();
  }

  PVector getMouthPosition() {
    float offset = pipeLength * 0.5f;
    return new PVector(x + sin(angle) * offset, y - cos(angle) * offset);
  }
}
