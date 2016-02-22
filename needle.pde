/* 
To Do - split into multiple sub classes of needle types
*/
  class RadialNeedle{
    static final int MAX_COLOURS=2;
    static final int STEPS=16;
    int value,lastValue,strokeColour,strokeWidth,nlength,innerRadius,outerRadius,innerWidth,outerWidth;
    String ID;
    Boolean isGradient;
    color [] colour;
    PShape needle;
    RadialNeedle(String i, color sc, int sw, int ir, int or, int iw, int ow, int v){
      ID=i;
      strokeColour=sc;
      strokeWidth=sw;
      innerRadius=ir;
      outerRadius=or;
      innerWidth=iw;
      outerWidth=ow;
      value=v;
      lastValue=v;
      colour=new color [MAX_COLOURS];
      isGradient=false;
//      needle=shapeNeedle();
    }
    int getValue(){
      return(value);
    }
    void setValue(int v){
      value=v;
    }
    String getID(){
      return(ID);
    }
    void fillColour(color [] c){
      colour=c;
    }
    void setGradient(Boolean f){
      isGradient=f;
    }
    PShape shapeNeedle(){
      int l=(outerRadius-innerRadius)/2; //Shape height from center
      int xwi=innerWidth/2;             // Shape width from center
      int xwo=outerWidth/2;            //ditto
      PShape n;
      n=createShape();
      n.beginShape();
      n.vertex(xwi,l);
      n.vertex(xwo,-l);
      n.vertex(-xwo,-l);
      n.vertex(-xwi,l);
      n.endShape(CLOSE);
      return(n);
    }
    
    void draw(RadialRange rr, RadialScale rs){
      needle=shapeNeedle();
      setShapeColour();
      float angle=radians(map(value,rs.startValue,rs.endValue,rr.startAngle,rr.endAngle))-PI/2; //Compass 0 is up not left
      float shapeHeight=outerRadius-innerRadius;
      float shapeRadius=innerRadius+shapeHeight/2;
      float xorigin = rr.x + (cos(angle)*shapeRadius);
      float yorigin = rr.y + (sin(angle)*shapeRadius);
      pushMatrix();
      translate(xorigin,yorigin);
      rotate(angle+PI/2);  // Corect rotation angle for a vertical shape
      shapeMode(CENTER);
      shape(needle,0,0);
      if(isGradient){fillGradient();}
      popMatrix();
    }
    void fillGradient(){
      PShape [] n= new PShape[STEPS];
      float inc=0.1;
      float shrink=0.99;
      for (int i=0;i<STEPS;i++){
        n[i]=new PShape();
        n[i]=shapeNeedle();
        n[i].scale(shrink);     //Shrink the shape slightly each time through;
        shrink-=inc;
        n[i].setStroke(colour[0]-(unhex("EF000000")));        //just want the fill portion of the shape
        n[i].setFill(colour[0]-(unhex("EF000000")));  //Set alpha to x010
        shape(n[i],0,0);
      }
    }
    void setShapeColour(){
      needle.setStroke(strokeColour);
      needle.setStrokeWeight(strokeWidth);
      needle.setFill(colour[1]);
    }

}
class RadialArrow extends RadialNeedle{
  int nlength;
  RadialArrow(String ID, color strokeColour, int strokeWidth, int innerRadius, int outerRadius, int innerWidth, int outerWidth, int value){
  super(ID,strokeColour,strokeWidth,innerRadius,outerRadius,innerWidth,outerWidth,value); 
  nlength=0;
  }
  void setNlength(int l){
    nlength=l;
  }
    /* Need to create the shape around the origin 
    so that shapeMode(CENTER) works correctly 
    Origin is top left; y goes down; x goes left */
  PShape shapeNeedle(){
    int l=(outerRadius-innerRadius)/2; //Shape height from center
    int lb=l-nlength;                 //Assumes that arrowhead is < 1/2 shape height
    int xwi=innerWidth/2;            // Shape width from center
    int xwo=outerWidth/2;           //ditto
    PShape n,shaft,head;
    shaft=createShape();
    shaft.beginShape();
    shaft.vertex(xwi,-lb);
    shaft.vertex(xwi,l);
    shaft.vertex(-xwi,l);
    shaft.vertex(-xwi,-lb);
    shaft.endShape(OPEN);
    head=createShape();
    head.beginShape();
    head.vertex(-xwi,-lb);
    head.vertex(xwo,-lb);
    head.vertex(0,-l);
    head.vertex(-xwo,-lb);
    head.vertex(xwi,-lb);
    head.endShape(OPEN);
    n=createShape(GROUP);      //Needle is made up of an triangular arrowhead and a rectangular shaft    
    n.addChild(head);
    n.addChild(shaft);
    return(n);
  }
  void setShapeColour(){
    needle.getChild("head").setStroke(strokeColour);
    needle.getChild("head").setStrokeWeight(strokeWidth);
    needle.getChild("head").setFill(colour[0]);
    needle.getChild("shaft").setStroke(strokeColour);
    needle.getChild("shaft").setStrokeWeight(strokeWidth);
    needle.getChild("shaft").setFill(colour[1]);
  }

 
}