class RadialBorder{
  static final int STEPS=16;
  
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
    this(xpos,ypos,xpos,0,0);
  }

  void borderEvent(String message) {
    println(message);
    exit();
  }
  void draw(){
    if(isGradient){
      drawRing();
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

  void drawRing(){
    int wid=diameter*ring.hiliteWidth/100;
    int r=diameter-wid;
    int w=wid/STEPS;
    int rinc=2*wid*(ring.hiliteCentre-50)/100/STEPS; //need to calculate where to put highlight centre
    noStroke();
    if (strokeWeight>0){      //draw the edge of the circle iff defined
      strokeWeight(strokeWeight);
      stroke(strokeColour);
    }
    noFill();
    ellipse(x,y,diameter,diameter);
    pushMatrix();
    strokeWeight(wid);
    noFill();
    stroke(colour[0]);
    ellipse(x,y,r,r);
    stroke(colour[1]-(unhex("EF000000"))); //Set alpha to x010
    translate(ring.xshift,ring.yshift);
    for (int i=0; i<STEPS; i++){
      strokeWeight(wid);
      wid-=w;
      ellipse(x,y,r,r);
      r+=rinc;
    }
    popMatrix();  
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
}

class GradientRing{
  int hiliteWidth,hiliteCentre,xshift,yshift;
  GradientRing(int t, int c, int xs, int ys){
    hiliteWidth=t;
    hiliteCentre=c;
    xshift=xs;
    yshift=ys;
  }
  GradientRing(){
    this(0,0,0,0);
  }
  
}