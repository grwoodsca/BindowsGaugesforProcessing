/*
This is just a border without the x and y coordinates so make it a subclass of border
*/
  class RadialCap {
  RadialBorder border;
  RadialCap(int d, int w, color s,RadialRange rr){
    border=new RadialBorder(rr.x,rr.y,d,w,s);
  }    
  void draw(){
      border.draw();
  }
  RadialBorder getBorder(){
    return (border);
  }
  void setBorder(RadialBorder b){
    border=b;
  }
  
}