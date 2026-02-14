class Level {
  int id;
  String name;
  float minBallSpeed;
  float maxBallSpeed;
  int totalBalls;
  float pulseInterval;

  Level(int id, String name, float minBallSpeed, float maxBallSpeed, int totalBalls,float pulseInterval) {
    this.id = id;
    this.name = name;
    this.minBallSpeed = minBallSpeed;
    this.maxBallSpeed = maxBallSpeed;
    this.totalBalls = totalBalls;
    this.pulseInterval = pulseInterval;
  }
}
