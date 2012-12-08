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
String[] members;
int memberCount;
int[][] setMembership;

// size and color of screen
int w = 800;
int h = 600;
color bg = color(255, 255, 255, 0);

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
}

// begin draw cycle
void draw(){
  // wipe background each time
  background(bg);
}
