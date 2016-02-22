class GaugeXML{

  /* Class Constants */
  
  /* Class Variables */
  XML tree;
  Table webColours;
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
      xmlEvent("The gauge file doesn't exist");
    }
  // Load the webColours table from file
    try{
//      webColours=loadTable("Data/john/Documents/Images/Guage_xml/color_codes.csv","header");
      webColours=loadTable(dataPath("color_codes.csv"),"header");
    } catch (Exception e) {
      // the XML file could not be found.
      xmlEvent("Colours file doesn't exist");
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
      }else if (children[i].equals("Gauge2Label")){
        gauge.addLabel(fillLabel(tree.getChild(i)));
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
    String [] children=rb.listChildren();
    for (int i = 0; i < children.length; i++){
      if (children[i].equals("Gauge2CircularBorder.Filler")){
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
    String [] children=filler.listChildren();
    for (int i = 0; i < children.length; i++){
      if(children[i].equals ("Gauge2RingGradientFiller")){
        border.addColour(fillRadialGradient(filler.getChild(i)));
        border.addRing(fillRingGradient(filler.getChild(i)));
        flag=true;
      }else if (children[i].equals ("Gauge2PlainColorFiller")){
        border.addColour(fillPlainColour(filler.getChild(i)));
      }else if (children[i].equals ("Gauge2RadialGradientFiller")){
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
    if (!c.substring(0,0).equals("#")){
//      Boolean f=false;
      for (TableRow row : webColours.rows()){
        if (c.equals(row.getString(0))){
          c=row.getString(1);
//          f=true;
          break;
        }
      }
    }
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
    String [] children=rr.listChildren();
    for (int i = 0; i < children.length; i++){
      if (children[i].equals("Gauge2RadialScale")){
          range.addScale(fillScale(rr.getChild(i),range));
      }else if (children[i].equals("Gauge2RadialTicks")){
        range.addTicks(fillTicks(rr.getChild(i)));
      }else if (children[i].equals("Gauge2BasicCap")){
        range.addCap(fillCap(rr.getChild(i),range));
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
      String [] children=rs.listChildren();
      for (int i = 0; i < children.length; i++){
        if ( children[i].equals("Gauge2RadialScaleSection")){
         scale.addFace(fillFace(rs.getChild(i))); 
        }else if (children[i].equals("Gauge2RadialArrowNeedle")){
          gauge.registerNeedle(gauge.ranges.size(),r.scales.size(),scale.needles.size());   
          scale.addNeedle(fillArrow(rs.getChild(i)));
        }else if (children[i].equals("Gauge2RadialNeedle")){
         gauge.registerNeedle(gauge.ranges.size(),r.scales.size(),scale.needles.size());  
         scale.addNeedle(fillNeedle(rs.getChild(i)));
        }
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
    int value,strokeWidth,innerRadius,outerRadius,innerWidth,outerWidth;
    String id,strokeColour;
    id=rn.getString("id","");
    value=rn.getInt("value",0);
    strokeColour=rn.getString("stroke","#0");
    strokeWidth=rn.getInt("strokeWidth",0);
    innerRadius=rn.getInt("innerRadius",0);
    innerWidth=rn.getInt("innerWidth",0);
    outerRadius=rn.getInt("outerRadius",defaultOrigin);
    outerWidth=rn.getInt("outerWidth",0);
    needle=new RadialNeedle(id,stringToColor(strokeColour),strokeWidth,
           innerRadius,outerRadius,innerWidth,outerWidth,value);
    if (!rn.hasChildren()){xmlEvent("Error in XML; needle has no colour");}
    String [] children=rn.listChildren();
    for (int i = 0; i < children.length; i++){
      if (children[i].equals("Gauge2RadialNeedle.Filler")){
        fillNeedleColour(rn.getChild(i),needle);
        break;
      }
    }
    return(needle);
  }

    RadialNeedle fillArrow(XML rn){
    RadialNeedle needle=fillNeedle(rn);
    int nlength=rn.getInt("pointerLength",(needle.outerRadius-needle.innerRadius)/3);
    needle.setNlength(nlength);
    return(needle);
  }

  void fillNeedleColour(XML rn, RadialNeedle n){
    String [] children=rn.listChildren();
    for (int i = 0; i < children.length; i++){
      if(children[i].equals ("Gauge2RingGradientFiller")){
        n.colour=(fillRadialGradient(rn.getChild(i)));
        n.isGradient=true;
        break;
      }else if (children[i].equals ("Gauge2PlainColorFiller")){
        n.colour=(fillPlainColour(rn.getChild(i)));
        n.isGradient=false;        
        break;
      }else if (children[i].equals ("Gauge2RadialGradientFiller")){
        n.colour=(fillRadialGradient(rn.getChild(i)));
        n.isGradient=true;
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

  RadialCap fillCap(XML rc,RadialRange rr){
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
    cap=new RadialCap(diameter,strokeWidth,stringToColor(strokeColour),rr);
    if (!rc.hasChildren()){ xmlEvent("Error in XML Cap has no colour");}
      String [] children=rc.listChildren();
      for (int i = 0; i < children.length; i++){
      if (children[i].equals("Gauge2BasicCap.Filler")){
        cap.getBorder().isGradient=true;
        cap.getBorder().colour=fillRadialGradient(rc.getChild(i).getChild("Gauge2RingGradientFiller"));
        cap.getBorder().ring=fillRingGradient(rc.getChild(i).getChild("Gauge2RingGradientFiller"));
        flag=true;
        break;
      }
    }
    if (!flag){ xmlEvent("Error in XML at Cap");}
    return(cap);   
  }
  Label fillLabel(XML l){
    String font,xA,yA,text,textColour;
    int x,y;    
    font=l.getString("font","50 Verdana");
    textColour=l.getString("foreColor","#0");
    xA=l.getString("anchorHorizontal","center");
    yA=l.getString("anchorVertical","center");
    x=l.getInt("x",defaultOrigin);
    y=l.getInt("y",defaultOrigin);
    text=l.getString("text","-");
    return( new Label(x,y,xA,yA,stringToColor(textColour),text,font));    
  }
}