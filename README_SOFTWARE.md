# Software Report

The hardware components of the project were all programmed with Arduino. All low-level code to control sensors was combined into a single file flashed to the Teensy 4.1. This file is named “Working Bluetooth sending Accelerometer.ino” and can be found by following the path “/Bluetooth/Working Bluetooth sending Accelerometer/Working Bluetooth sending Accelerometer.ino” in the main repository branch. All code was run and tested in the Arduino IDE 2.0.3.

## SparkFun GPS MAX-M10S module

For the Sparkfun GPS MAX-M10S module, we used the SparkFun_u-blox_GNSS_v3 Library created by SparkFun Electronics version 3.0.6. The code for the GPS module logged the position coordinates and packaged them into an easy to read string for the app to parse and use later. The SparkFun GPS MAX-M10S module is a low-cost and high-performance GPS module that can track multiple satellite systems. It has a compact size and is easy to integrate into a wide range of applications.

## Adafruit NeoPixel LED

For the Adafruit NeoPixel LED, we used the Adafruit_NeoPixel library created by Adafruit on version 1.11.0 to control things like the brightness and custom colors on the LED with simple function calls provided by the library. The Adafruit NeoPixel LED is a bright, colorful LED that can be controlled with a simple protocol. It is easy to use and can be used in a wide range of applications.

## Adafruit ADXL 345 accelerometer

For the Adafruit ADXL 345 accelerometer, we used the Adafruit_ADXL345_U library created by Adafruit on version 1.3.1 to easily read the voltage feedback from the accelerometer into acceleration data without having to create any algorithms or equations ourselves. This library allowed us to get the acceleration data with just one function provided by the library. We did however have to create our own algorithm with the acceleration data to detect if the dog is sitting or not. The algorithm will detect the dog is sitting if the negative y-axis acceleration is greater than 3 m/s^2 for more than 1 second. Since this measurement is in a loop that is delayed by 500ms that means it could take up to 1.49 seconds for the algorithm to detect the dog is sitting in the worst-case scenario and 1 second in the best-case scenario since it has to complete two loops to determine a sitting position. The flag that we created to indicate the dog is sitting can be reset at any 500ms interval if the negative y-axis acceleration passes the vector threshold of 1 m/s^2. The Adafruit ADXL 345 accelerometer is a small, low-power, 3-axis accelerometer that can measure acceleration up to +/-16g. It is easy to use and can be used in a wide range of applications.

## HC-05 Bluetooth module

Finally, we use the Wire library that is built into version 2.0.3 of the Arduino IDE to create more than one Serial connection so we could send data with our HC-05 Bluetooth monitor while printing to the serial console at the same time what we are sending. This was very helpful for testing and troubleshooting the code. The HC-05 Bluetooth module is a Bluetooth serial adapter that can be used to establish a wireless connection between two devices. It is easy to use and can be used in a wide range of applications.

## Adafruit_Sensor library

We also used the Adafruit_Sensor library, which is also built into the Arduino IDE version we were using, to easily recognize Adafruit devices connected to our Teensy. The Adafruit_Sensor library is a unified sensor abstraction layer that can be used with multiple sensors. It provides a common interface for accessing sensor data and can be used with a wide range of sensors.

## Mobile Application

Created using Flutter
