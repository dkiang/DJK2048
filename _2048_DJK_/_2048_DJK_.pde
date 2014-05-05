#include <MeggyJrSimple.h>
void setup()
{
  MeggyJrSimpleSetup();
  Serial.begin(9600);
  EditColor(Yellow, 13, 2, 0);
  EditColor(Orange, 13, 1, 0);
}

int blockDirection = 90;
int numberOfBlocks = 6;
boolean moveBegin = false;




//create a struct block
struct Block
{
  int x;
  int y;
  int color;
  int dir;
};


Block s1 = {2,1,Red,-1};
Block s2 = {4,3,Orange,-1};
Block s3 = {2,5,Green,-1};
Block s4 = {4,7,Blue,-1};
Block s5 = {0,1,Violet,-1};
Block s6 = {0,5,Yellow,-1};

//define the array
Block blockArray[64] = {s1, s2, s3, s4, s5, s6};

void loop()
{
  ClearSlate();
  for (int i = 0; i < numberOfBlocks; i++)
  {
    drawBlock(blockArray[i].x, blockArray[i].y, blockArray[i].color);
  }
  //if (moveBegin && numberOfBlocks < 16)
  //  spawn();
  DisplaySlate();
  delay(200);
  if (moveBegin)
  {
    updateBlocks();
    updateBlockDirection();
  }

  
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
  if (Button_A) 
  {
    printArray(); // Prints out values of blocks in the array
  }


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


void updateBlocks() // Moves every block in the array if there is an empty space
{
  int stopped = 0; // Number of blocks that have come to rest
  for (int i = 0; i < numberOfBlocks; i++)
  {
    if(blockArray[i].dir == 270)
    {
      if (blockArray[i].x <= 0) 
        stopped++; // Count it as stopped if it's on the edge
      else
      {
        if(isUnique(blockArray[i].x - 2, blockArray[i].y)) // If there's an empty space...
          blockArray[i].x -= 2; // Move the block
        else stopped++; // Otherwise, count it as stopped.
      }
    }
  
    else if(blockArray[i].dir == 0)
    {
      if (blockArray[i].y >= 7)
        stopped++;
      else
      {
        if(isUnique(blockArray[i].x, blockArray[i].y + 2))
          blockArray[i].y += 2;
        else stopped++;
      }
    }
   
    else if(blockArray[i].dir == 90)
    {
      if (blockArray[i].x >= 6)
        stopped++;
      else
      {
        if(isUnique(blockArray[i].x + 2, blockArray[i].y))
          blockArray[i].x += 2;
        else stopped++;
      }
    }
    
    else if(blockArray[i].dir == 180)
    {
      if (blockArray[i].y <= 1)
        stopped++;
      else
      {
        if(isUnique(blockArray[i].x, blockArray[i].y - 2))
          blockArray[i].y -= 2;
        else stopped++;
      }
    }
  }
  if (stopped >= numberOfBlocks)
  {
    moveBegin = false;
    spawn(); // Create a new block
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
  int locX = random(4)*2;
  int locY = random(4)*2 + 1;
  
  while (isUnique(locX,locY) == false)
  {
    locX = random(4)*2;
    locY = random(4)*2 + 1;
  }

  Block temp = {locX, locY, random(6)+1, -1}; // Creates a new block and adds it to blockArray
  blockArray[numberOfBlocks] = temp;
  numberOfBlocks++;
}

boolean isUnique(int x, int y)
{
  for (int i = 0; i < numberOfBlocks; i++)
  {
    if (blockArray[i].x == x && blockArray[i].y == y)
    {
      return false;
    }
  }
  return true;
}
