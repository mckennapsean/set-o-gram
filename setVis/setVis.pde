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
int[][] setFreq;
String[] members;
int memberCount;
int[][] setMembership;

// size and color of screen
int w = 800;
int h = 400;
color bg = color(255, 255, 255, 0);

// position and size of graph
int graphX = 100;
int graphY = 100;
int graphW = w - graphX * 2;
int graphH = h - graphY * 2;
int barS = 25;
int barW;
int barY = graphY + graphH;
int barMax = 0;

// font data
PFont titleFont;
PFont dataFont;

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
      else if(setMembership[i][j] < 2 && sets[j].equals("class"))
        setCounts[j] += 1;
      if(i == memberCount - 1)
        if(setCounts[j] > barMax)
          barMax = setCounts[j];
    }
  }
  
  // determine frequency counts among sets
  setFreq = new int[setCount][setCount];
  for(int i = 0; i < setCount; i++){
    // store frequency count
    for(int j = 0; j < memberCount; j++){
      // determine frequency
      int freq = 0;
      for(int k = 0; k < setCount; k++){
        // set initial frequency count to zero
        if(j == 0)
          setFreq[i][k] = 0;
        if(setMembership[j][k] > 0 && !sets[k].equals("class"))
          freq += 1;
        else if(setMembership[j][k] < 2 && sets[k].equals("class"))
          freq += 1;
      }
      // add to frequency count
      if(setMembership[j][i] > 0 && freq > 0 && !sets[i].equals("class"))
        setFreq[i][freq - 1] += 1;
      else if(setMembership[j][i] < 2 && freq > 0 && sets[i].equals("class"))
        setFreq[i][freq - 1] += 1;
    }
  }
  
  // set fonts
  titleFont = createFont("Verdana", 20);
  dataFont = createFont("Georgia", 20);
}

// begin draw cycle
void draw(){
  // wipe background each time
  background(bg);
  
  // draw bar graph lines
  line(graphX, graphY + graphH, graphX + graphW, graphY + graphH);
  line(graphX, graphY, graphX, graphY + graphH);
  
  // draw titles
  textFont(titleFont);
  textAlign(CENTER);
  String title = split(dataFile, ".")[0];
  text(title, w / 2, graphY - 50);
  textSize(12);
  String yAxisTitle = "members";
  pushMatrix();
  translate(graphX / 2, graphY + graphH / 2);
  rotate(-HALF_PI);
  text(yAxisTitle, 0, 0);
  popMatrix();
  for(int i = 0; i < setCount; i++)
    text(sets[i], graphX + (barS * (i + 1)) + (barW * i) + barW / 2, graphY + graphH + 50);
  
  // draw data marks
  textFont(dataFont);
  textSize(12);
  stroke(75);
  strokeWeight(1);
  textAlign(CENTER, TOP);
  text(barMax, graphX - 25, graphY);
  line(graphX - 10, graphY, graphX, graphY);
  textAlign(CENTER, BOTTOM);
  text("0", graphX - 25, graphY + graphH);
  line(graphX - 10, graphY + graphH, graphX, graphY + graphH);
  
  // draw bar graph
  for(int i = 0; i < setCount; i++){
    fill(0, 0, 0, 50);
    rect(graphX + (barS * (i + 1)) + (barW * i), graphY + graphH, barW, - (float) setCounts[i] / barMax * graphH);
    fill(0);
    float prevY = 0;
    float nextY;
    for(int j = 0; j < setCount; j++){
      nextY = -(float) setFreq[i][j] / barMax * graphH;
      rect(graphX + (barS * (i + 1)) + (barW * i), graphY + graphH + prevY, barW * 1.0 / (j + 1), nextY);
      prevY += nextY;
    }
  }
}
