class Gauge{
/* Class Constants */
  static final int MAX_BORDERS=10;
  static final int MAX_RANGES=10;
  static final int MAX_NEEDLES=10;
  
/* Class object arrays */
   RadialBorder [] borders;
  int numBorders;
   RadialRange [] ranges;
  int numRanges;
  NeedlePointer [] needles;  //Saves range indices containing needles
  int numNeedles;
  
/* Class Variables */
  int gWidth,gHeight;

  Gauge(int Gw, int Gh, RadialBorder[] rb, RadialRange[] rr,NeedlePointer[] rn){
    gWidth=Gw;
    gHeight=Gh;
    borders= rb;
    ranges= rr;
    needles=rn;
    numBorders=0;
    numRanges=0;
    numNeedles=0;
  }
  Gauge(int gWidth, int gHeight){
    this(gWidth, gHeight, new RadialBorder[MAX_BORDERS], new RadialRange[MAX_RANGES],new NeedlePointer[MAX_NEEDLES]);
  }
  Gauge(){
   this(width/2, height/2, new RadialBorder[MAX_BORDERS], new RadialRange[MAX_RANGES],new NeedlePointer[MAX_NEEDLES]);
  }

  void gaugeEvent(String message){
    println(message);
    exit();
  }
  void addBorders(RadialBorder[] rb){
    borders= rb;    
  }
  RadialBorder getborder(int i){ //need error check for out of range index
    if (i >= numBorders){gaugeEvent("Index out of range");}
    return (borders[i]);
  }
  void addBorder(RadialBorder rb){
    if (numBorders >= MAX_BORDERS){gaugeEvent("Too many borders");}
    borders[numBorders++]=rb;
  }
  void setBorder(RadialBorder rb, int i){
    if (i >= MAX_BORDERS){gaugeEvent("Index out of range");}
    borders[i]=rb;
  }
  void addRanges(RadialRange[] rr){
    ranges= rr;
  }
    RadialRange getRange(int i){
      if (i >= numRanges){gaugeEvent("Index out of range");}
      return (ranges[i]);
  }
    void addRange(RadialRange rr){
      if (numRanges >= MAX_BORDERS){gaugeEvent("Too many ranges");}
println("gauge range added",numRanges);
      ranges[numRanges++]=rr;
  }
    void setRange(RadialRange rr, int i){
      if (i >= MAX_RANGES){gaugeEvent("Index out of range");}
      ranges[i]=rr;
  }
  int getNumNeedles(){
    return(numNeedles);
  }
  void setNeedleValue(String ID,int value){  
    Boolean found=false;
    RadialNeedle needle;
    for (int i=0; i<needles.length;i++){
      needle=ranges[needles[i].rindex].scales[needles[i].sindex].needles[needles[i].nindex];
      if (needle.getID().equals(ID)){
        needle.setValue(value);
        found=true;
        break;
      }
    }
    if (! found){gaugeEvent("Needle not found");}
  }
  int getNeedleValue(String ID){  
    RadialNeedle needle;
    int value=0;
    Boolean found=false;
    for (int i=0; i<needles.length;i++){
      needle=ranges[needles[i].rindex].scales[needles[i].sindex].needles[needles[i].nindex];
      if (needle.getID().equals(ID)){
        value=needle.getValue();
        found = true;
        break;
      }
    }
    if (!found){gaugeEvent("Needle not found");}
    return (value);
  }
  void draw(){
    for (int i=0;i<numBorders;i++){
      borders[i].draw();
    }
    for (int i=0;i<numRanges;i++){
      ranges[i].draw();
    }    
  }
  void drawBorders(){
    for (int i=0;i<numBorders;i++){
      borders[i].draw();
    }
  }
  void drawRanges(){
    for (int i=0;i<numRanges;i++){
      ranges[i].draw();
    }    
  }

  void registerNeedle(int r, int s, int n){
      if (numNeedles >= MAX_NEEDLES){gaugeEvent("Too many Needles");}
      needles[numNeedles++]=new NeedlePointer(r,s,n);
  }
}

class NeedlePointer{
  int rindex,sindex,nindex;

  NeedlePointer(int r, int s, int n){
    rindex=r;
    sindex=s;
    nindex=n;
  }
}

  