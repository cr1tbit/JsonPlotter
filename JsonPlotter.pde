import processing.serial.*;


GraphContainer gContainer;
TextBox textBox;
DataBuffer dataBuffer;


float[] testData = new float[20];
float sf = 1.0f;

Serial myPort; 

void mousePressed(){
  if (overRect(0, 0, 100, 100)){
    String[] s = loadStrings("sample.json");
    if(s != null){
      for(int i=0;i<s.length;i++){
        dataBuffer.addText(s[i]);
      }
    }
  }
}


//interface setup
int offset = 40;
float golRatio = 0.61f;

void setup() {
  size(1024, 720);
  background(0,0,0);
  /***creating objects:***/
  //graph container
  gContainer = new GraphContainer(0,offset,int(width*golRatio), height - offset,4);
  //blue button in corner
  rect(0,0,offset,offset);
  //black textbox on the right
  textBox = new TextBox(int(width*golRatio), 0, int(width*(1-golRatio)), height);
  //object responsible for data handling
  dataBuffer = new DataBuffer();
  
  /***UART config***/
  String[] portNames = Serial.list(); 
  if(portNames.length > 0)
    myPort = new Serial(this, portNames[0], 115200);
  else 
    myPort = null;
}

void draw(){
  if ( myPort != null){
    while ( myPort.available() > 0) {  // If data is available,
      dataBuffer.addText(myPort.readChar());
    }
  }
  
  //sf += 0.01f;
  //for(int i=0;i<testData.length;i++){
  //  testData[i] = sin(i/sf);
  //}
  
  ArrayList<JSONObject> jsons = dataBuffer.getJsons();
  
  gContainer.handleJson(jsons.toArray(new JSONObject[jsons.size()]));
  textBox.setText(dataBuffer.getString());
  textBox.redraw();
  text(int(frameRate),width-100,10);
  //delay(250);
}