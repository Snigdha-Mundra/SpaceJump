class Button {
  String text;
  float x, y; 
  float height; 
  float width; 
  boolean pressed;
  
  Button(){}
  
  Button(String text, int x, int y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.text = text; 
    pressed = false;
  }
  
  float getX(){
    return x; 
  }
  
  float getY(){
    return y; 
  }
  
  void drawButton(){
   if (this.overButton()) {
     fill(153, 138, 181); 
   } else {
     fill(205, 187, 240);
   }
   rect(x, y, width, height); 
   fill(0);
   text(text, x, y);
  }
  
  boolean overButton(){
    if (mouseX >= x-width/2 && mouseX <= x+width/2 && 
        mouseY >= y-height/2 && mouseY <= y+height/2) {
      return true; 
    } else {
      return false; 
    }
  }
}
