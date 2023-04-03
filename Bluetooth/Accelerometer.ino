#include <Wire.h>
#include <Adafruit_Sensor.h> 
#include <Adafruit_ADXL345_U.h>

Adafruit_ADXL345_Unified accel = Adafruit_ADXL345_Unified();

int count = 0;
int flag = 0;

void setup(void) 
{
   Serial.begin(9600);  
   if(!accel.begin())
   {
      Serial.println("No ADXL345 sensor detected.");
      while(1);
   }
}
void loop(void) 
{
   sensors_event_t event; 
   accel.getEvent(&event);

   float x = event.acceleration.x;
   float y = event.acceleration.y;
   float z = event.acceleration.z;
   z = z - 12.08;
   y = y - 0.35;
   x = x + 0.1;



   Serial.print("X: "); Serial.print(x); Serial.print("  ");
   Serial.print("Y: "); Serial.print(y); Serial.print("  ");
   Serial.print("Z: "); Serial.print(z); Serial.print("  ");
    Serial.println("m/s^2 ");
   // Detecting sitting
   if (y < -3) {
     count = count + 1;
   }
   // Stoped sitting
   if (y > -1) {
     count = 0;
     flag = 0;
   }
   // Dog has been detected sitting for 1.5 seconds (3 * 0.5s)
  if (count > 2) {
    flag = 1;
  }
  if (flag == 1) {
    Serial.print("Sitting ");
  }
  if (flag == 0) {
    Serial.print("Not Sitting ");
  }
   delay(500);
}