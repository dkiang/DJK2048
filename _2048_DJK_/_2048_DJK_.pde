#include <MeggyJrSimple.h>
void setup()
{
  MeggyJrSimpleSetup();
  Serial.begin(9600);
}

int blockDirection = 90;
int numberOfBlocks = 4;
boolean moveBegin = true;

//create a struct block
struct Block
{
  int x;
  int y;
  int color;
  int dir;
};


Block s1 = {2,1,7,-1};
Block s2 = {2,5,3,-1};
Block s3 = {4,3,2,-1};
Block s4 = {4,7,1,-1};

//define the array
Block blockArray[64] = {s1, s2, s3, s4};

void loop()
{
  ClearSlate();
  for (int i = 0; i < numberOfBlocks; i++)
  {
    drawBlock(blockArray[i].x, blockArray[i].y, blockArray[i].color);
  }
  if (moveBegin && numberOfBlocks < 16)
    spawn();
  DisplaySlate();
  delay(200);
  updateBlock();
  
  

  
  CheckButtonsPress(); // Updates direction based on button press and sets moveBegin to spawn a new block at next turn
  if (Button_Left) 
  {
    blockDirection = 270;
    moveBegin = true;
  }
  else if (Button_Up)
  {
    blockDirection = 0;
    moveBegin = true;
  }
  else if (Button_Right)
  {
    blockDirection = 90;
    moveBegin = true;
  }
  else if (Button_Down)
  {
    blockDirection = 180;
    moveBegin = true;
  }
  if (Button_A) printArray();
  updateBlockDirection();
}


//draw block
void drawBlock(int x, int y, int color)
{
  DrawPx(x,y,color);
  DrawPx(x+1,y,color);
  DrawPx(x+1,y-1,color);
  DrawPx(x,y-1,color);
 
}

void updateBlockDirection() // Goes through blockArray and sets all individual block directions to match the global
{
  for(int i; i < numberOfBlocks; i++)
  {
    blockArray[i].dir = blockDirection;
  } 
}


void updateBlock() // Moves every block in the array if there is an empty space
{
  for(int i = 0; i < numberOfBlocks; i++)
  {  

    if(blockArray[i].dir == 270)
    {
      if (blockArray[i].x > 0) // If it's not at the edge...
      {
        if(ReadPx(blockArray[i].x-2, blockArray[i].y) == 0) // If there's an empty space...
        blockArray[i].x -= 2;
      }
    }
  
    else if(blockArray[i].dir == 0)
    {
      if (blockArray[i].y < 7)
      {
        if(ReadPx(blockArray[i].x, blockArray[i].y+2) == 0)
        blockArray[i].y += 2;
      }
    }
   
    else if(blockArray[i].dir == 90)
    {
      if (blockArray[i].x < 6)
      {
        if(ReadPx(blockArray[i].x+2, blockArray[i].y) == 0)
        blockArray[i].x += 2;
      }
    }
    
    else if(blockArray[i].dir == 180)
    {
      if (blockArray[i].y > 0)
      {
        if(ReadPx(blockArray[i].x, blockArray[i].y-2) == 0)
        blockArray[i].y -= 2;
      }
    }
  }
}

void printArray()
{
  for (int i = 0; i < numberOfBlocks; i++)
  {
    Serial.print("Block ");
    Serial.println(i);
    Serial.print("x");
    Serial.print(blockArray[i].x);
    Serial.print(" y");
    Serial.print(blockArray[i].y);
    Serial.print(" Dir");
    Serial.println(blockArray[i].dir);
    Serial.println();
  }
}

// This searches the array for an empty spot and creates a new block there.
void spawn()
{
  boolean dupe = true;
  
  while (dupe)
  {
    int locX = random(4)*2;
    int locY = random(4)*2 + 1;
  
    for (int i = 0; i < numberOfBlocks; i++)
    {
      if (blockArray[i].x == locX && blockArray[i].y == locY)
      {
        dupe = true;
        break;
      }
    }
    dupe = false;
  }
  
  /* This generates a random block and sees if the space is empty
  int locX = random(4)*2;
  int locY = random(4)*2 + 1;
  
  while (ReadPx(locX,locY) != 0)
  {
    locX = random(4)*2;
    locY = random(4)*2 + 1;
  }*/
  
  
  
  Block temp = {locX, locY, White, -1}; // Creates a new block and adds it to blockArray
  blockArray[numberOfBlocks] = temp;
  numberOfBlocks++;
  moveBegin = false;
}
