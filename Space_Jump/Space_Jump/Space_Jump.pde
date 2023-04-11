float velocity = 0.07, gravity = 0.4;
float backgroundY;
int score;
int a=0; 

PImage [] galaxy = new PImage[30];
int dim = 500;
int frame = 0;
PImage galaxySheet;


boolean start;
boolean lvl1 = true;

//Platforms 
int platform_num = 20; //number of platforms
int gap = 80; //gap between platforms
Platform[] level1_platforms = new Platform[platform_num];
Platform[] level2_platforms = new Platform[platform_num];

//Player
Player player;
boolean left = false;
boolean right = false;
boolean noMove = true;
int playerStartX = 400, playerStartY = 595;
PImage rightImage;
PImage leftImage;
PImage currentDirection; 

//States
enum State {MENU, LEVEL1, LEVEL2, GAMEOVER};
State gameState;

//PFont font1; 
Button level1;
Button level2;
PImage bg1; 
PImage bg2; 
PImage menu_bg;

void setup() {
  size(650, 900);
  noStroke();
  bg1 = loadImage("spaceeE.png");
  bg2 = loadImage("light_sky.png");
  menu_bg = loadImage("menu_bg.png");
  rightImage = loadImage("rabbit.png");
  leftImage = loadImage("rabbitLeft.png");
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  
  gameState = State.MENU;
  player = new Player(playerStartX, playerStartY, leftImage, rightImage);
  
  level1 = new Button("Level 1", width/2, height/2-70, 330, 50);
  level2 = new Button("Level 2", width/2, height/2, 330, 50);
  
  galaxySheet = loadImage("short_loop.png");
  for (int i=0; i<galaxy.length; i++) {
    galaxy[i] = galaxySheet.get(i*dim, 0, dim, dim);
  }
  reset();                  
} 

void reset(){
  a=0; 
  start = false; 
  score = 0; 
  velocity = 0.07;
  backgroundY = -1450;
  player.setX(playerStartX);
  player.setY(playerStartY); 
  image(bg1,0, backgroundY);
  image(bg2,0, backgroundY);
   
  level1_platforms = resetPlatforms(level1_platforms);
  level2_platforms = resetPlatforms(level2_platforms);
}

Platform[] resetPlatforms(Platform[] platforms){
  Platform[] temp = new Platform[platform_num];
  platforms = temp;
  boolean spring = false; 
  boolean moving = false; 
  //float variance = random(1);
  
  for (int i = 0; i < platform_num; i++) {
    float ran = random(width-60); 
    //float variance = random(0.9, 1); 
    
    if (random(100) > 80) moving = true; 
    if (random(100) > 85) spring = true;
    platforms[i] = new Platform(ran+30, height-500 - i*gap, moving, spring);
    spring = false; moving = false;
  }
  return platforms;
}

void draw(){
  switch(gameState){
    case MENU:
      reset();
      image(menu_bg, 0, 0);
      frame = frameCount/6 % 30;
      //drawGalaxy(frame);
      image(galaxy[frame], 75, 420);
      level1.drawButton();
      level2.drawButton();
      if(mousePressed == true && level1.overButton()){
        gameState = State.LEVEL1;
        lvl1 = true; 
      } else if (mousePressed == true && level2.overButton()){
        gameState = State.LEVEL2;
        lvl1 = false; 
      }
      break;  

    case LEVEL1:
      image(bg1,0, -1750);
      player.drawPlayer();
      text("Score: "+ score, 20, 20, 100);
      for (Platform p : level1_platforms) { p.drawPlatform(); }
      if (start == false){ 
        text("Press Space to Start", width/2, height/2, 50);
        velocity = -20;
      } else if (start){
        update();
      }
      break;

    case LEVEL2:  
      image(bg2,0, -1750);
      player.drawPlayer();
      for (Platform p : level1_platforms) { p.drawPlatform(); }
      
      if (start == false){ 
        text("Press Space to Start", width/2, height/2, 50);
        velocity = -20;
      } else if (start){
        update();
      }
      break;  
      
    case GAMEOVER:
      reset();
      fill(255);
      text("You lose", 300, 400);
      text("Press R to restart and M for Menu", 300, 450);
      if (key == ' ' && lvl1){
        gameState = State.LEVEL1;
      } else if (key == ' ' && !lvl1){
        gameState = State.LEVEL2;
      } else if (key == 'm'){
        gameState = State.MENU;
      }
  }  
}

void update(){
  player.changeY(velocity);
  velocity+=gravity;
  println(velocity);
  
  //Screen Wrapping
  if (player.getX() < 0) player.setX(width);   // add this screen wrapping
  if (player.getX() > width)  player.setX(0);
  
  //Game Over if player goes below screen
  if (player.getY()+25 > height) gameState = State.GAMEOVER; // gameState = "GAMEOVER";  //If player falls too low then game-over
  
  //If player has reached certain height, shift platforms to give illusion of jumping
  if (player.getY() < 350){   // change to higher than 350 for up down affect 
   player.setY(350);
   //backgroundY -= velocity*2;
   println(backgroundY);
   for (Platform p : level1_platforms){
     p.adjustY(velocity);
   }
  }   
  
  //Checks if the bottom of the player hit the top of the platform
  for (int i=0; i<level1_platforms.length; i++){
    Platform p = level1_platforms[i];
    if ((player.getX()-15 < p.getX()+30) && (player.getX()+15 > p.getX()-30)
    && (player.getY()+(player.getH()/2) < p.getY()+7.5) && (player.getY()+(player.getH()/2) > p.getY()-7.5))
    {  
      if(!player.isJumping(velocity)){  //Prevents 'boosts'
        score = i*10; //Ch
        if (p.hasSpring()){
          velocity = -40; 
        } else {
          velocity = -12;
        }
      }    
    } 
  }

  // Move the x position of the sprite
  if (noMove== true) {
     player.changeX(0);
  } else if (right == true) {
    player.changeX(6);
  } else if (left == true) {
     player.changeX(-6);
  } 
}

void keyPressed() {
  if (key == 'd') //left
  {
    player.changeX(5);
    right = true;
    player.setIsLeft(false); 
    noMove = false;
    left = false;
  } else if (key == 'a') //right
  {
    player.changeX(-5);
    left = true;   
    player.setIsLeft(true); 
    noMove = false;
    right = false;
  }
  if (key == ' ') {
    start = true;
  }
}

void keyReleased(){
  if (key == 'd' && right == true){
    left = false;
    noMove = true;
  } else if (key == 'a' && left == true){
    noMove = true;
    right = false;
  }
}
