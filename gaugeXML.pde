class GaugeXML{

  /* Class Constants */
  
  /* Class Variables */
  XML tree;
  int defaultOrigin;
  Gauge gauge;

  
  GaugeXML(){
  }

  Gauge loadFromXML(String filename){
    int coordWidth, coordHeight;
  // Load the XML tree
    try {
      tree=loadXML(filename);
    } catch (Exception e) {
      // the XML file could not be found.
      xmlEvent("The file doesn't exixt");
    }
    coordWidth=tree.getInt("coordWidth",100);
    coordHeight=tree.getInt("coordHeight",100);
    defaultOrigin=coordWidth;      //define a default center of origin based on overall coordinates of gauge
    if(coordHeight<defaultOrigin){defaultOrigin=coordHeight;}
    gauge=new Gauge(int(coordWidth),int(coordHeight));
    String [] children=tree.listChildren();
    for (int i = 0; i < children.length; i++){
      if (children[i].equals("Gauge2CircularBorder")){
        gauge.addBorder(fillBorder(tree.getChild(i)));
      }else if (children[i].equals("Gauge2RadialRange")){
        gauge.addRange(fillRange(tree.getChild(i)));
      }
    }
//    gauge.numNeedles=numneedles;
    return(gauge);
  }

  /* called automatically whenever an XML file is NOT loaded */
  void xmlEvent(String message) {
    println(message);
  }  // should call an exception
  
/* Border extraction method */

  RadialBorder fillBorder(XML rb){
    RadialBorder border;
    Boolean flag=false;
    int x,y,bHeight,bWidth,strokeWidth;
    String strokeColour;
    int diameter;
    x=rb.getInt("centerX",defaultOrigin);
    y=rb.getInt("centerY",defaultOrigin);
    bHeight=rb.getInt("height",defaultOrigin);
    bWidth=rb.getInt("width",defaultOrigin);
    strokeWidth=rb.getInt("strokeWidth",0);
    strokeColour=rb.getString("stroke","#0");
    if (bHeight>bWidth){
    diameter=bWidth; 
    }else{
    diameter=bHeight;  
    }
    border=new RadialBorder(int(x),int(y),diameter,int(strokeWidth),stringToColor(strokeColour));
    if (!rb.hasChildren()){xmlEvent("No colours for border");}
    for (int i=0; i<rb.listChildren().length; i++){
      if (rb.getChild(i).getName().equals("Gauge2CircularBorder.Filler")){
        border.setIsGradient(fillBorderColour(rb.getChild(i),border));
        flag=true;
        break;
      }
    }
    if (!flag){xmlEvent("Error in XML at Border ");}
    return(border);
  }

/* Filler extraction methods */

  Boolean fillBorderColour(XML filler, RadialBorder border){
    Boolean flag=false;
    if (!filler.hasChildren()){xmlEvent("Error in XML at .Filler");}
    for (int i=0; i<filler.listChildren().length; i++){
      if(filler.getChild(i).getName().equals ("Gauge2RingGradientFiller")){
        border.addColour(fillRadialGradient(filler.getChild(i)));
        border.addRing(fillRingGradient(filler.getChild(i)));
        flag=true;
      }else if (filler.getChild(i).getName().equals ("Gauge2PlainColorFiller")){
        border.addColour(fillPlainColour(filler.getChild(i)));
      }else if (filler.getChild(i).getName().equals ("Gauge2RadialGradientFiller")){
      border.addColour(fillRadialGradient(filler.getChild(i)));
      flag=true;
      } 
    }
    return (flag);
  }

  int[] fillPlainColour(XML filler){
    return(new int [] {stringToColor(filler.getString("color","#0"))});
  }

  int[] fillRadialGradient(XML filler){
    return(new int [] {stringToColor(filler.getString("color1","#0")),stringToColor(filler.getString("color2","#0"))});    
  }

  GradientRing fillRingGradient(XML filler){
    int xpos,ypos,thickness,hiliteCentre;
    xpos=filler.getInt("xpos",0);
    ypos=filler.getInt("ypos",0);
    thickness=filler.getInt("thickness",0);
    hiliteCentre=filler.getInt("highlightCenter",50); 
    return(new GradientRing(thickness,hiliteCentre,xpos,ypos));
  }
  int stringToColor(String c){
    return(0xFF000000+unhex(c.substring(1)));
  }
    
/* Range extraction method */

  RadialRange fillRange(XML rr){
    RadialRange range;
    int rwidth,rheight;
    float startAngle,endAngle;
    rwidth=rr.getInt("width",defaultOrigin);
    rheight=rr.getInt("height",defaultOrigin);
    startAngle=rr.getFloat("startAngle",0);
    endAngle=rr.getInt("endAngle",360);
    range=new RadialRange(rwidth/2,rheight/2,startAngle,endAngle);
    for (int i=0; i<rr.listChildren().length; i++){
      if (rr.getChild(i).getName().equals("Gauge2RadialScale")){
          range.addScale(fillScale(rr.getChild(i),range));
      }else if (rr.getChild(i).getName().equals("Gauge2RadialTicks")){
        range.addTicks(fillTicks(rr.getChild(i)));
      }else if (rr.getChild(i).getName().equals("Gauge2BasicCap")){
        range.addCap(fillCap(rr.getChild(i)));
      }      
    }
    return(range);
  }

/* scale extraction method */

  RadialScale fillScale(XML rs, RadialRange r){
    RadialScale scale;
    String textColour,font;
    int radius,startValue,endValue,labelCount;
    font=rs.getString("font","50 Verdana");
    textColour=rs.getString("foreColor","#0");
    radius=rs.getInt("radius",defaultOrigin);
    startValue=rs.getInt("startValue",0);
    endValue=rs.getInt("endValue",360);
    labelCount=rs.getInt("labelCount",0);
    scale=new RadialScale(radius, font, startValue, endValue, labelCount,stringToColor(textColour));
    if (rs.hasChildren()){
      if ( rs.getChild("Gauge2RadialScaleSection") != null){
        scale.addFace(fillFace(rs.getChild("Gauge2RadialScaleSection"))); 
      }else if (rs.getChild("Gauge2RadialArrowNeedle") != null){
        gauge.registerNeedle(gauge.numRanges,r.numScales,scale.numNeedles);   
        scale.addNeedle(fillNeedle(rs.getChild("Gauge2RadialArrowNeedle")));
      }
    }
    return(scale);
  }

/* scale face extraction method */
//     RadialRangeFace(int d, int t, color f, int w, color s){

  RadialRangeFace fillFace(XML rf){
    int faceWidth,strokeWidth,radius,startValue,endValue;
    String faceColour,strokeColour;
    faceWidth=rf.getInt("sectionWidth",0);
    faceColour=rf.getString("color","#0");
    strokeColour=rf.getString("stroke","#0");
    strokeWidth=rf.getInt("strokeWidth",0);
    radius=rf.getInt("radius",0);
    startValue=rf.getInt("startValue",0);
    endValue=rf.getInt("endValue",360);
    return( new RadialRangeFace(radius, faceWidth, stringToColor(faceColour), strokeWidth, stringToColor(strokeColour),startValue,endValue));  
  }

/* scale needle extraction method */
//    RadialNeedle(String i, color sc, int sw, int l, int ir, int or, int iw, int ow, int v){

  RadialNeedle fillNeedle(XML rn){
    RadialNeedle needle;
    int value,strokeWidth,nlength,innerRadius,outerRadius,innerWidth,outerWidth;
    String id,strokeColour;
    id=rn.getString("id","");
    value=rn.getInt("value",0);
    strokeColour=rn.getString("stroke","#0");
    strokeWidth=rn.getInt("strokeWidth",0);
    innerRadius=rn.getInt("innerRadius",0);
    innerWidth=rn.getInt("innerWidth",0);
    outerRadius=rn.getInt("outerRadius",defaultOrigin);
    outerWidth=rn.getInt("outerWidth",0);
    nlength=rn.getInt("pointerLength",(outerRadius-innerRadius)/3);
    needle=new RadialNeedle(id,stringToColor(strokeColour),strokeWidth,nlength,
           innerRadius,outerRadius,innerWidth,outerWidth,value);
    if (!rn.hasChildren()){xmlEvent("Error in XML; needle has no colour");}
    fillNeedleColour(rn,needle);
    return(needle);
  }
  
  void fillNeedleColour(XML rn, RadialNeedle n){
    for (int i=0; i<rn.listChildren().length; i++){
      if (rn.getChild(i).getName().equals("Gauge2RadialArrowNeedle.Filler")){
        n.setGradient(true);
        n.needleColour=fillRadialGradient(rn.getChild(i).getChild("Gauge2RadialGradientFiller"));
        break;
      }
    }
  }

/* radial tick extraction method */
//    RadialTicks(int r, int tl, int tw, int tc, color c){

  RadialTicks fillTicks(XML rt){
    int radius,tickCount,tickLength,tickWidth;
    String tickColour;
    radius=rt.getInt("radius",defaultOrigin);
    tickCount=rt.getInt("tickCount",0);
    tickLength=rt.getInt("tickLength",0);
    tickWidth=rt.getInt("tickWidth",0);
    tickColour=rt.getString("color","#0");
    return(new RadialTicks(radius,tickLength,tickWidth,tickCount,stringToColor(tickColour)));
  }

//  RadialCap(int d, int w, color s){

  RadialCap fillCap(XML rc){
    RadialCap cap;
    int diameter,strokeWidth,cWidth, cHeight;
    String strokeColour;
   Boolean flag=false;
    cWidth=rc.getInt("width",100);
    cHeight=rc.getInt("height",100);
    if (cWidth>cHeight){
    diameter=cHeight; 
    }else{
    diameter=cWidth;  
    }
    strokeWidth=rc.getInt("strokeWidth",0);
    strokeColour=rc.getString("stroke","#0");
    cap=new RadialCap(diameter,strokeWidth,stringToColor(strokeColour));
    if (!rc.hasChildren()){ xmlEvent("Error in XML Cap has no colour");}
    for (int i=0; i<rc.listChildren().length; i++){
      if (rc.getChild(i).getName().equals("Gauge2BasicCap.Filler")){
        cap.isGradient=true;
        cap.colour=fillRadialGradient(rc.getChild(i).getChild("Gauge2RingGradientFiller"));
        cap.ring=fillRingGradient(rc.getChild(i).getChild("Gauge2RingGradientFiller"));
        flag=true;
        break;
      }
    }
    if (!flag){ xmlEvent("Error in XML at Cap");}
    return(cap);   
  }
}