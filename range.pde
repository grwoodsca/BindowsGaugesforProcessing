class RadialRange{

  static final int MAX_SCALES=5;
  static final int MAX_TICKS=10;
  static final int MAX_CAPS=5;
 
/* Center and shape*/
  int x,y;
  float startAngle,endAngle;
//  int MaxRadius;

/* arrays of included objects Should convert to ArrayLists*/ 
  RadialScale[] scales;
  int numScales;
  RadialTicks[] ticks;
  int numTicks;
  RadialCap[] caps;
  int numCaps;
  
  RadialRange(int xpos, int ypos, float s, float e){
    x=xpos;
    y=ypos;
    startAngle=s;
    endAngle=e;
    scales=new RadialScale[MAX_SCALES];
    numScales=0;
    ticks=new RadialTicks[MAX_TICKS];
    numTicks=0;
    caps=new RadialCap[MAX_CAPS];
    numCaps=0;
  }
  void rangeEvent(String message) {
    println(message);
    exit();
  }

  void addScale(RadialScale rs){
    if (numScales >= MAX_SCALES){rangeEvent("Too many scales");}
    scales[numScales++]=rs;
  }


  void addTicks(RadialTicks rs){
    if (numTicks >= MAX_TICKS){rangeEvent("Too many ticks");}
    ticks[numTicks++]=rs;
  }

  void addCap(RadialCap rs){
  if (numCaps >= MAX_CAPS){rangeEvent("Too many caps");}
    caps[numCaps++]=rs;
  }
  void draw(){
    for (int i=0;i<numScales;i++){
      scales[i].draw(this);
    }
    for (int i=0;i<numTicks;i++){
      ticks[i].draw(this);
    }    
    for (int i=0;i<numCaps;i++){
      caps[i].draw(this);
    }    
  }
}

class RadialScale{
  static final int MAX_FACES=5;
  static final int MAX_NEEDLES=5;

    int radius, textSize, textCount, startValue, endValue,sbk;
    String font;
    color textColour;
    RadialRangeFace[] faces;
    int numFaces;
    RadialNeedle[] needles;
    int numNeedles;
    PFont f;
    RadialScale(int r, String fo, int sv, int ev, int tc, color c){
      radius=r;
      sbk=fo.indexOf(" ");
      textSize=int(fo.substring(0,sbk-1))*5;
      font=fo.substring(sbk+1);
      textCount=tc;
      textColour=c;
      startValue=sv;
      endValue=ev;
      f = createFont(font,textSize);
      faces=new RadialRangeFace[MAX_FACES];
      numFaces=0;
      needles=new RadialNeedle[MAX_NEEDLES];
      numNeedles=0;
    }
  void scaleEvent(String message) {
    println(message);
    exit();
  }
    
    void drawScale(RadialRange rr){
      float angleInc=radians(rr.endAngle-rr.startAngle)/(textCount-1);
      int valueInc=(endValue-startValue)/(textCount-1);
      int value=startValue;
      fill(textColour);
      textAlign(CENTER);
      textFont(f,textSize);
      for (float angle=radians(rr.startAngle)-PI/2; angle < radians(rr.endAngle)-PI/2; angle+=angleInc){  //
          float xorigin = rr.x + (cos(angle)* radius);
          float yorigin = rr.y + (sin(angle)* radius);
          pushMatrix();
          translate(xorigin,yorigin);
          rotate(angle+PI/2);  //0 deg in Trig maps to 90 deg on a compass
          text(value,0,0); // Prints current angle at origin;
          value+=valueInc;
          popMatrix();
      }

    }
    void draw(RadialRange rr){
      for (int i=0;i<numFaces;i++){
        faces[i].draw(rr,this);
      }
      for (int i=0;i<numNeedles;i++){
        needles[i].draw(rr,this);
      }
      if(textCount>0){
        drawScale(rr);
      }
    }
    
