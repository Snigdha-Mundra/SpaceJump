float velocity = 0.07, gravity = 0.4;
float backgroundY;

boolean start, lvl1 = true;
int score, highscore = 0; 
int state = 0; 

//Platforms 
int platform_num1 = 200, platform_num2 = 500; //number of platforms
int gap = 80; //gap between platforms
Platform[] level1_platforms = new Platform[platform_num1];
Platform[] level2_platforms = new Platform[platform_num2];

//Player
Player player;
boolean left = false;
boolean right = false;
boolean noMove = true;
int playerStartX = 325, playerStartY = 565;
PImage rightImage, leftImage;
PImage currentDirection; 
PImage title;

//Menu and Backgrounds
PImage bg1, bg2; 
PImage menu_bg;
PImage stars, nebula, dust; 
Button level1;
Button level2;
Button choose; 
Button next;

//Galaxy Sprite
PImage [] galaxy = new PImage[30];
int dim = 500;
int frame = 0;
PImage galaxySheet;

//States
enum State {MENU, CHAR, LEVEL1, LEVEL2, GAMEOVER};
State gameState;

//Character Images
PImage cat, catLeft;
PImage pig, pigLeft; 
PImage bunny, bunnyLeft;
PImage displayed;

PFont buttonFont; //font

//------------------------------------------------------------------------------------------------------
 
void setup() {
  size(650, 900);
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  gameState = State.MENU;
  
  //Background Images 
  title = loadImage("SPACE JUMP.png");
  bg1 = loadImage("spaceeE.png");
  bg2 = loadImage("light_sky.png");
  menu_bg = loadImage("menu_bg.png");
  
  //Characters
  cat = loadImage("cat.png"); catLeft = loadImage("catLeft.png");
  pig = loadImage("pig.png"); pigLeft = loadImage("pigLeft.png");
  bunny = loadImage("bunny.png"); bunnyLeft = loadImage("bunnyLeft.png");
  rightImage = bunny;  leftImage = bunnyLeft;
  displayed = bunny; 
  player = new Player(playerStartX, playerStartY, rightImage, bunnyLeft);

  //Buttons
  level1 = new Button("Level 1", width/2-90, 300, 170, 50);
  level2 = new Button("Level 2", width/2+90, 300, 170, 50);
  choose = new Button("Choose Character", width/2, 360, 330, 50);
  next = new Button("NEXT", width/3+40, height/2-90, 120, 70);
  buttonFont = loadFont("general.vlw");
  textFont(buttonFont);
  
  //Galaxy Sprite
  galaxySheet = loadImage("short_loop.png");
  for (int i=0; i<galaxy.length; i++) {
    galaxy[i] = galaxySheet.get(i*dim, 0, dim, dim);
  }
  reset();                  
} 

//------------------------------------------------------------------------------------------------------

void draw(){
  switch(gameState){
    case MENU:
      image(menu_bg, 0, 0);
      image(title, 50, 90);
      frame = frameCount/6 % 30;
      image(galaxy[frame], 75, 400);
      
      fill(255);
      level1.drawButton();
      level2.drawButton();
      choose.drawButton();
      
      if(mousePressed == true && level1.overButton()){
        lvl1 = true; reset();
        gameState = State.LEVEL1;
      } else if (mousePressed == true && level2.overButton()){
        lvl1 = false; reset();
        gameState = State.LEVEL2;        
      } else if (mousePressed == true && choose.overButton()){
        gameState = State.CHAR;
        lvl1 = false; 
      }
      break;  
    
    case CHAR:
      image(bg1,0, -1750);
      strokeWeight(2); 
      stroke(230, 150, 190);
      fill(9, 21, 31);
      rect(width/2, height/2-120, 400, 300);
      noStroke();  fill(255);
      
      text("Choose your character ", width/2, height/2-190); 
      text("<--- Press Space to return to Menu", width/2, 70); 
      next.drawButton();
      
      //Swap the character display
      imageMode(CENTER);
      if (state==0){
        displayed = bunny;
        rightImage = bunny; leftImage = bunnyLeft;      
      } else if (state==1){
        displayed = pig;
        rightImage = pig; leftImage = pigLeft;
      } else if (state==2){
        displayed = cat;
        rightImage = cat; leftImage = catLeft;
      }
      if (displayed!=null) image(displayed, width*0.66-30, height/2-97);
      imageMode(CORNER);
      
      if (key == ' '){
        gameState = State.MENU; 
      }
       //space to return; 
      break;
    
    case LEVEL1:
      image(bg1,0, -1400);
      player.drawPlayer();
      for (Platform p : level1_platforms){ p.drawPlatform(); } //draw platforms
      fill(255);
      text("Score: "+ score, 80, 30);  // print score counter 
      
      //Screen is frozen until space is pressed
      if (start == false){ 
        text("Press Space to Start", width/2, height/2);
          text("Use 'A' and 'D' to move", width/2, height-165); 
        text("Avoid the red platforms!", width/2, height-120);
        velocity = -20;
      } else if (start){
        update(level1_platforms);
      }
      break;
      
    case LEVEL2:  
      image(bg2,0, -1400);
      player.drawPlayer();
      for (Platform p : level2_platforms){ p.drawPlatform(); }
      fill(0);
      text("Score: "+ score, 80, 30); // print score counter 
      
      //Screen is frozen until space is pressed
      if (start == false){ 
        text("Press Space to Start", width/2, height/2);
        text("Use 'A' and 'D' to move", width/2, height-165); 
        text("Avoid the pink platforms!", width/2, height-120);
        velocity = -20;
      } else if (start){
        update(level2_platforms);
      }
      break;  
     
    case GAMEOVER:
      //Which background to use for gameover screen
      if (lvl1) image(bg1,0, -1400);
      if (!lvl1) image(bg2,0, -1400);
      
      fill(58, 82, 105); 
      rect(width/2, height/2, 500, 300);
      
      fill(255); 
      image(displayed, width/2 - displayed.width/2, 350);
      text("Press R to Restart and M for Menu", width/2, 550);
      
      if(score >= highscore){
        highscore = score; 
        text("New High-Score : "+score, width/2, 500);
      } else {
        text("Score : "+score, width/2, 500);
      }
      
      if (key == 'r' && lvl1){
        reset();
        gameState = State.LEVEL1;
      } else if (key == 'r' && !lvl1){
        reset();
        gameState = State.LEVEL2;
      } else if (key == 'm'){
        gameState = State.MENU;
      }
  }  
}

