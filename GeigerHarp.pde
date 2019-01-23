import processing.funnel.*;

import processing.serial.*;
Serial serialPort;


Arduino arduino;
Pin servoPin;

boolean flag = true; 
int waiting = 0;

void setup() {
 size(200, 200);

 println(Serial.list());

 serialPort = new Serial(this, Serial.list()[0], 9600);
 serialPort.clear();

 Configuration config = Arduino.FIRMATA;
 config.setDigitalPinMode(9, Arduino.SERVO);
 arduino = new Arduino(this, config);
 servoPin = arduino.digitalPin(9);
}

void draw() {
 background(255);

 while (serialPort.available() > 0) {
   int inChar = serialPort.read();
   if (inChar == '0' || inChar == '1') {
     if (waiting==0) {
       trigger();
       waiting++;
     }
   }
   serialPort.clear();
 }

 if (waiting>0 && waiting<30) {
   waiting++;
 } else {
   waiting=0;
 }

}

void trigger() {
//  println("trigger"); 

 flag = !flag;
 if (flag) {
   servoPin.value = 30.0/255.0;
 } else {
   servoPin.value = 90.0/255.0;
 }
}
