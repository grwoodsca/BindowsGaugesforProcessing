  class RadialTicks {
    int radius, tickLen,tickWeight,tickCount;
    color tickColour;
    RadialTicks( int r, int tl, int tw, int tc, color c){
      radius=r;
      tickLen=tl;
      tickWeight=tw;
      tickCount=tc;
      tickColour=c;
    }

    RadialTicks(){
      this(0,0,0,0,0);
    }
    
    /* radial tick extraction method */
    void fillTicksfromXML(XML rt){
      radius=rt.getInt("radius",gauge.defaultOrigin);
      tickCount=rt.getInt("tickCount",0);
      tickLen=rt.getInt("tickLength",0);
      tickWeight=rt.getInt("tickWidth",0);
      tickColour=tree.stringToColor(rt.getString("color","#0"));
    }

    void draw(RadialRange rr){
      float angleInt=radians(rr.endAngle-rr.startAngle)/(tickCount-1);
      stroke(tickColour);
      strokeWeight(tickWeight);
      int r=radius-tickLen/2;
      int xTop=-tickLen/2;
      int xBottom=tickLen/2;
      for (float angle=radians(rr.startAngle)-PI/2; angle < radians(rr.endAngle)-PI/2; angle+=angleInt){  //
          pushMatrix();
          float xorigin = rr.x + (cos(angle)* r);
          float yorigin = rr.y + (sin(angle)* r);
          translate(xorigin,yorigin);
          rotate(angle);
          line(xTop,0,xBottom,0);  // tick is placed at the new origin; 0 deg in Trig maps to 90 deg on a compass
          popMatrix();
      }
    } 
  }