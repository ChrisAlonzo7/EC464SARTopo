#include <SD.h>
#include <NeoTee.h>
#include <Wire.h> //Needed for I2C to GNSS
#include <SparkFun_u-blox_GNSS_v3.h>
SFE_UBLOX_GNSS myGNSS; 

unsigned long lastPrintTime = 0; // variable to store the last time the data was printed

void setup()
{
  if(!SD.begin()) {
    Serial.println("SD card initialization failed!");
    return;
  }
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
    unsigned long currentTime = millis(); // get the current time
    File myFile = SD.open("data.txt", FILE_WRITE);
    Print *outputs[] = { &Serial, &myFile };
    NeoTee tee( outputs, sizeof(outputs)/sizeof(outputs[0]) );
    if (currentTime - lastPrintTime >= 2000) { // check if 2 seconds have passed since the last print
      lastPrintTime = currentTime; // update the last print time
      tee.print(myGNSS.getLatitude()/10000000.0, 7);
      tee.print(F(","));
      tee.print(myGNSS.getLongitude()/10000000.0, 7);
      tee.print(F(","));
      tee.print(myGNSS.getYear());
      tee.print(F("-"));
      tee.print(myGNSS.getMonth());
      tee.print(F("-"));
      tee.print(myGNSS.getDay());
      tee.print(F(" "));
      tee.print(myGNSS.getHour()-5);
      tee.print(F(":"));
      tee.print(myGNSS.getMinute());
      tee.print(F(":"));
      tee.print(myGNSS.getSecond());
      tee.print(F(","));
      tee.print(myGNSS.getHeading());
      tee.print(F(","));
      tee.print(myGNSS.getGroundSpeed());
      tee.print(F(","));
      tee.print(myGNSS.getAltitudeMSL());
      tee.println();
    }
  }
}
