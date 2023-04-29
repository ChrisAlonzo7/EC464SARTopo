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

The mobile application for this project was created using the Flutter framework with the Dart programming language. The application was developed with Flutter version 3.7. The application allows the user to connect to the HC-05 Bluetooth module and receive data from the Arduino sensors. The application is designed to work on both Android and iOS platforms.

### Dependencies

The following dependencies were used in the Flutter application:

- `file_picker: 4.2.3`
- `path_provider: 2.0.8`
- `logger: 1.0.0`
- `gpx: 2.2.1`
- `http: 0.13.3`
- `filesystem_picker: 3.0.0`
- `intl: 0.17.0`
- `flutter_bluetooth_serial: 0.4.0`
- `permission_handler: 10.2.0`
- `audioplayers: 0.20.1`
- `latlong2: 0.8.0`

### Testing

Initially, the application was tested on an emulated Google Pixel 3a running Android 10 (API Level 29) with Android SDK. However, once Bluetooth functionality was implemented, the testing was shifted to a real life physical Samsung Galaxy S10 smartphone. The application was installed and run directly from Visual Studio Code Playground on the smartphone.

To test the application with the physical HC-05 Bluetooth module, the module was paired with the smartphone and is named by default "HC-05", and we did not change the default name, in the device settings (outside of the application). Once the module was paired, you can connect to the Bluetooth module at anytime from within the app settings.

### Functionality

The hardware device will send a string of data via Bluetooth to the application. The string will contain information from all the sensors, including GPS data such as position coordinates, altitude, and time. The application will parse through this string to extract the necessary data from each sensor. Once the data has been extracted, it will be packaged as JSON data and saved into a .GPX file with the press of a button on our application. This data can now be uploaded to a remote SARTopo server and sent over HTTP to the SARTopo endpoint.

SARTopo is a mapping software used by search and rescue teams, which can display the live position of the canine. By sending the GPS data to the SARTopo endpoint (configurable in the app settings), the map will be able to display the live position of the dog, allowing the search and rescue team to track its movements in real-time.

In addition to the GPS data, the hardware device will also send the accelerometer data to the application. The accelerometer data will have already been processed and calculated by the Teensy in the hardware device. The accelerometer data will simply be a sitting or not sitting message. If the app receives a sitting message, it will display a message on our app indicating that the dog is sitting. The message will stop appearing once the app receives a not sitting message from the hardware.

Overall, the application will receive data from the hardware device via Bluetooth, parse through the data to extract the necessary information from each sensor, package the data as JSON, and send it over HTTP to the SARTopo endpoint. The app will also receive the accelerometer data and display a message if the dog is sitting.
