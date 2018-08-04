class TextBox {
  String textValue = new String();
  int x,y,w,h;
  int maxLen;
  static final int lineH = 15;
  

 
      
  TextBox(int x,int y,int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    maxLen = h/lineH;
    redraw();
  }
  
  void setText(String text){
    textValue = text;
  }
  
  void redraw(){
    fill(0, 0, 0);
    rect(x,y,w,h);
    fill(200, 200, 200);
    //textAlign(LEFT, BOTTOM);
    text(textValue.replaceAll("(.{60})", "$1\n"), x,y+lineH,w,1000);
    
  }
  
}