# Hardware Report

## Overview

In this project, we are using a Teensy 4.1 microcontroller as the central processing unit for the system. All sensors in the system will report data to the Teensy, which will then send the information over Bluetooth to a mobile device with our app installed. The system comprises a Sparkfun MAX-M10S GPS module, an Adafruit ADXL 345 accelerometer, an Adafruit NeoPixel LED, and an HC-05 Bluetooth module.

## Teensy 4.1 Microcontroller

The Teensy 4.1 microcontroller is the heart of the system. It has a powerful 600 MHz ARM Cortex-M7 processor, which is capable of running complex algorithms and processing large amounts of data in real-time. The Teensy 4.1 has a wide range of digital and analog input/output pins, making it highly versatile for interfacing with other components in the system. The Teensy 4.1 is also capable of powering every sensor module we are using on its own thanks to having both a 5V and 3.3V power pin.

## Sparkfun MAX-M10S GPS Module

The Sparkfun MAX-M10S GPS module is used to track the live position, altitude, and direction of the device. The GPS module communicates with the Teensy via serial communication. The GPS module requires a separate antenna to work. There are a couple of options for the antenna, there is a port on the module with a connector for antennas specifically designed to work with that specific GPS module and also a coaxial port. We ended up using the coaxial port with a Taoglas TG.08 antenna since this antenna was small, visible with the bright orange, and was GPS capable. 

## Adafruit ADXL 345 Accelerometer

The Adafruit ADXL 345 accelerometer is a small, accurate, and easy-to-program sensor that measures acceleration in three axes. The accelerometer is used to detect when the dog is sitting, as this would indicate if the dog has found something, as dogs are trained to sit when they have found something. The accelerometer communicates with the Teensy via I2C protocol.

## Adafruit NeoPixel LED

The Adafruit NeoPixel LED is used to shine through the case so the device is easy to find in the dark. The LED is a WS2812B RGB LED, which means it can display any color by mixing red, green, and blue light. The LED communicates with the Teensy via digital output.

## HC-05 Bluetooth Module

The HC-05 Bluetooth module is responsible for transmitting the data that is being reported to the Teensy to our mobile application on any device. It uses the Serial Port Profile (SPP) protocol to communicate with the Teensy via serial communication. However, this module only works for Android right now, as iPhones or other IOS devices can't connect to an HC-05 module. To be able to connect to both IOS and Android, you would need an HC-10 module.

## PCB
![20230406_150227 (1)](https://user-images.githubusercontent.com/81998891/234969878-014bf317-cabe-443b-9315-975827e889d2.jpg)

![20230406_150233 (1)](https://user-images.githubusercontent.com/81998891/234969929-b88a3a39-3b3a-40bb-b902-e92c9421b3f8.jpg)

All of the sensors and microcontrollers are soldered onto a PCB board. The PCB is designed to allow all of the modules to connect to the exact pins on the Teensy. The Teensy and sensor modules are soldered on the top portion, while all of the wires connecting everything are soldered underneath the PCB to keep it organized.

 
![Circuit Diagram (1)](https://user-images.githubusercontent.com/81998891/235005497-c5bf56a6-1cec-41bf-ad81-06e6aa1bc374.jpg)

Here the circuit diagram shows the wiring for all the modules underneath the PCB.


## Power

To power everything, we are using a 1,800 mAh rechargeable lithium-ion battery. The battery is charged using a splitter board that does all the circuitry for us. We have stripped the ends of the two wires (positive and ground) from the battery and soldered them onto the correct pins of the splitter board. For the other two pins on the splitter board, we have a stripped micro USB cable using only the power cables (red and black) and soldered those to the other two pins. The micro USB cable is permanently plugged into the Teensy, while the splitter board has a USB-C port for charging. So the only cable the end-user will ever need is a USB-C cable.

## Case

The case has three holes for the GPS antenna to stick out, a hole for the LED light to shine through, and a hole for the USB-C charging port. After the PCB has been positioned correctly into the case, each hole is sealed with silicone sealant to ensure waterproof protection. Finally, the silicone sealant is used to seal the lid on the case for it to be ready to go in action.

