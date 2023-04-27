# Engineering Addendum: Continuing SARTopo Tracking Canine Collar Project

Dear Future Team,

Congratulations on taking on the project that we worked on! We hope that our experiences and knowledge will be of help to you as you move forward with the project. We have learned a lot about the challenges that come with this project, particularly with the radios, microprocessors, and GPS connections.

## Radios
The most challenging part of our project was definitely the radios. We encountered a lot of difficulties in finding the right radios to use, particularly because many of the radios we wanted to use were on back order for a long time. We recommend that you do extensive research on the radios and order them well in advanced before the implementation process starts. One exapmle of a radio that we were thinking of using but couldn't get ahold of was the Digi XBee-Pro 900H. It is also important to make sure that the radio you choose can communicate with both IOS and Android devices. One mistake that we made was choosing a Bluetooth module HC-05 that only worked for Androids and we ended up later having to switch to the HC-10 so that we could hav compatibility for both IOS and Android. So, make sure that the radio you choose will work on both types of devices.

Getting the radios to work between each other to send data was actually pretty simple, but the final step of getting the data from the receiving radio to our app was very challenging. This entails a lot of research to find a solution of how to do this, especially if you want it to work on both IOS and Android devices. We recommend that you spend some time researching this and find a solution that will work best for your project.

## Microprocessors
It is important to heavily research the microprocessor that you are going to be using as it can save you a lot of time in the long run. We made a mistake by not doing enough research on the microcontroller we were using. We just did basic research to find the microcontroller that would work, rather than finding the best one for the job. We originally used Teensy 4.1s which led to countless hours of headbanging trying to get an extra Bluetooth module to work, soldered, and wired. When in turn, if we had spent a little more time on the research side of things, we could have just started with using the Arduino BLE which has Bluetooth built-in, saving much more time when it came to actually implementing the devices.

## GPS Connections
Getting a GPS connection was also difficult for us. We were never able to get a GPS antenna that could connect to a satellite inside. We always needed a direct line of sight outside for up to 5 minutes sometimes when it was cloudy. There was definitely more research to be done on the GPS antennas, and this is an area where you can improve. We recommend that you thoroughly research what is out there for coaxial GPS antennas. Finding an antenna that will allow you to test indoors will make your lives a lot easier. This wasn’t too big of a concern for us only because we knew that this device is always going to be used outside with a direct line of sight of the sky and it was not a requirement from our customer.

## App
The app we developed to accompany the hardware focused primarily on functionality, rather than user experience. While it was important for the app to be able to display key data received from the hardware, we did not put as much time into making the user interface look very clean and inviting. We recommend that future teams spend more time on designing a user-friendly interface for the app. By doing so, it will not only make it more visually appealing, but it will also make the app more intuitive to use for end-users. This will ultimately improve the overall experience for the end-user and make it easier for them to interact with the hardware.

## Conclusion
We hope that this addendum will be of help to you as you continue with the project. Remember that extensive research is key to finding the right parts and solutions for the project. The software should come easy if you choose the 'best' hardware for the job rather than the hardware that 'can' do the job. We wish you the best of luck in continuing with the project and hope that it will be a success!

Best regards,
Ayrton Reulet, Cristopher Alonzo, Aanya Kutty, Ahsan Ragib
