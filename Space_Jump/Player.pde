class Player {
  float x, y; 
  float height; 
  float width; 
  PImage imageLeft;
  PImage imageRight;
  boolean facingLeft; 
  
  
  Player(){}
  
  Player(int x, int y, PImage imageLeft, PImage imageRight) {
    this.x = x;
    this.y = y;
    this.imageLeft = imageLeft;
    this.imageRight = imageRight;
    this.width = imageLeft.width;
    this.height = imageLeft.height;
    facingLeft = false;
  }
  
  float getX(){
    return x; 
  }
  
  float getY(){
    return y; 
  }
  
  float getW(){
    return width; 
  }
  
  float getH(){
    return height; 
  }
  
  void setX(float xPos){
    x = xPos; 
  }
   
  void setY(float yPos){
    y = yPos; 
  }
  
   void changeY(float yPos){
    y += yPos; 
  }
  
  void changeX(float xPos){
    x += xPos; 
  }
  
  void setCharacter(PImage imageLeft, PImage imageRight){
    this.imageLeft = imageLeft; 
    this.imageRight = imageRight; 
  }
  
  boolean isJumping(float velocity){
    if (velocity < 1){   /////////// CHANGE THIS VALUE
      return true; 
    } else {
      return false; 
    }
  }
  
  void  setIsLeft(boolean left){
     this.facingLeft = left; 
  }
  
  void drawPlayer() {
    fill(100, 255, 100);
    imageMode(CENTER);
    if (facingLeft){
      image(imageLeft, this.x, this.y, this.width, this.height);
    } else {
      image(imageRight, this.x, this.y, this.width, this.height);
    }
    
    imageMode(CORNER);
  }
}