//------------------------------------------------------------------------------------------------------

void update(Platform[] platforms){
  player.changeY(velocity);
  velocity+=gravity;
  
  //Screen Wrapping
  if (player.getX() < 0) player.setX(width);   // add this screen wrapping
  if (player.getX() > width) player.setX(0);
  
  //Game Over if player goes below screen
  if (player.getY()+25 > height) gameState = State.GAMEOVER; // gameState = "GAMEOVER";  //If player falls too low then game-over
  
  //If player has reached certain height, shift platforms to give illusion of jumping
  if (player.getY() < 350){   // change to higher than 350 for up down affect 
   player.setY(350);
   //backgroundY -= velocity*2;
   println(backgroundY);
   for (Platform p : platforms){
     p.adjustY(velocity);
   }
  }   
  
  for (int i=0; i<platforms.length; i++){
    Platform p = platforms[i];
    if(p.getY() > height) score = i*10; //count score using number of platforms that have passed the screen.
    if(platforms[platforms.length-8].getY() > height) text("YOU WIN", width/2, 300);
    
    //Checks if the bottom of the player hit the top of the platform
    if ((player.getX()-15 < p.getX()+30) && (player.getX()+15 > p.getX()-30)
    && (player.getY()+(player.getH()/2) < p.getY()+7.5) && (player.getY()+(player.getH()/2) > p.getY()-7.5))
    {  
      if(!player.isJumping(velocity)){  //Prevents 'boosts'
        if (p.hasSpring()){
          velocity = -25; 
        } else if (p.hasSpikes()){ 
          gameState = State.GAMEOVER;
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

//------------------------------------------------------------------------------------------------------

void reset(){ 
  velocity = 0.07;
  backgroundY = -1450;
  start = false; score = 0; 
  player.setX(playerStartX);
  player.setY(playerStartY); 
  image(bg1,0, backgroundY);
  image(bg2,0, backgroundY);
  player.setCharacter(leftImage, rightImage);
 
  //Reset and generate level platforms 
  level1_platforms = resetPlatforms(level1_platforms, 15, 17, 5, true);
  level2_platforms = resetPlatforms(level1_platforms, 85, 40, 25, false);
}

Platform[] resetPlatforms(Platform[] platforms, float m, float spr, float spi, boolean lvl1){
  
  Platform[] temp = new Platform[platforms.length];
  platforms = temp;
  for (int i = 0; i<platforms.length; i++) {
    float ran = random(width-60);  
    platforms[i] = new Platform(ran+30, height-500 - i*gap, m, spr, spi, lvl1); //<>//
  }
  return platforms;
}

//mouse and key listeners
//------------------------------------------------------------------------------------------------------

void mouseClicked(){
  if(next.overButton()){
    if(state==0 || state==1){
      state++;
    } else if (state==2){
      state = 0; 
    }
  }
}

void keyPressed() {
  if (key == 'd'){    //left
    player.changeX(5);
    right = true;
    player.setIsLeft(false); 
    noMove = false;
    left = false;
  }
  else if (key == 'a'){  //right
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
