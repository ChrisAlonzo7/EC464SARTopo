#include <Wire.h> //Needed for I2C to GPS

#include "SparkFun_u-blox_GNSS_Arduino_Library.h" //Click here to get the library: http://librarymanager/All#SparkFun_u-blox_GNSS
SFE_UBLOX_GNSS myGNSS;

void setup()
{
  Serial.begin(9600);  // 115200
  Serial.println("Test GPS");
  myGPS.begin()

  Wire.begin();

  if (myGNSS.begin() == false)
  {
    Serial.println(F("u-blox GNSS module not detected at default I2C address. Please check wiring. Freezing."));
    while (1);
  }

  //This will pipe all NMEA sentences to the serial port so we can see them
  //myGNSS.setNMEAOutputPort(Serial);
}
void loop()
{
  myGNSS.checkUblox(); //See if new data is available. Process bytes as they come in.

  String allSentences = "";

  while (gnss.available(1000)) {
    char sentence[256];
    gnss.read(sentence, sizeof(sentence));
    allSentences += sentence;
  }

  Serial.println(allSentences);

  delay(250); //Don't pound too hard on the I2C bus
}

