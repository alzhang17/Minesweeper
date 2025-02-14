import de.bezier.guido.*;
public static final int NUM_ROWS = 10;
public static final int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager

    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i,j);
      }
    }   
       
    setMines();
}
public void setMines()
{
    while(mines.size() < 15){
      int r = (int)(Math.random()*10);
      int c = (int)(Math.random()*10);
      if(mines.contains(buttons[r][c])){
        continue;
      }else{
        mines.add(buttons[r][c]);
        //System.out.println(r + ", " + c);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  int count = 0;
  for(int r = 0; r < NUM_ROWS; r++){
    for(int c = 0; c < NUM_COLS; c++){
      if(mines.contains(buttons[r][c]) && buttons[r][c].flagged == true){
        count++;
      }
    }
  }
  if(count == mines.size())
    return true;
  return false;
}
public void displayLosingMessage(){
 for(int r = 0; r < NUM_ROWS; r++){
   for(int c = 0; c < NUM_COLS; c++){   
     if(countMines(r, c) != 0)
       buttons[r][c].setLabel(countMines(r, c)); 
       buttons[r][c].clicked = true;
   }
 }
 for(int r = 0; r < NUM_ROWS; r++){
   for(int c = 0; c < NUM_COLS; c++){   
     if(buttons[r][c].flagged == true)
       buttons[r][c].flagged = false;
   }
 }
 if(buttons[NUM_ROWS/2][NUM_COLS/2 - 1].clicked == true && buttons[NUM_ROWS/2][NUM_COLS/2].clicked == true){
   buttons[NUM_ROWS/2][NUM_COLS/2].flagged = false;
   buttons[NUM_ROWS/2][NUM_COLS/2 - 1].flagged = false;
 }
 buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("You");
 buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("Lose!"); 
}
public void displayWinningMessage()
{
  for(int r = 0; r < NUM_ROWS; r++){
   for(int c = 0; c < NUM_COLS; c++){   
     if(countMines(r, c) != 0)
       buttons[r][c].setLabel(countMines(r, c)); 
       buttons[r][c].clicked = true;
   }
 }
  if(buttons[NUM_ROWS/2][NUM_COLS/2 - 1].clicked == true && buttons[NUM_ROWS/2][NUM_COLS/2].clicked == true){
   buttons[NUM_ROWS/2][NUM_COLS/2].flagged = false;
   buttons[NUM_ROWS/2][NUM_COLS/2 - 1].flagged = false;
   }
    buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("Good");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("Job");
}
public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && r > -1 && c > -1 && c < NUM_COLS)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
  /*  if(isValid(r, c - 1) && blobs[r][c - 1].isMarked()){
      blobs[r][c-1].mousePressed();    
    }*/
    if(isValid(row, col) && !mines.contains(buttons[row][col])){
      if(isValid(row - 1, col - 1) && mines.contains(buttons[row-1][col-1]))
        numMines++;
      if(isValid(row, col - 1) && mines.contains(buttons[row][col-1]))
        numMines++;
      if(isValid(row - 1, col) && mines.contains(buttons[row-1][col]))
        numMines++;
      if(isValid(row + 1, col + 1) && mines.contains(buttons[row + 1][col + 1]))
        numMines++;
      if(isValid(row, col + 1) && mines.contains(buttons[row][col + 1]))
        numMines++;
      if(isValid(row + 1, col) && mines.contains(buttons[row + 1][col]))
        numMines++;
      if(isValid(row + 1, col - 1) && mines.contains(buttons[row + 1][col-1]))
        numMines++;
      if(isValid(row - 1, col + 1) && mines.contains(buttons[row-1][col + 1]))
        numMines++;
    }
    //System.out.println(numMines);
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton (int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          clicked = false;
            if(flagged){
              flagged = false;
            }else{
              flagged = true;
            }
        }else if(mines.contains(this)){
         displayLosingMessage();
        }else if(countMines(myRow, myCol) > 0 ){
            setLabel(countMines(myRow, myCol));
        }else{
          if(isValid(myRow - 1, myCol - 1) && !buttons[myRow - 1][myCol - 1].clicked == true){
            buttons[myRow - 1][myCol - 1].mousePressed();
          }
          if(isValid(myRow , myCol - 1) && !buttons[myRow ][myCol - 1].clicked == true){
            buttons[myRow  ][myCol - 1].mousePressed();
          }
          if(isValid(myRow - 1, myCol) && !buttons[myRow - 1][myCol].clicked == true){
            buttons[myRow - 1][myCol].mousePressed();
          }
          if(isValid(myRow, myCol) && !buttons[myRow][myCol].clicked == true){
            buttons[myRow][myCol].mousePressed();
          }
          if(isValid(myRow + 1, myCol + 1) && !buttons[myRow + 1][myCol + 1].clicked == true){
            buttons[myRow + 1][myCol + 1].mousePressed();
          }
          if(isValid(myRow, myCol + 1) && !buttons[myRow][myCol + 1].clicked == true){
            buttons[myRow][myCol + 1].mousePressed();
          }
          if(isValid(myRow + 1, myCol) && !buttons[myRow + 1][myCol].clicked == true){
            buttons[myRow + 1][myCol].mousePressed();
          }
          if(isValid(myRow + 1, myCol - 1) && !buttons[myRow + 1][myCol - 1].clicked == true){
            buttons[myRow + 1][myCol - 1].mousePressed();
          }
          if(isValid(myRow - 1, myCol + 1) && !buttons[myRow - 1][myCol + 1].clicked == true){
            buttons[myRow - 1][myCol + 1].mousePressed();
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
