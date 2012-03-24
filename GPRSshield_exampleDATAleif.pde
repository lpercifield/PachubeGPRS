//Remember when using GPRS Shield with Seeeduino Stalker v2.0 
//please dismount the OK_READ Jumper (i.e. open it).
//This will disconnect the Battery Charger IC's OK pin from
//the microcontrollers Digital Pin 7 and hence allow unhindered
//communication with GPRS Shield using NewSoftSerial Library. 
 
 
//Replace the following items in the code:
//1. Replace the Access Point Name "TATA.DOCOMO.INTERNET" 
//and the DNS server name "10.6.6.6" in the AT+CGDCONT and AT+CSTT
//commands with those of your own service provider.
//
//2. Replace the Pachube API Key with your personal ones assigned
//to your account at pachube.com
//
//3. You may choose a different name for the the data stream.
//I have choosen "TMP102". If you use a different name, you will have
//to replace this string with the new name.
//
 
#include <NewSoftSerial.h>
//#include "tmp102.h"
//Please fetch tmp102.h and tmp102.cpp from "Stlker logger AM06 Serial.zip"
//available from Seeeduino Stalker v2.0's Wiki Page
#include <Wire.h>
 

 int retries=0;
float convertedtemp; // We then need to multiply our two bytes by a scaling factor, mentioned in the datasheet.
int tmp102_val; // an int is capable of storing two bytes, this is where we "chuck" the two bytes together.
boolean config = false;
boolean power = false;
NewSoftSerial GPRS_Serial(7, 8);
int value1 = 0;
int value2 = 0;
String feedId = "40167";
String apiKey = "rewjrtZS0MqOWG4R-j4EJ5u9yPYOvCwKUMuK8O_cwbk";
void setup()
{

  GPRS_Serial.begin(19200);  //GPRS Shield baud rate
  Serial.begin(19200);
  //tmp102_init();
 configModem();
}
 
void loop()
{ 
  //Serial.println("Press a key to read temperature and upload it");
  Serial.flush();
  //while(Serial.available() == 0);
  //if(Serial.read()=='a')
  //{
  //getTemp102();
  if(!config){
    configModem();
  }
  value1++;
  value2 = value1 +1;
  //char dataStreamNames[]={'a', 'b'};
  //int values[] = {value1,value2};
  //Serial.print("TMP102 Temperature = ");
  //Serial.println("87");
   if(sendToPachube(value1,value2)!=-1){
     Serial.println("WORKED");
   }else{
     Serial.println("FAILED");
   }
  //GPRS_Serial.println("AT+CIPSTART=\"TCP\",\"74.125.224.72\",\"80\""); //Open a connection to Pachube.com
  //Serial.println("AT+CIPSTART=\"TCP\",\"74.125.224.72\",\"80\"  Sent!");
  
  //}
  delay(60000);
}
 