    void addFace(RadialRangeFace rs){
      if (numFaces >= MAX_FACES){scaleEvent("Too many faces");}
      faces[numFaces++]=rs;
    }
  
    void addNeedle(RadialNeedle rs){
      if (numNeedles >= MAX_NEEDLES){scaleEvent("Too many needles");}
      needles[numNeedles++]=rs;
    }
 
  }

class RadialRangeFace{                        //draws an arc
  int strokeDiameter, thickness,strokeWeight,strokeStartAngle,strokeEndAngle;
  color fillColour,strokeColour;
  RadialRangeFace(int d, int t, color f, int w, color s,int sv,int se){
  fillColour=f;
  thickness=t;
  strokeWeight=w;
  strokeColour=s;
  strokeDiameter=d;
  strokeStartAngle=sv;
  strokeEndAngle=se;
  }
  void draw(RadialRange rr,RadialScale rs){
    int wid=rs.radius*thickness/100;
    int r=rs.radius*2-wid;
    strokeWeight(wid);
    noFill();
    stroke(fillColour);
  //println("face",wid,r,hex(fillColour));
    arc(rr.x,rr.y,r,r,radians(rr.startAngle)-PI/2,radians(rr.endAngle)-PI/2,OPEN);
    if (strokeWeight>0){      //draw the line for the ticks iff defined
      noFill();
      strokeWeight(strokeWeight);
      stroke(strokeColour);
      arc(rr.x,rr.y,strokeDiameter*2,strokeDiameter*2,radians(strokeStartAngle)-PI/2,radians(strokeEndAngle)-PI/2,OPEN);
    }
  }
}

  class RadialTicks {
    int radius, tickLen,tickWeight,tickCount;
    color tickColour;
    RadialTicks( int r, int tl, int tw, int tc, color c){
    radius=r;
    tickLen=tl;
    tickWeight=tw;
    tickCount=tc;
    tickColour=c;
    }
    void draw(RadialRange rr){
      float angleInt=radians(rr.endAngle-rr.startAngle)/(tickCount-1);
      stroke(tickColour);
      strokeWeight(tickWeight);
      int r=radius-tickLen/2;
      int xTop=-tickLen/2;
      int xBottom=tickLen/2;
      for (float angle=radians(rr.startAngle)-PI/2; angle < radians(rr.endAngle)-PI/2; angle+=angleInt){  //
          pushMatrix();
          float xorigin = rr.x + (cos(angle)* r);
          float yorigin = rr.y + (sin(angle)* r);
          translate(xorigin,yorigin);
          rotate(angle);
          line(xTop,0,xBottom,0);  // tick is placed at the new origin; 0 deg in Trig maps to 90 deg on a compass
          popMatrix();
      }
    }
  }

  class RadialNeedle{
    static final int MAX_COLOURS=5;
    int needleValue,needleStartValue,needleEndValue,needleLastValue,needleStrokeColour,needleStrokeWidth,needleLength,needleInnerRadius,needleOuterRadius,needleInnerWidth,needleOuterWidth;
    String needleID;
    Boolean needleIsGradient;
    color [] needleColour;
    PShape needle,arrow,stem;
    RadialNeedle(String i, color sc, int sw, int l, int ir, int or, int iw, int ow, int v){
      needleID=i;
      needleStrokeColour=sc;
      needleStrokeWidth=sw;
      needleLength=l;
      needleInnerRadius=ir;
      needleOuterRadius=or;
      needleInnerWidth=iw;
      needleOuterWidth=ow;
      needleValue=v;
      needleLastValue=v;
      needleColour=new color [MAX_COLOURS];
      needleIsGradient=false;
      shapeNeedle();  //need fill colours before shape can be built
    }
    int getValue(){
      return(needleValue);
    }
    int getStartValue(){
      return(needleStartValue);
    }
    int getEndValue(){
      return(needleEndValue);
    }
    void setValue(int v){
      needleValue=v;
    }
    String getID(){
      return(needleID);
    }
    void fillColour(color [] c){
      needleColour=c;
    }
    void setGradient(Boolean f){
      needleIsGradient=f;
    }
    void shapeNeedle(){
/* Need to create the shape around the origin so that shapeMode(CENTER) works correctly */
      int l=(needleOuterRadius-needleInnerRadius)/2; //Shape height from center
      int lb=l-needleLength; //Assumes that needleLength is < 1/2 shape height
      int xwi=needleInnerWidth/2; // Shape width fromcenter
      int xwo=needleOuterWidth/2; //ditto
      needle=createShape(GROUP);    //shape seems to be upside down
      arrow=createShape();
      arrow.beginShape();
      arrow.vertex(xwi,-lb);
      arrow.vertex(xwi,l);
      arrow.vertex(-xwi,l);
      arrow.vertex(-xwi,-lb);
      arrow.endShape(OPEN);
      stem=createShape();
      stem.beginShape();
      stem.vertex(-xwi,-lb);
      stem.vertex(xwo,-lb);
      stem.vertex(0,-l);
      stem.vertex(-xwo,-lb);
      stem.vertex(xwi,-lb);
      stem.endShape(OPEN);
      needle.addChild(arrow);
      needle.addChild(stem);
  }
    
    void draw(RadialRange rr, RadialScale rs){
      arrow.setStroke(needleStrokeColour);
      arrow.setStrokeWeight(needleStrokeWidth);
      arrow.setFill(needleColour[0]);
      stem.setStroke(needleStrokeColour);
      stem.setStrokeWeight(needleStrokeWidth);
      stem.setFill(needleColour[1]);
      float angle=radians(map(needleValue,rs.startValue,rs.endValue,rr.startAngle,rr.endAngle))-PI/2; //Compass 0 is up not left
      float shapeHeight=needleOuterRadius-needleInnerRadius;
      float shapeRadius=needleInnerRadius+shapeHeight/2;
      float xorigin = rr.x + (cos(angle)*shapeRadius);
      float yorigin = rr.y + (sin(angle)*shapeRadius);
      pushMatrix();
      translate(xorigin,yorigin);
      rotate(angle+PI/2);  // Corect rotation angle for a vertical shape
      shapeMode(CENTER);
      shape(needle,0,0); 
      popMatrix();
    }
  }
  class RadialCap {
  static final int STEPS=16;
  int diameter,strokeWeight;
  color strokeColour;
  color [] colour;
  Boolean isGradient;
  GradientRing ring;
  RadialCap(int d, int w, color s){
    diameter=d;
    strokeWeight=w;
    strokeColour=s;
    colour=new color [2];  //Need to use static variable
    isGradient=false;
    ring=new GradientRing();   
  }    
  void draw(RadialRange rr){
    if(isGradient){
      drawRing(rr);
    }else{
      drawCircle(rr);
    }
  }
  void drawCircle(RadialRange rr) {
    noStroke();
    if (strokeWeight>0){      //draw the edge of the circle iff defined
      strokeWeight(strokeWeight);
      stroke(strokeColour);
    }
    fill(colour[0]);
    arc(rr.x,rr.y,diameter,diameter,radians(rr.startAngle)-PI/2,radians(rr.endAngle)-PI/2,OPEN);
  }
    void addColour(color[] c){
    colour=c;
  }
  void drawRing(RadialRange rr){
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
    ellipse(rr.x,rr.y,diameter,diameter);
    pushMatrix();
    strokeWeight(wid);
    noFill();
    stroke(colour[0]);
    ellipse(rr.x,rr.y,r,r);  //Convert radius into diameter
    stroke(colour[1]-(unhex("EF000000"))); //Set alpha to x010
    translate(ring.xshift,ring.yshift);
    for (int i=0; i<STEPS; i++){
      strokeWeight(wid);
      wid-=w;
      ellipse(rr.x,rr.y,r,r); //Convert radius into diameter
      r+=rinc;
    }
    popMatrix();  
  }
}