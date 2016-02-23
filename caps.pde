/*
This is just a border without the x and y coordinates so make it a subclass of border
*/
  class RadialCap {
  RadialBorder border;
  RadialCap(int d, int w, color s,int x,int y){
    border=new RadialBorder(x,y,d,w,s);
  }
  RadialCap(){
    this(0,0,0,0,0);
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
  void fillCapfromXML(XML rc,int x, int y){
    border.fillBorderfromXML(rc);
    border.setCentre(x,y);   //x & y were set in the parent node
  }
}