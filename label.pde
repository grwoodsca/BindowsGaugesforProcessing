class Label{
    int x,y,textSize;
    color textColour;
    String text, font,xAnchor,yAnchor;
    PFont f;    
    Label(int xpos, int ypos, String xA, String yA, int tc, String t, String fo){
      x=xpos;
      y=ypos;
      textColour=tc;
      text=t;
/* need to convert js anchor text to processing align values
*/
      xAnchor=xA;
      yAnchor=yA;
      font=fo;
    }

    Label(){
      this(0,0,"-","-",0,"-","-");
    }

    void fillLabelfromXML(XML l){
      textColour=tree.stringToColor(l.getString("foreColor","#0"));
      xAnchor=l.getString("anchorHorizontal","center");
      yAnchor=l.getString("anchorVertical","center");
      x=l.getInt("x",gauge.defaultOrigin);
      y=l.getInt("y",gauge.defaultOrigin);
      text=l.getString("text","-");
      String fo=l.getString("font","50 Verdana");
      int sbk=fo.indexOf(" ");    //first blank in string to separate the text size from font name
      textSize=int(fo.substring(0,sbk-1))*5; //Enlarge font size to convert between js and processing
      font=fo.substring(sbk+1);
      f = createFont(font,textSize);
    }

    void draw(){
      pushMatrix();
      translate(x,y);
      fill(textColour);
      textAlign(CENTER);
      textFont(f,textSize);
      text(text,0,0); // Prints current angle at origin;
      popMatrix();      
    }
}