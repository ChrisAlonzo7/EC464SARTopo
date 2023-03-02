#include <Wire.h> //Needed for I2C to GNSS
#include <SparkFun_u-blox_GNSS_v3.h>
#include <SD.h> //Needed for SD card

SFE_UBLOX_GNSS myGNSS;
File dataFile;

unsigned long lastPrintTime = 0; // variable to store the last time the data was printed

void setup()
{
  Serial.begin(115200);
  delay(1000);
  Serial.println("Latitude, Longitude, Time, Heading (Returns heading in degrees * 10^-5), Ground Speed (m/s), and Altitude (Returns the current altitude in m above mean sea level).");

  Wire.begin();

  while (myGNSS.begin() == false) //Connect to the u-blox module using Wire port
  {
    Serial.println(F("u-blox GNSS not detected at default I2C address. Retrying..."));
    delay(1000);
  }

  myGNSS.setI2COutput(COM_TYPE_UBX); //Set the I2C port to output UBX only (turn off NMEA noise)

  SD.begin(10); // Initialize the SD card on pin 10
  dataFile = SD.open("gps.txt", FILE_WRITE); // Open the file for writing
  dataFile.println("Latitude, Longitude, Time, Heading (Returns heading in degrees * 10^-5), Ground Speed (m/s), and Altitude (Returns the current altitude in m above mean sea level).");
  dataFile.close();
}

void loop()
{
  if (myGNSS.getPVT() == true) // getPVT() returns true when new data is received.
  {
    unsigned long currentTime = millis(); // get the current time
    if (currentTime - lastPrintTime >= 2000) { // check if 2 seconds have passed since the last print
      lastPrintTime = currentTime; // update the last print time
      
      // Open the file for appending
      dataFile = SD.open("gps.txt", FILE_WRITE);
      if (dataFile) {
        dataFile.print(myGNSS.getLatitude()/10000000.0, 7);
        dataFile.print(",");
        dataFile.print(myGNSS.getLongitude()/10000000.0, 7);
        dataFile.print(",");
        dataFile.print(myGNSS.getYear());
        dataFile.print("-");
        dataFile.print(myGNSS.getMonth());
        dataFile.print("-");
        dataFile.print(myGNSS.getDay());
        dataFile.print(" ");
        dataFile.print(myGNSS.getHour()-5);
        dataFile.print(":");
        dataFile.print(myGNSS.getMinute());
        dataFile.print(":");
        dataFile.print(myGNSS.getSecond());
        dataFile.print(",");
        dataFile.print(myGNSS.getHeading());
        dataFile.print(",");
        dataFile.print(myGNSS.getGroundSpeed()/1000);
        dataFile.print(",");
        dataFile.print(myGNSS.getAltitudeMSL()/1000);
        dataFile.println();
        dataFile.close();
      }
    }
  }
}
