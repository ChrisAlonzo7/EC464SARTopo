#include <Wire.h> //Needed for I2C to GNSS
#include <SparkFun_u-blox_GNSS_v3.h>
SFE_UBLOX_GNSS myGNSS; 

void setup()
{
  Serial.begin(115200);
  delay(1000); 
  Serial.println("GPS DATA");

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
  if (myGNSS.getPVT() == true)
  {
    Serial.print(F("Lat: "));
    Serial.print(myGNSS.getLatitude());
    Serial.print(F(" Long: "));
    Serial.print(myGNSS.getLongitude());
    Serial.print(F(" Alt: "));
    Serial.print(myGNSS.getAltitudeMSL());
    Serial.print(F(" (mm)"));
    Serial.println();
  }
}
