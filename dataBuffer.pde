class DataBuffer{
  
  int classTest(){
    println("testing class");
    addText("init");
    addText("{\"Packet\":{\"type\":\"data\",\"name\":\"SampleData\",\"dataSize\":8,\"packetNo\":0,\"data\":\"0.1,4.5,54.3,6,7,8\",\"xValue\":\"100\",\"xUnit\":\"s\"}}");
    addChar('#');
    ArrayList<JSONObject> jsons = getJsons();
    //println("parsed JSON:");
    //print(jsons.get(0).toString());
    println(jsons.get(0).getJSONObject("Packet").getString("name"));
    //if(jsons.get(0).getJSONObject("Packet").getString("name")!="SampleData")
    //  return -1;
    addText("{\"Packet\":{\"type\":\"data\",\"name\":\"SampleData\",\"dataSize\":8,\"packetNo\":0,\"data\":\"0.1,4.5,54.3,6,7,8\",\"xValue\":\"100\",\"xUnit\":\"s\"}}");
    addText("LUL");
    addText("{\"Packet\":{\"type\":\"data\",\"name\":\"SampleData\",\"dataSize\":8,\"packetNo\":0,\"data\":\"0.1,4.5,54.3,6,7,8\",\"xValue\":\"100\",\"xUnit\":\"s\"}}");
    
    println("size: "+ getJsons().size());
    println("size: "+ getJsons().size());
    addText("{\"Packet\":{\"type\":\"data\",\"name\":\"SampleData\",\"dataSize\":8,\"pack");
    println("size after adding half json: "+ getJsons().size());
    getString();
    addText("etNo\":0,\"data\":\"0.1,4.5,54.3,6,7,8\",\"xValue\":\"100\",\"xUnit\":\"s\"}}");
    println("size after other half: "+ getJsons().size());
    println("size trying to get one more: "+ getJsons().size());
    //print()
    
    println(getString());
    return 0;
  }
  
  static final int maxLen = 20000;
  
  ArrayList<Character> chars = new ArrayList<Character>();
  int addPointer = 0;
  int parsePointer = 0;
  int bracketCounter = 0;
  
  ArrayList<JSONObject> jsons = new ArrayList<JSONObject>();
  
  DataBuffer(){
    clear();
    classTest();
  }
  
  void clear(){
    parsePointer = 0;
    addPointer = 0;
    chars.clear();
  }
  
  //ArrayList<String> getStrings();
  
  //ArrayList<String> getStrings(int n);
  
  void addText(String text){
    //text = text.replaceAll("i",System.getProperty("line.separator"));
    for(int i = 0; i< text.length(); i++){
      addChar(text.charAt(i));
    }
  }
  
  void addText(char c){
    addChar(c);
  }
  
  void addChar(char c){
    chars.add(addPointer++,c);
    if(addPointer > maxLen){
      shiftChars(2000);
    }
    if (c=='{')
      bracketCounter++;
    else if (c=='}'){
      bracketCounter--;
      if (bracketCounter == 0){
        findJson();
      }
      if (bracketCounter < 0){
        print("WARNING: bracket counter detected corrupted JSON data!");
      }
    }
  }
    
  void shiftChars(int i){
    chars.subList(i,chars.size());
    addPointer -= i;
    parsePointer -=i;
    if (parsePointer < 0){
      parsePointer = 0;
      print("WARNING: probable corrupted JSON data in buffer!");
    }
  }
  //findJsons() - this function should be 
  
  void findJson(){
    //find 1st opening bracket in buffer
    while(chars.get(++parsePointer)!='{');
    
    String jsonString = "";
    while(parsePointer < addPointer)
      jsonString += chars.get(parsePointer++);
    //buffer should contain valid JSON data.
    //print(jsonString);
    jsons.add(parseJSONObject(jsonString));
  }
  
  
  ArrayList<JSONObject> getJsons(){
    ArrayList<JSONObject> returnJsons = (ArrayList<JSONObject>)jsons.clone();
    jsons.clear();
    return returnJsons;
  }
  
  
  String getString(){
    String ret = "";
    for(int i=0;i< addPointer;i++){
      ret += chars.get(i);
    }
    return ret;
  }
}
        
     
  