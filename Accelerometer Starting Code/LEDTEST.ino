#include <Adafruit_NeoPixel.h>

#define LED_PIN_1 10
#define LED_PIN_2 10
#define LED_PIN_3 11
#define NUM_LEDS 3

Adafruit_NeoPixel strip_1(NUM_LEDS / 2, LED_PIN_1, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strip_2(NUM_LEDS / 2, LED_PIN_2, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strip_3(1, LED_PIN_3, NEO_GRB + NEO_KHZ800);

void setup() {
  strip_1.begin();
  strip_2.begin();
  strip_3.begin();
  strip_1.show(); // Initialize all pixels to "off"
  strip_2.show();
  strip_3.show();
}

void loop() {
  // Set all LEDs to red
  for (int i = 0; i < NUM_LEDS / 2; i++) {
    strip_1.setPixelColor(i, strip_1.Color(255, 0, 0));
    strip_2.setPixelColor(i, strip_2.Color(255, 0, 0));
  }
  strip_3.setPixelColor(0, strip_3.Color(255, 0, 0));
  
  strip_1.show(); // Update the first LED strip with the new colors
  strip_2.show(); // Update the second LED strip with the new colors
  strip_3.show(); // Update the third LED strip with the new colors
  
  delay(1000); // Wait for one second before repeating
}
