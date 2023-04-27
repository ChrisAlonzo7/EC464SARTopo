Project Hardware Report
This document provides a detailed description of the hardware used in our project. The hardware is responsible for tracking the live position, altitude, and direction of dogs trained for search and rescue missions. All sensors in the system report data to the Teensy 4.1 microcontroller, which serves as the brains of the project. The Teensy is responsible for sending information over Bluetooth to a mobile device with our app installed. The hardware also includes a rechargeable lithium-ion battery, a GPS module, an accelerometer, an LED, and a Bluetooth module.

Hardware Components
Teensy 4.1 Microcontroller
The Teensy 4.1 microcontroller serves as the central processing unit of our project. It is capable of powering all of the other devices in the system. The Teensy receives data from the GPS module and accelerometer and sends it over Bluetooth to a mobile device with our app installed.

Sparkfun MAX-M10S GPS Module
The Sparkfun MAX-M10S GPS module tracks the live position, altitude, and direction of the device. The module requires a separate antenna to function properly. We used a coaxial port with a Taoglas TG.08 antenna, as it was small, visible, and GPS-capable.

Adafruit ADXL 345 Accelerometer
The Adafruit ADXL 345 accelerometer is responsible for detecting when a trained dog is sitting. Dogs are trained to sit when they have found something, so the accelerometer's job is to detect that motion.

Adafruit NeoPixel LED
The Adafruit NeoPixel LED shines through the case to make the device easy to find in the dark.

HC-05 Bluetooth Module
The HC-05 Bluetooth module transmits data from the Teensy to a mobile device with our app installed. Currently, the HC-05 module only works with Android devices, but an HC-10 module is needed to connect to iOS devices.

PCB Board
All of the sensors and microcontrollers are soldered onto a PCB board, with wiring for all modules connected to specific pins on the Teensy. The circuit diagram shows the exact connections between the modules and the Teensy.

Rechargeable Lithium-Ion Battery
We are using a 1,800 mAh rechargeable lithium-ion battery to power the device. A splitter board is used to charge the battery and power the Teensy. The positive and ground cables from the battery are soldered onto the splitter board, while a stripped micro USB cable is used for the other two pins on the splitter board. The micro USB cable is permanently plugged into the Teensy, while the splitter board has a USB port for charging.

Assembly
Case
The case has three holes for the GPS antenna to stick out, a hole for the LED light to shine through, and a hole for the USB-C charging port. After the PCB has been positioned correctly into the case, each hole is sealed with silicone sealant to ensure waterproof protection. Finally, the silicone sealant is used to seal the lid on the case for it to be ready to go in action.

PCB
The Teensy and sensor modules are soldered on the top portion of the PCB, while all of the wires connecting everything are soldered underneath the PCB to keep it organized.
