#include <Wire.h> //Needed for I2C to GNSS
#include <SparkFun_u-blox_GNSS_v3.h>
SFE_UBLOX_GNSS myGNSS; 

void setup()
{
  Serial.begin(115200);
  delay(1000); 
  Serial.println("Latitude, Longitude, Heading (Returns heading in degrees * 10^-5), Ground Speed (mm/s), and Altitude (Returns the current altitude in mm above mean sea level).");

  Wire.begin();

  while (myGNSS.begin() == false) //Connect to the u-blox module using Wire port
  {
    Serial.println(F("u-blox GNSS not detected at default I2C address. Retrying..."));
    delay (1000);
  }

  myGNSS.setI2COutput(COM_TYPE_UBX); //Set the I2C port to output UBX only (turn off NMEA noise)
  
}

void loop()
{
  if (myGNSS.getPVT() == true) // getPVT() returns true when new data is received.
  {
    Serial.print(myGNSS.getLatitude()/10000000.0, 7);
    Serial.print(F(","));
    Serial.print(myGNSS.getLongitude()/10000000.0, 7);
    Serial.print(F(","));
    Serial.print(myGNSS.getYear());
    Serial.print(F("-"));
    Serial.print(myGNSS.getMonth());
    Serial.print(F("-"));
    Serial.print(myGNSS.getDay());
    Serial.print(F(" "));
    Serial.print(myGNSS.getHour()-5);
    Serial.print(F(":"));
    Serial.print(myGNSS.getMinute());
    Serial.print(F(":"));
    Serial.print(myGNSS.getSecond());
    Serial.print(F(","));
    Serial.print(myGNSS.getHeading());
    Serial.print(F(","));
    Serial.print(myGNSS.getGroundSpeed());
    Serial.print(F(","));
    Serial.print(myGNSS.getAltitudeMSL());
    Serial.println();
  }
}
