

class Graph {
  int x,y, h, l;
  
  String name = "noName";
  Graph(int setX, int setY, int setW, int setH){
    x = setX;
    y = setY;
    l = setW;
    h = setH;
    sampleData = new float[l];
    redraw();
  }
  
  
  
  float sampleData[];
  
  void redraw(){redraw(0);}
  
  void redraw(int mode){
    //mode 0 - waveform - typical audio data
    //mode 1 - absolute data, drawn with bars, typical FFT data
    fill(204, 102, 0);
    rect(x,y,l,h);
    int yMid = y+(h/2);
    
    float absMaxValue = 0;
    for(int i=0;i<sampleData.length;i++){
      if (abs(sampleData[i]) > absMaxValue)
        absMaxValue = sampleData[i];
    }
    float scaleFactor = (h/2)/absMaxValue;
    fill(0,0,200);
    
    text(String.format("-%.2f",absMaxValue),x+5,yMid+h/3,100,100);
    text(String.format("+%.2f",absMaxValue),x+5,yMid-h/3,100,100);
    
    for(int i=1;i<sampleData.length;i++){
      int x1 = x+i-1;
      int x2 = x+i;
      int y1 = yMid+int(sampleData[i-1]*scaleFactor);
      int y2 = yMid+int(sampleData[i]*scaleFactor);
      line(x1,y1,x2,y2);
    }
  
  text(name, x+5,y+5,400,50);
  }
  
  //scaleData(float dataIn[], float dataOut[], float scaleFactor = 0){
  //  int sizeIn = dataIn.length;
  //  int sizeOut = dataOut.length;
  //  if (scaleFactor == 0) 
  //        scaleFactor = sizeOut/sizeIn;
  //  for (int i=0;i<sizeIn;i++){
      
  void fillWithData(float data[]){fillWithData(data,1);}
  
  void fillWithData(float data[], int dataType){
    int i=0;
    //fill internal buffer with zeros
    for (i=0;i<data.length;i++)
      sampleData[i] = 0.0f;
    i = 0;
    if (data.length>sampleData.length)
      i = data.length - sampleData.length;//ignore some samples, or stretch data?
    for (;i<data.length;i++){
      sampleData[i] = data[i];
    }
    redraw();
  }
  
  void appendData(float data[]){appendData(data,1);}
  
  void appendData(float data[], int dataType){
    if (data.length > sampleData.length){
      float[] newData = subset(data,data.length-sampleData.length,sampleData.length);////Arrays.copyOfRange(data,data.length-sampleData.length,data.length);
      fillWithData(newData,dataType);
    }
    else{
      //shift array to make space for new samples
      int sizeDiff = sampleData.length - data.length;
      for(int i=0;i<sizeDiff;i++)
        sampleData[i] = sampleData[i+data.length];
      //append sample array with new samples
      for(int i=0;i<data.length;i++)
        sampleData[sizeDiff+i] = data[i];
      redraw();
    }
  }
}


class GraphContainer{
  int x,y,w,h;
  Graph graphs[];
  
  GraphContainer(int x, int y, int w, int h, int graphNo){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    graphs = new Graph[graphNo];
    for (int i = 0;i<graphs.length;i++)
      graphs[i] = new Graph(x,y+i*(h/graphNo),w,h/graphNo);
  }
  
  void handleJson(JSONObject[] jArray){
    for(int iJsons = 0; iJsons < jArray.length; iJsons++){
      JSONObject j = jArray[iJsons].getJSONObject("Packet");
      if (j==null){
        print("wrong JSON object!");
      }
      else{
       print("printing json data\n\n");
       print(j);
       String type = j.getString("type","DataErr");
       String name = j.getString("name","DataErr");
       int dataSize = j.getInt("dataSize",0);
       
       float[] data = new float[dataSize];
       
       String dataString = j.getString("data");
       String[] dataStringArray = dataString.split(",");
       //float[] data = new float();
       for(int k=0;k<dataStringArray.length;k++){
         //if(dataStringArray[k].length() !=0)
         //print(dataStringArray[k]);
           data[k] = Float.parseFloat(dataStringArray[k]);
       }
       
       //JSONArray jData = j.getJSONArray("data");
       //if(jData != null){
       //  for(int k=0;k<dataSize;k++)
       //    data[k] = jData.getInt(k,0);
       //}   
       boolean graphNameFound = false;
       //try to find an graph that already has this name
       for(int i = 0;i<graphs.length;i++){
         if (graphs[i].name.equals(name)){
           //if found, append with new data
           graphs[i].appendData(data);
           graphNameFound = true;
           break;
         }
       }
       
       if(graphNameFound == false){
         //graph has not been found, try to claim a new graph
         boolean graphCreated = false;
         for(int i = 0;i<graphs.length;i++){
           if (graphs[i].name.equals("noName")){
               //claim empty graph
               graphs[i].name = name;
               graphs[i].appendData(data);
               graphCreated = true;
               break;
           }
           if (graphCreated ==false)
             print("no available graphs for this data:"+j);
         }
       }
      }
    }
  }
  
  
}


boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}