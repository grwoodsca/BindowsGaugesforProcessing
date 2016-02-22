class RadialRange{
 
/* Center and shape*/
  int x,y;
  float startAngle,endAngle;

/* arrays of included objects Should convert to ArrayLists*/ 
  ArrayList<RadialScale> scales;
  ArrayList<RadialTicks> ticks;
  ArrayList<RadialCap> caps;
  
  RadialRange(int xpos, int ypos, float s, float e){
    x=xpos;
    y=ypos;
    startAngle=s;
    endAngle=e;
    scales=new ArrayList<RadialScale>();
    ticks=new ArrayList<RadialTicks>();
    caps=new ArrayList<RadialCap>();
  }
  void rangeEvent(String message) {
    println(message);
  }

  void addScale(RadialScale rs){
    scales.add(rs);
  }


  void addTicks(RadialTicks rt){
    ticks.add(rt);
  }

  void addCap(RadialCap rc){
    caps.add(rc);
  }
  void draw(){
    for (RadialScale scale:scales){
      scale.draw(this);
    }
    for (RadialTicks tick:ticks){
      tick.draw(this);
    }    
    for (RadialCap cap:caps){
      cap.draw();
    }    
  }
}