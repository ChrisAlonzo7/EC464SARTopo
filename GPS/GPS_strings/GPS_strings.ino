#include <Wire.h> //Needed for I2C to GPS

#include "SparkFun_u-blox_GNSS_Arduino_Library.h" //Click here to get the library: http://librarymanager/All#SparkFun_u-blox_GNSS
SFE_UBLOX_GNSS myGNSS;

void setup()
{
  Serial.begin(115200);  // 115200
  Serial.println("Test GPS");

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

  String tmp = "";
  String str = myGPS.getNMEA();
  if (str.indexOf("$GNGGA")) {

  }
  int correct = 0;
  int loop = 0;
  int flag = 0;
  while(true) {
    if (str[loop] == 'G' && correct == 0) {
        correct = correct + 1;
    }
    if (str[loop] == 'G' && correct == 1) {
      correct = correct + 1;
    }
    if (str[loop] == 'A' && correct = 2) {
      flag = flag + 1;
      correct = 3;
    }
    if (str[loop] == '*' && flag > 0) {
      flag = 0;
      correct = 0;
      break;
    }
    if (flag > 0) {
      tmp += str[loop];
    }

    loop = loop + 1;
  }
  Serial.print(str);

  delay(250); //Don't pound too hard on the I2C bus
}


