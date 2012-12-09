// by Sean McKenna
// sample set vis (set'o'gram)
// 
// original paper:
//   Interactive Visual Analysis of Set-Typed Data
// 

// data file
String dataFile = "titanic.csv";
String fileLocation = "";

// data variables
String[] sets;
int setCount;
int[] setCounts;
String[] members;
int memberCount;
int[][] setMembership;

// size and color of screen
int w = 800;
int h = 600;
color bg = color(255, 255, 255, 0);

// position and size of graph
int graphX = 100;
int graphY = 100;
int graphW = w - graphX * 2;
int graphH = h - graphY * 2;
int barS = 5;
int barW;
int barY = graphY + graphH;
int barMax = 0;

// initial setup
void setup(){
  size(w, h, P2D);
  
  // read in data
  String[] lines = loadStrings(fileLocation + dataFile);
  
  // for each line, parse through and store the raw, cleaned data
  memberCount = lines.length - 1;
  members = new String[memberCount];
  for(int i = 0; i < lines.length; i++){
    String[] pieces = split(lines[i], ",");
    
    // for header row
    if(i == 0){
      setCount = pieces.length - 1;
      sets = new String[setCount];
      setCounts = new int[setCount];
      setMembership = new int[memberCount][setCount];
      for(int j = 0; j < pieces.length; j++){
        if(j != 0){
          pieces[j] = split(pieces[j], "\"")[1];
          sets[j - 1] = pieces[j];
        }
      }
    
    // for non-header row
    }else{
      pieces[0] = trim(split(pieces[0], "\"")[1]);
      members[i - 1] = pieces[0];
      for(int j = 0; j < pieces.length; j++)
        if(j != 0)
          setMembership[i - 1][j - 1] = int(pieces[j]);
    }
  }
  
  // set bar width
  barW = (graphW - (barS * (setCount + 1))) / setCount;
  
  // count the total number of elements in each set, store max
  for(int i = 0; i < memberCount; i++){
    for(int j = 0; j < setCount; j++){
      if(i == 0)
        setCounts[j] = 0;
      if(setMembership[i][j] > 0 && !sets[j].equals("class"))
        setCounts[j] += 1;
      else if(setMembership[i][j] > 1 && sets[j].equals("class"))
        setCounts[j] += 1;
      if(i == memberCount - 1)
        if(setCounts[j] > barMax)
          barMax = setCounts[j];
    }
  }
}

// begin draw cycle
void draw(){
  // wipe background each time
  background(bg);
}
