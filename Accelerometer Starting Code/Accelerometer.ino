#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_MMA8451.h>
#include <RTClib.h>

RTC_DS1307 rtc; // create an instance of the RTC_DS1307 class
Adafruit_MMA8451 accel = Adafruit_MMA8451();
int sitThreshold = 100; // adjust this threshold to suit your needs

void setup() {
  Wire.begin();
  Serial.begin(9600);
  
  if (!accel.begin()) {
    Serial.println("Failed to initialize accelerometer");
    while (1);
  }
  
  accel.setRange(MMA8451_RANGE_2_G);
  accel.setDataRate(MMA8451_DATARATE_800_HZ);
  
  if (!rtc.begin()) {
    Serial.println("Failed to initialize RTC");
    while (1);
  }
  
  if (!rtc.isrunning()) {
    Serial.println("RTC is not running, setting time...");
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__))); // set RTC time to compile time
  }
}

void loop() {
  sensors_event_t event;
  accel.getEvent(&event);
  
  // calculate the magnitude of acceleration
  float magnitude = sqrt(pow(event.acceleration.x, 2) + pow(event.acceleration.y, 2) + pow(event.acceleration.z, 2));
  
  // check if magnitude is below the sit threshold
  if (magnitude < sitThreshold) {
    Serial.print("sitting ");
    printTime();
  } else {
    Serial.print("moving ");
    printTime();
  }
  
  delay(1000); // wait 1 second before repeating the loop
}

void printTime() {
  DateTime now = rtc.now(); // get the current date and time from the RTC
  Serial.print(now.year(), DEC);
  Serial.print('/');
  Serial.print(now.month(), DEC);
  Serial.print('/');
  Serial.print(now.day(), DEC);
  Serial.print(' ');
  Serial.print(now.hour(), DEC);
  Serial.print(':');
  Serial.print(now.minute(), DEC);
  Serial.print(':');
  Serial.println(now.second(), DEC);
}
