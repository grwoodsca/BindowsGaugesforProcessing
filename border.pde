/* Should split into 2 classes RadialBorder and Ring
*/
class RadialBorder{
  
  int x,y,diameter,strokeWeight;
  color strokeColour;
  color [] colour;
  GradientRing ring;
  Boolean isGradient;

 RadialBorder(int xpos, int ypos, int d, int w, color s){
    x=xpos;
    y=ypos;
    diameter=d;
    strokeWeight=w;
    strokeColour=s;
    colour=new color[0x0];
    ring=new GradientRing();   
  }    
  RadialBorder(int xpos, int ypos) {
    this(xpos,ypos,xpos*2,0,0);
  }

  RadialBorder() {
    this(0,0,0,0,0);
  }

  void fillBorderfromXML(XML rb){
    int bHeight,bWidth;
    x=rb.getInt("centerX",gauge.defaultOrigin/2);
    y=rb.getInt("centerY",gauge.defaultOrigin/2);
    bHeight=rb.getInt("height",gauge.defaultOrigin);
    bWidth=rb.getInt("width",gauge.defaultOrigin);
    strokeWeight=rb.getInt("strokeWidth",0);
    strokeColour=tree.stringToColor(rb.getString("stroke","#0"));
    if (bHeight>bWidth){
    diameter=bWidth; 
    }else{
    diameter=bHeight;  
    }
  }

  void borderEvent(String message) {
    println(message);
    exit();
  }
  void draw(){
    if(isGradient){
      ring.draw(this);
    }else{
      drawCircle();
    }
  }

  void drawCircle() {
    noStroke();
    if (strokeWeight>0){      //draw the edge of the circle iff defined
      strokeWeight(strokeWeight);
      stroke(strokeColour);
    }
    fill(colour[0]);
    ellipse(x,y,diameter,diameter);
  }
  
  void setStrokeColour( color c){
   strokeColour=c;; 
  }
  void setDiameter( int d){
    diameter=d; 
  }
  void setStrokeWeight( int w){
    strokeWeight=w; 
  }
  void addColour(color[] c){
    colour=c;
  }
  void addRing (GradientRing r){
    ring=r;
  }
  void setIsGradient(Boolean f){
    isGradient=f;
  }
  void setCentre(int xpos, int ypos){
    x=xpos;
    y=ypos;
  }
}