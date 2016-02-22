class Label{
    int x,y,textSize;
    color textColour;
    String text, font,xAnchor,yAnchor;
    PFont f;    
    Label(int xpos, int ypos, String xA, String yA, int tc, String t, String fo){
      x=xpos;
      y=ypos;
      int sbk=fo.indexOf(" ");    //first blank in string to separate the text size from font name
      textSize=int(fo.substring(0,sbk-1))*5; //Enlarge font size to convert between js and processing
      font=fo.substring(sbk+1);
      f = createFont(font,textSize);
      textColour=tc;
      text=t;
      xAnchor=xA;
      yAnchor=yA;
/* need to convert js anchor text to processing align values
*/
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