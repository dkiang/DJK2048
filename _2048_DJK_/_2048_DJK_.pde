#include <MeggyJrSimple.h>
void setup()
{
  MeggyJrSimpleSetup();
  Serial.begin(9600);
}

int blockDirection = 90;
int numberOfBlocks = 4;

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
  
  DisplaySlate();
  delay(200);
  updateBlock();

  

  
  CheckButtonsPress();
  if (Button_Left) blockDirection = 270;
  if (Button_Up) blockDirection = 0;
  if (Button_Right) blockDirection = 90;
  if (Button_Down) blockDirection = 180;
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
      if (blockArray[i].x > 0)
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
