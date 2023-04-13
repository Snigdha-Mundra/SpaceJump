class Platform {
  float x, y; 
  float originalX; 
  float height; 
  float width; 
  boolean moveLeft; 
  boolean lvl1; 

  boolean moving = false; 
  boolean spring = false; 
  boolean spikes = false; 
  
  color a1, a2, a3;   
  
  color c1 = color(211, 190, 195);
  color c2 = color(247, 153, 168); 
  color c3 = color(230, 71, 71);
  
  color b1 = color(21, 70, 77);
  color b2 = color(47, 132, 143);
  color b3 = color(219, 92, 121);
  
  Platform(){}

  Platform(float x, float y, float m, float spr, float spi, boolean lvl1){
    this.x = x;
    this.y = y;
    this.height = 15;
    this.width = 60;
    this.originalX = x; 
    this.lvl1 = lvl1; 
    
    setColors();
    if (random(100) < m) this.moving = true; 
    if (random(100) < spr) this.spring = true;
    if (random(100) < spi) this.spikes = true; 
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
    return spring; 
  }
  
  boolean hasSpikes(){
    return spikes; 
  }
  
  void setMoving(){
    if(this.originalX > width-200){
      moving = false; 
    }
  }
  
  void setColors(){
    if(lvl1){
      a1=c1; a2=c2; a3=c3; 
    } else {
      a1=b1; a2=b2; a3=b3;
    }
  }
  
  void drawPlatform(){
    if(spring){
      fill(a2); 
    } else if (spikes){
      fill(a3);
    }else{
      fill(a1);
    }
    
    rect(this.x, this.y, this.width, this.height);
    if (moving){
      moveRect();
    }
  }

  void moveRect(){
    if(x <= originalX-130 || x-30 <= 0){
      moveLeft=false;
    }
    if(x >= originalX + 130 ||  x+30 >= 650){
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
