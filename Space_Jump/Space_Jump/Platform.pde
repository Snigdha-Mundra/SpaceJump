class Platform {
  float x, y; 
  float originalX; 
  float height; 
  float width; 
  boolean moving; 
  boolean hasSpring; 
  boolean moveLeft;  
  
  Platform(){}

  Platform(float x, float y, boolean moving, boolean hasSpring){
    this.x = x;
    this.y = y;
    this.height = 15;
    this.width = 60;
    this.moving = moving; 
    this.originalX = x; 
    this.hasSpring = hasSpring; 
  }
    
  void adjustY(float yPos){
    y -= yPos; 
  }
  
  float getX(){
    return x; 
  }
  
  float getY(){
    return y; 
  }
  
  float getWidth(){
    return width;
  }
  
  boolean isMoving(){
    return moving;
  }
  
  boolean hasSpring(){
    return hasSpring; 
  }
  
  void setMoving(){
    if(this.originalX > width-200){
      moving = false; 
    }
  }
  
  void drawPlatform(){
    if(hasSpring){
      fill(255, 150, 230); 
    } else {
      fill(230, 230, 230);
    }
    
    rect(this.x, this.y, this.width, this.height);
    if (moving){
      moveRect();
    }
  }

  void moveRect(){
    if(x <= originalX-100 || x-30 <= 0){
      moveLeft=false;
    }
    if(x >= originalX + 100 ||  x+30 >= 650){
      moveLeft=true;
    }
    if(moveLeft==false){
      x+=1;
    }
    if(moveLeft==true){
      x-=1;
    }
  }

  boolean alreadyExist(float newX, float newY){
    if (newX >= x-width/2 && newX <= x+width/2 && 
        newY >= y-height/2 && newY <= y+height/2) {
          return true;
    } else {
      return false; 
    }
  }
}
