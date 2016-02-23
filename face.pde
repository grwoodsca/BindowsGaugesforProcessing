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
  RadialRangeFace(){
    this(0,0,0,0,0,0,0);
  }
  void fillFacefromXML(XML rf){
    thickness=rf.getInt("sectionWidth",0);
    fillColour=tree.stringToColor(rf.getString("color","#0"));
    strokeColour=tree.stringToColor(rf.getString("stroke","#0"));
    strokeWeight=rf.getInt("strokeWidth",0);
    strokeDiameter=rf.getInt("radius",0);
    strokeStartAngle=rf.getInt("startValue",0);
    strokeEndAngle=rf.getInt("endValue",360);
  }
  void draw(RadialRange rr,RadialScale rs){
    int wid=rs.radius*thickness/100;
    int r=rs.radius*2-wid;
    strokeWeight(wid);
    noFill();
    stroke(fillColour);
    arc(rr.x,rr.y,r,r,radians(rr.startAngle)-PI/2,radians(rr.endAngle)-PI/2,OPEN);
    if (strokeWeight>0){      //draw the line for the ticks iff defined
      noFill();
      strokeWeight(strokeWeight);
      stroke(strokeColour);
      arc(rr.x,rr.y,strokeDiameter*2,strokeDiameter*2,radians(strokeStartAngle)-PI/2,radians(strokeEndAngle)-PI/2,OPEN);
    }
  }
}