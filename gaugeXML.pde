class GaugeXML{
  /* Class Variables */
  XML file;
  Table webColours;
  Gauge gauge;
  
/* nothing to construct for the XML load class
*/
  GaugeXML(){
  }
  
/* Method to populate the gauge from an XML file
*/
  Gauge loadFromXML(String filename){
  // Load the XML tree
    try {
      file=loadXML(filename);
    } catch (Exception e) {
      // the XML file could not be found.
      xmlEvent("The gauge file doesn't exist");
    }
  // Load the webColours table from file
    try{
      webColours=loadTable(dataPath("color_codes.csv"),"header");
    } catch (Exception e) {
      // the XML file could not be found.
      xmlEvent("Colours file doesn't exist");
    }
/* gauge extraction method */
    gauge= new Gauge();
    gauge.fillGaugefromXML(file);
    String [] children=file.listChildren();
    for (int i = 0; i < children.length; i++){
      if (children[i].equals("Gauge2CircularBorder")){
        gauge.addBorder(fillBorder(file.getChild(i)));
      }else if (children[i].equals("Gauge2RadialRange")){
        gauge.addRange(fillRange(file.getChild(i)));
      }else if (children[i].equals("Gauge2Label")){
        gauge.addLabel(fillLabel(file.getChild(i)));
      }
    }
    return(gauge);
  }

  /* called  whenever a file is NOT loaded */
  void xmlEvent(String message) {
    println(message);
  }  // should call an exception
  
/* Border extraction method */
  RadialBorder fillBorder(XML rb){
    RadialBorder border=new RadialBorder();
    border.fillBorderfromXML(rb);
    Boolean flag=false;
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

    
/* Range extraction method */
  RadialRange fillRange(XML rr){    
    RadialRange range=new RadialRange();
    range.fillRangefromXML(rr);
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
    RadialScale scale=new RadialScale();
    scale.fillScalefromXML(rs);
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
  RadialRangeFace fillFace(XML rf){
    RadialRangeFace face=new RadialRangeFace();
    face.fillFacefromXML(rf);
    return(face);  
  }

/* needle extraction method */
  RadialNeedle fillNeedle(XML rn){
    RadialNeedle needle=new RadialNeedle();
    needle.fillNeedlefromXML(rn);
    fillNeedleColour(rn,needle);
    return(needle);
  }

  RadialNeedle fillArrow(XML rn){    
    RadialArrow arrow= new RadialArrow();
    arrow.fillNeedlefromXML(rn);
    fillNeedleColour(rn,arrow);
    return(arrow);
  }


/* radial tick extraction method */
  RadialTicks fillTicks(XML rt){
    RadialTicks ticks =new RadialTicks();
    ticks.fillTicksfromXML(rt);
    return(ticks);
  }

/* label extraction method */
  Label fillLabel(XML l){
    Label label=new Label();
    label.fillLabelfromXML(l);
    return(label);    
  }

/* radial cap extraction method */
  RadialCap fillCap(XML rc,RadialRange rr){
    RadialCap cap=new RadialCap();
    cap.fillCapfromXML(rc,rr.x,rr.y);
    if (!rc.hasChildren()){ xmlEvent("Error in XML Cap has no colour");}
     String [] children=rc.listChildren();
     Boolean flag=false;
     for (int i = 0; i < children.length; i++){
     if (children[i].equals("Gauge2BasicCap.Filler")){
       cap.border.setIsGradient(fillBorderColour(rc.getChild(i),cap.border));
       flag=true;
       break;
     }
    }
    if (!flag){ xmlEvent("Error in XML at Cap");}
    return(cap);   
  }


/* Filler extraction methods
   These should be a separate class containing filler colour and hilite details
*/

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

    void fillNeedleColour(XML rn, RadialNeedle n){
    if (!rn.hasChildren()){xmlEvent("Error in XML; needle has no colour");}
    String [] children=rn.listChildren();
    for (int i = 0; i < children.length; i++){
      if (children[i].equals("Gauge2RadialNeedle.Filler")){
        XML filler=rn.getChild(i);
        String [] fillChildren=filler.listChildren();  
        for (int j = 0; j < fillChildren.length; j++){
          if(fillChildren[i].equals ("Gauge2RingGradientFiller")){
            n.colour=(fillRadialGradient(filler.getChild(i)));
            n.isGradient=true;
            break;
          }else if (fillChildren[i].equals ("Gauge2PlainColorFiller")){
            n.colour=(fillPlainColour(filler.getChild(i)));
            n.isGradient=false;        
            break;
          }else if (fillChildren[i].equals ("Gauge2RadialGradientFiller")){
            n.colour=(fillRadialGradient(filler.getChild(i)));
            n.isGradient=true;
            break;
          }
        }
      }
    }
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

}