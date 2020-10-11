import processing.serial.*;

PImage imgSnake;
PImage imgApple;

int snakeX = 40;
int snakeY = 40;
int snakeSize = 40;

int textX = 400;
int textY = 40;

int appleX = 40 * int(random(1, 19));
int appleY = 40 * int(random(1, 14));
int appleSize = 40;

int counter = 0;

Serial s;

void setup()
{
  // Create window
  size(800, 600);

  // Stop automatic draw
  noLoop();

  imgSnake = loadImage("snake.jpg");
  imgApple = loadImage("apple.jpeg");

  // Serial
  s = new Serial(this, "COM7", 115200);
  s.buffer(4); // Buffer 2 bytes before calling serialEvent()
  //s.bufferUntil('\n'); // Buffer until '\n' is received before calling serialEvent()
}

void draw()
{
  // Background color
  background(40, 91, 225); 
  
  // Select line and fill color
  stroke(10, 200, 10); //Sides of the figures
  strokeWeight(1);
  fill(200, 100, 100);

  // Draw different shapes
  //triangle(18, 18, 18, 360, 81, 360);
  //rect(81, 81, 63, 63);
  //rect(91, 91, 43, 43, 7);
  //quad(189, 18, 216, 18, 250, 360, 144, 360);
  //ellipse(252, 144, 72, 72);
  //arc(479, 300, 280, 280, PI, TWO_PI);

  // Draw image
  image(imgSnake, snakeX, snakeY, snakeSize, snakeSize);
  image(imgApple, appleX, appleY, appleSize, appleSize);

  // Draw text
  fill(255);
  //text("(" + snakeX + "," + snakeY + ")", 4, 400);
  //text("(" + appleX + "," + appleY + ")", 4, 425);
  text("SCORE: " + counter, 700, 40);
  
  // Draw Arduino moving ball

  //stroke(255, 0, 0);
  //strokeWeight(4);
  //fill(150);
  //ellipse(ballX, ballY, 40, 40);
}

void keyPressed()
{
  
  if (key == CODED) {
    if (keyCode == UP) {
      s.write(2);
    } else if (keyCode == DOWN) {
      s.write(1);
    }else if (keyCode == LEFT) {
      s.write(3);
    }else if (keyCode == RIGHT) {
      s.write(4);
    }
  } else {
    switch (key)
    {
    case 'r' :
      s.write(0);
      counter = 0;
      break;
    case ' ' : //Press space button to start the game
      s.write(5);
      break;
    case 'a' :
      s.write(6);
      break;
    case 's' :
      s.write(7);
      break;
    }
  }
}

void serialEvent(Serial s)
{
  int byte1 = 0;
  int byte2 = 0;
  
  byte1 = s.read();
  byte2 = s.read();
  snakeX = byte1*256 + byte2;
  
  byte1 = 0;
  byte2 = 0;
  
  byte1 = s.read();
  byte2 = s.read();
  snakeY = byte1*256 + byte2;
  
  if (snakeX == appleX && snakeY == appleY){
    appleX = 40 * int(random(1, 19));
    appleY = 40 * int(random(1, 14));
    counter += 1;
  }
  if (snakeX > 800 || snakeY > 600){ // OUT OF LIMIT OR RESET
    appleX = 40 * int(random(1, 19));
    appleY = 40 * int(random(1, 14));
    counter = 0;
  }
  
  //println("snakeX: " + snakeX + ", snakeY: " + snakeY);
  
  redraw();
} 
