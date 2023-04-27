#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL345_U.h>
#include <Adafruit_NeoPixel.h>
#include <SparkFun_u-blox_GNSS_v3.h>
SFE_UBLOX_GNSS myGNSS; 

unsigned long lastPrintTime = 0; // variable to store the last time the data was printed

#define LED_PIN_1 10
#define NUM_LEDS 3

// Create an instance of the ADXL345 accelerometer
Adafruit_ADXL345_Unified accel = Adafruit_ADXL345_Unified(12345);
Adafruit_NeoPixel strip_1(NUM_LEDS / 2, LED_PIN_1, NEO_GRB + NEO_KHZ800);  // LED Setup

// Global Vars for sitting algorithm
int count = 0;
int flag = 0;

void setup() {

  // Initialize the ADXL345 accelerometer
  Serial.begin(9600);
  // Initialize Bluetooth communication (Serial1)
  Serial1.begin(9600); // Set the baud rate for the HC-05 (typically 9600 or 38400)
  // Initializing GPS Module
  Serial2.begin(9600);
  Wire.begin();

  bool accelDetected = accel.begin();
  bool gnssDetected = myGNSS.begin();

  // while (!accelDetected || !gnssDetected) 
  // {
  //   if (!accelDetected) {
  //     Serial.println("No ADXL345 sensor detected.");
  //     accelDetected = accel.begin();
  //   }

  //   if (!gnssDetected) {
  //     Serial.println(F("u-blox GNSS not detected at default I2C address. Retrying..."));
  //     gnssDetected = myGNSS.begin();
  //   }
  //   delay (1000);
  // }
  myGNSS.setI2COutput(COM_TYPE_UBX); //Set the I2C port to output UBX only (turn off NMEA noise)


  accel.setRange(ADXL345_RANGE_2_G); // Configure the accelerometer range

  // LED Setup
  strip_1.begin();
  strip_1.show(); // Initialize all pixels to "off"
}

void loop() {
  // LEDS
  strip_1.setPixelColor(0, strip_1.Color(191, 0, 255));
  //strip_1.show(); // Update the first LED strip with the new colors


  // Read acceleration data from the ADXL345
  sensors_event_t event;
  accel.getEvent(&event);
  // Serial.print("X: ");                  // Print the acceleration values
  // Serial.print(event.acceleration.x);
  // Serial.print(" m/s^2\tY: ");
  // Serial.print(event.acceleration.y);
  // Serial.print(" m/s^2\tZ: ");
  // Serial.print(event.acceleration.z);
  // Serial.println(" m/s^2");
  // delay(500);
  
  // Correcting Accelerometer Values
  float x = event.acceleration.x;
  float y = event.acceleration.y;
  float z = event.acceleration.z;
  z = z - 12.08;
  y = y - 0.35;
  x = x + 0.1;
  // Send data to the Bluetooth module
  Serial.print("msg: Sent\n");
  Serial1.print("X: ");                  // Print the acceleration values
  Serial1.print(x);
  Serial1.print(" m/s^2\tY: ");
  Serial1.print(y);
  Serial1.print(" m/s^2\tZ: ");
  Serial1.print(z);
  Serial1.println(" m/s^2");
  // Detecting sitting
      if (y < -3) {
        count = count + 1;
      }
      // Stopped sitting
      if (y > -1) {
        count = 0;
        flag = 0;
      }
      // Dog has been detected sitting for 1.5 seconds (3 * 0.5s)
      if (count > 2) {
        flag = 1;
      }
      if (flag == 1) {
        Serial1.print("Sitting - ");
      }
      if (flag == 0) {
        Serial1.print("Not Sitting - ");
      }


  // GPS Module 
  if (myGNSS.getPVT() == true) // getPVT() returns true when new data is received.
  {
    unsigned long currentTime = millis(); // get the current time
    if (currentTime - lastPrintTime >= 2000) { // check if 2 seconds have passed since the last print
      lastPrintTime = currentTime; // update the last print time
      Serial2.print(myGNSS.getLatitude()/10000000.0, 7);
      Serial2.print(F(","));
      Serial2.print(myGNSS.getLongitude()/10000000.0, 7);
      Serial2.print(F(","));
      Serial2.print(myGNSS.getYear());
      Serial2.print(F("-"));
      Serial2.print(myGNSS.getMonth());
      Serial2.print(F("-"));
      Serial2.print(myGNSS.getDay());
      Serial2.print(F(" "));
      Serial2.print(myGNSS.getHour()-5);
      Serial2.print(F(":"));
      Serial2.print(myGNSS.getMinute());
      Serial2.print(F(":"));
      Serial2.print(myGNSS.getSecond());
      Serial2.print(F(","));
      Serial2.print(myGNSS.getHeading());
      Serial2.print(F(","));
      Serial2.print(myGNSS.getGroundSpeed());
      Serial2.print(F(","));
      Serial2.print(myGNSS.getAltitudeMSL());
      Serial2.println();
    }
  }
  
  delay(500); // Wait for 1 second before sending the next message

}
