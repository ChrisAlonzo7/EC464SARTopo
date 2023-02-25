#include <Wire.h>

#define ADXL345_ADDRESS 0x53
#define ADXL345_TO_READ 6

byte buff[ADXL345_TO_READ];
char str[512];

float X, Y, Z;
int counter = 0;
void setup() {
  Wire.begin();
  Serial.begin(9600);

  writeTo(ADXL345_ADDRESS, 0x2D, 0);      
  writeTo(ADXL345_ADDRESS, 0x2D, 16);      
  writeTo(ADXL345_ADDRESS, 0x2D, 8);      
}

void loop() {
  readFrom(ADXL345_ADDRESS, 0x32, ADXL345_TO_READ, buff); 

  X = ((int16_t)(buff[1]<<8)|buff[0])/256.0; 
  Y = ((int16_t)(buff[3]<<8)|buff[2])/256.0;
  Z = ((int16_t)(buff[5]<<8)|buff[4])/256.0;

  // subtract the inaccuracy so that they are 0 ****** Not Finished
  X = X * 9.81;
  Y = Y * 9.81;
  Z = (Z * 9.81) - 9.31;

    Serial.print(counter);
    Serial.print(" - X: ");
    Serial.print(X);
    Serial.print(", Y: ");
    Serial.print(Y);
    Serial.print(", Z: ");
    Serial.println(Z);


  counter = counter + 1;
  delay(100);  
}

void writeTo(int device, byte address, byte val) {
  Wire.beginTransmission(device); 
  Wire.write(address);            
  Wire.write(val);                
  Wire.endTransmission();         
}

void readFrom(int device, byte address, int num, byte buff[]) {
  Wire.beginTransmission(device); 
  Wire.write(address);            
  Wire.endTransmission();         

  Wire.beginTransmission(device); 
  Wire.requestFrom(device, num);  

  for(int i = 0; i < num; i++) {
    buff[i] = Wire.read();        
  }
  
  Wire.endTransmission();         
}