class RadialScale{

    int radius, textSize, textCount, startValue, endValue,sbk;
    String font;
    color textColour;
    ArrayList<RadialRangeFace> faces;
    ArrayList<RadialNeedle> needles;
    PFont f;
    RadialScale(int r, String fo, int sv, int ev, int tc, color c){
      font=fo;
      radius=r;
      textCount=tc;
      textColour=c;
      startValue=sv;
      endValue=ev;
      faces=new ArrayList<RadialRangeFace>();
      needles=new ArrayList<RadialNeedle>();
    }
    RadialScale(){
      this(0,"-",0,0,0,0);
    }
    
    void fillScalefromXML(XML rs){
      String fo=rs.getString("font","50 Verdana");
      textColour=tree.stringToColor(rs.getString("foreColor","#0"));
      radius=rs.getInt("radius",gauge.defaultOrigin);
      startValue=rs.getInt("startValue",0);
      endValue=rs.getInt("endValue",360);
      textCount=rs.getInt("labelCount",0);
      sbk=fo.indexOf(" ");    //first blank in string to separate the text size from font name
      textSize=int(fo.substring(0,sbk-1))*5; //Enlarge font size to convert between js and processing
      font=fo.substring(sbk+1);
      f = createFont(font,textSize);
    }


    /* Scale can be clockwise or counter-clockwise */    
    void drawScale(RadialRange rr){
      float angleInc=radians(rr.endAngle-rr.startAngle)/(textCount-1);
      int valueInc=(endValue-startValue)/(textCount-1);
      int value=startValue;
      fill(textColour);
      textAlign(CENTER);
      textFont(f,textSize);
      float angle=radians(rr.startAngle)-PI/2;  //Compass 0 is up; trig 0 is left
      for (int i=0; i<textCount; i++ ){
        float xorigin = rr.x + (cos(angle)* radius);
        float yorigin = rr.y + (sin(angle)* radius);
        pushMatrix();
        translate(xorigin,yorigin);
        rotate(angle+PI/2);  //0 deg in Trig maps to 90 deg on a compass
        text(value,0,0); // Prints current angle at origin;
        angle+=angleInc;
        value+=valueInc;
        popMatrix();
      }

    }

    void draw(RadialRange rr){
      for (RadialRangeFace face:faces){
        face.draw(rr,this);
      }
      for (RadialNeedle needle:needles){
        needle.draw(rr,this);
      }
      if(textCount>0){
        drawScale(rr);
      }
    }
    
    void addFace(RadialRangeFace rf){
      faces.add(rf);
    }
  
    void addNeedle(RadialNeedle rn){
      needles.add(rn);
    } 
  }