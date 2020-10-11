
/**
  @file Snake
  @author Sebastià A. Noceras Anderson
  @date 23/03/2020
  @brief práctica 6.
 */
/**************************************/
/* MACROS                             */
/**************************************/
#define RESET 0
#define ARROW_UP 1
#define ARROW_DOWN 2
#define ARROW_LEFT 3
#define ARROW_RIGHT 4
#define PAUSE 6
#define PLAY 7
#define BEGIN 5

/**************************************/
/* General variables                  */
/**************************************/

volatile bool timer_flag = false;

ISR(TIMER1_COMPA_vect)
{
  timer_flag = true;
}


/******************************************************************************/
/** SETUP *********************************************************************/
/******************************************************************************/

void setup()
{
  Serial.begin(115200);

  // Configure timer
  noInterrupts();
  TCCR1A = 0;
  TCCR1B = 0;

  TCCR1B |= (1 << WGM12); // CTC => WGMn3:0 = 0100
  OCR1A = 49911/2; //Half a second
  TIMSK1 |= (1 << OCIE1A);
  TCCR1B |= (1 << CS12);
  interrupts();
}


/******************************************************************************/
/** LOOP **********************************************************************/
/******************************************************************************/

void loop()
{
  uint8_t state = 0;
  uint16_t x = 40;
  uint16_t y = 40;
  const uint8_t JUMP = 40;
  uint8_t key;
  uint8_t play = false;
  uint8_t reset = false;
  
  while(1)
  {
    if (timer_flag)
    {  
      if (play){//Press space button to start the game
        
        switch (state)
        {
          case 0 : x += JUMP; break;
          case 1 : y += JUMP; break;
          case 2 : x -= JUMP; break;
          case 3 : y -= JUMP; break;
        }
        
        Serial.write(highByte(x));
        Serial.write(lowByte(x));
  
        Serial.write(highByte(y));
        Serial.write(lowByte(y));

        if (OCR1A > 49911/16) OCR1A = OCR1A - 50; //Maximum speed = 1/16 seconds
        
        if (x > 800 || y > 600 || reset == true)
        {
        x = 40; 
        y = 40;
        
        state = 0;
        play = false;
        OCR1A = 49911/2;
        
        Serial.write(highByte(x));
        Serial.write(lowByte(x));
  
        Serial.write(highByte(y));
        Serial.write(lowByte(y));
        }
      }
      
      timer_flag = false;
    }

    if (Serial.available() > 0)
    {
      key = Serial.read();

      // Control movement
      if      (key == PLAY) TCCR1B &= ~(1 << CS12); //'a' ASCII
      else if (key == PAUSE) TCCR1B |= (1 << CS12); //'s' ASCII
      else if (key == BEGIN){
        play = true;
        reset = false;
      }
      else if (key == ARROW_UP) state = 1; // UP
      else if (key == ARROW_DOWN) state = 3; // DOWN
      else if (key == ARROW_LEFT) state = 2; // LEFT
      else if (key == ARROW_RIGHT) state = 0; // RIGHT
      else if (key == RESET){
        state = 0;
        reset = true;
      }
    }
  }
}
