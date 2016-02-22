class GradientRing{
  static final int STEPS=16;
    
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
  void draw(RadialBorder b){
    int wid=b.diameter*hiliteWidth/100;
    int r=b.diameter-wid;
    int w=wid/STEPS;
    int rinc=2*wid*(hiliteCentre-50)/100/STEPS; //need to calculate where to put highlight centre
    noStroke();
    if (b.strokeWeight>0){      //draw the edge of the circle iff defined
      strokeWeight(b.strokeWeight);
      stroke(b.strokeColour);
    }
    noFill();
    ellipse(b.x,b.y,b.diameter,b.diameter);
    pushMatrix();
    strokeWeight(wid);
    noFill();
    stroke(b.colour[0]);
    ellipse(b.x,b.y,r,r);  //Convert radius into diameter
    stroke(b.colour[1]-(unhex("EF000000"))); //Set alpha to x010
    translate(b.ring.xshift,b.ring.yshift);
    for (int i=0; i<STEPS; i++){
      strokeWeight(wid);
      wid-=w;
      ellipse(b.x,b.y,r,r); //Convert radius into diameter
      r+=rinc;
    }
    popMatrix();  
  }
}