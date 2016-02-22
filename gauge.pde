class Gauge{
/* Class Constants */
 
/* Class object arrays */
  ArrayList<RadialBorder> borders;
//  int numBorders;
  ArrayList<RadialRange> ranges;
//  int numRanges;
  ArrayList<NeedlePointer> needles;  //Saves range indices containing needles
//  int numNeedles;
  ArrayList <Label> labels;
  
/* Class Variables */
  int gWidth,gHeight;

  Gauge(int Gw, int Gh, ArrayList<RadialBorder> rb, ArrayList<RadialRange> rr,ArrayList<NeedlePointer> rn, ArrayList<Label> l){
    gWidth=Gw;
    gHeight=Gh;
    borders= rb;
    ranges= rr;
    needles=rn;
    labels=l;
//    numBorders=0;
//    numRanges=0;
//    numNeedles=0;
  }
  Gauge(int gWidth, int gHeight){
    this(gWidth, gHeight, new ArrayList<RadialBorder>(), new ArrayList<RadialRange>(),new ArrayList<NeedlePointer>(),new ArrayList<Label>());
  }
  Gauge(){
   this(width/2, height/2, new ArrayList<RadialBorder>(), new ArrayList<RadialRange>(),new ArrayList<NeedlePointer>(),new ArrayList<Label>());
  }

  void gaugeEvent(String message){
    println(message);
    exit();
  }
  void addBorders(ArrayList<RadialBorder> rb){
    borders=rb;    
  }
  RadialBorder getborder(int i){ 
    if (i >= borders.size()){gaugeEvent("Border index out of range");}
    return (borders.get(i));
  }
  void addBorder(RadialBorder rb){
    borders.add(rb);
  }
  void addRanges(ArrayList<RadialRange> rr){
    ranges= rr;
  }
  RadialRange getRange(int i){
    if (i >= ranges.size()){gaugeEvent("Range index out of range");}
    return (ranges.get(i));
  }
  void addRange(RadialRange rr){
    ranges.add(rr);
  }

  void addLabesl(ArrayList<Label> l){
    labels= l;
  }
  Label getLabel(int i){
    if (i >= labels.size()){gaugeEvent("Label index out of range");}
    return (labels.get(i));
  }
  void addLabel(Label l){
    labels.add(l);
  }

  int getNumNeedles(){
    return(needles.size());
  }
  Boolean setNeedleValue(String ID,int value){  
    Boolean found=false;
    RadialNeedle needle;
    for (int i=0; i<needles.size();i++){
      needle=ranges.get(needles.get(i).rindex).scales.get(needles.get(i).sindex).needles.get(needles.get(i).nindex);
      if (needle.getID().equals(ID)){
        needle.setValue(value);
        found=true;
        break;
      }
    }
    return(found);
  }
  int getNeedleValue(String ID){  
    RadialNeedle needle;
    int value=0;
    Boolean found=false;
    for (int i=0; i<needles.size();i++){
      needle=ranges.get(needles.get(i).rindex).scales.get(needles.get(i).sindex).needles.get(needles.get(i).nindex);
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
    drawBorders();
    drawLabels();
    drawRanges();
  }
  void drawBorders(){
    for (RadialBorder border:borders){
      border.draw();
    }
  }
  void drawRanges(){
    for (RadialRange range:ranges){
      range.draw();
    }    
  }

  void drawLabels(){
    for (Label label:labels){
      label.draw();
    }    
  }


  void registerNeedle(int r, int s, int n){
      needles.add(new NeedlePointer(r,s,n));
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

  