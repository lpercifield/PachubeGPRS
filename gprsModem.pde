
void configModem(){
  
  int reps = 0;
   config_start:
   reps++;
   if(reps>3){
     powerOff();
   }
   if(!power){
    powerOn();
  }
  Serial.println("Turn on GPRS Modem and wait for 1 minute.");
  Serial.println("and then press a key");
  Serial.println("Press c for power on configuration");
  Serial.println("press any other key for uploading");
  Serial.flush();
  //while(Serial.available() == 0);
//  if(Serial.read()=='c')
//  {

    Serial.println("Executing AT Commands for one time power on configuration");
 GPRS_Serial.flush();
 
 
 
    GPRS_Serial.println("ATE0"); //Command echo off
    Serial.println("ATE0   Sent");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto config_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
 
 
 
 
 
    GPRS_Serial.println("AT+CIPMUX=0"); //We only want a single IP Connection at a time.
    Serial.println("AT+CIPMUX=0   Sent");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto config_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
 
 
 
 
 
    GPRS_Serial.println("AT+CIPMODE=0"); //Selecting "Normal Mode" and NOT "Transparent Mode" as the TCP/IP Application Mode
    Serial.println("AT+CIPMODE=0    Sent!");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto config_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
 
 
 
 
 
    GPRS_Serial.println("AT+CGDCONT=1,\"IP\""); //Defining the Packet Data
    //GPRS_Serial.println("AT+CGDCONT=1,\"IP\",\"wap.cingular\",\"0.0.0.0\",0,0"); //Defining the Packet Data
    //GPRS_Serial.println("AT+CGDCONT=1,\"IP\",\"wap.cingular\",\"\",0,0"); //Defining the Packet Data
//Protocol Context - i.e. the Protocol Type, Access Point Name and IP Address
    Serial.println("AT+CGDCONT=1,\"IP\",\"wap.cingular\",\"10.6.6.6\",0,0   Sent!");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto config_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
 
 
 
 
 
    GPRS_Serial.println("AT+CSTT=\"wap.cingular\""); //Start Task and set Access Point Name (and username and password if any)
    //GPRS_Serial.println("AT+CSTT=\"wap.cingular\"WAP@CINGULARGPRS.COM\",\"CINGULAR1"); //Start Task and set Access Point Name (and username and password if any)
    //Serial.println("AT+CSTT=\"wap.cingular\"WAP@CINGULARGPRS.COM\",\"CINGULAR1   Sent!");
    Serial.println("AT+CSTT=\"wap.cingular\"");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto config_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
 
 
 
 
 
    GPRS_Serial.println("AT+CIPSHUT"); //Close any GPRS Connection if open
    Serial.println("AT+CIPSHUT  Sent!");
    if(GPRS_Serial_wait_for_bytes(7,10) == 0)
    {  
      Serial.println("Timeout");
      goto config_start;
    }
    else
    {
      Serial.print("Received:");
      config = true;
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 }
 int sendToPachube(int value1, int value2){
   retries=0;
  loop_start:
  if(retries>0){
    configModem();
  }
Serial.println("LOOP START");
GPRS_Serial.flush();
retries++;
if(retries<3){
   GPRS_Serial.println("AT+CIPSTART=\"TCP\",\"api.pachube.com\",\"80\""); //Open a connection to Pachube.com
  Serial.println("AT+CIPSTART=\"TCP\",\"api.pachube.com\",\"80\"  Sent!");
  if(GPRS_Serial_wait_for_bytes(12,255) == 0)
  {  
    Serial.println("Timeout");
    goto loop_start;
  }
  else
  {
    Serial.print("Received:");
    while(GPRS_Serial.available()!=0)
    {
      Serial.print((unsigned char)GPRS_Serial.read());
      Serial.print("\n");
    }
  }
 
  GPRS_Serial.flush();
  GPRS_Serial.println("AT+CIPSEND"); //Start data through TCP connection
  Serial.println("AT+CIPSEND  Sent!");
  if(GPRS_Serial_wait_for_bytes(1,100) == 0)
  {  
    Serial.println("Timeout");
    goto loop_start;
  }
  else
  {
    Serial.print("Received:");
    while(GPRS_Serial.available()!=0)
    {
      Serial.print((unsigned char)GPRS_Serial.read());
      Serial.print("\n");
    }
  }
 
 
  GPRS_Serial.flush();
 
    //Emulate HTTP and use PUT command to upload temperature datapoint using Comma Seperate Value Method
  GPRS_Serial.print("PUT /v2/feeds/"+feedId+".csv HTTP/1.1\r\n");
  Serial.println("PUT /v2/feeds/"+feedId+".csv HTTP/1.1  Sent!");
  delay(300);
 
  GPRS_Serial.print("Host: api.pachube.com\r\n"); 
  Serial.println("Host: api.pachube.com  Sent!");
  delay(300);
 
  GPRS_Serial.print("X-PachubeApiKey: "+apiKey+"\r\n"); //REPLACE THIS KEY WITH YOUR OWN PACHUBE API KEY
  Serial.println("X-PachubeApiKey: "+apiKey+"  Sent!"); //REPLACE THIS KEY WITH YOUR OWN PACHUBE API KEY
  delay(300);
 
  GPRS_Serial.print("Content-Length: 12\r\n"); 
  Serial.print("Content-Length: 12  Sent!"); 
  delay(300);
 
  GPRS_Serial.print("Connection: close\r\n\r\n"); 
  Serial.print("Connection: close  Sent!"); 
  delay(300);
//  items = items -1;
//  for(int i =0;i<items;i++){
//    GPRS_Serial.print(dataStreams[i]);
//    GPRS_Serial.print(",");
//    delay(300);
//    GPRS_Serial.print(values[i]);
//    delay(300);
//    GPRS_Serial.print("\r\n"); 
//  }
  GPRS_Serial.print("a,"); //You may replace the stream name "TMP102" to any other string that you have choosen.
  delay(300);
  GPRS_Serial.print(value1); 
  delay(300);
  GPRS_Serial.print("\r\n"); 
  delay(300);
  GPRS_Serial.print("b,"); //You may replace the stream name "TMP102" to any other string that you have choosen.
  delay(300);
  GPRS_Serial.print(value2); 
  delay(300);
  GPRS_Serial.print("\r\n"); 
  delay(300);
  GPRS_Serial.print("\r\n"); 
  delay(300);
  GPRS_Serial.print(0x1A,BYTE);
  //GPRS_Serial.print(end_c);
  delay(300); //Send End Of Line Character to send all the data and close connection
  if(GPRS_Serial_wait_for_bytes(20,255) == 0)
  {  
    Serial.println("Timeout");
    goto loop_start;
  }
  else
  {
    Serial.print("Received:");
    while(GPRS_Serial.available()!=0)
    {
      Serial.print((unsigned char)GPRS_Serial.read());
      Serial.print("\n");
    }
  }
 
 
 
 
  GPRS_Serial.flush();
  GPRS_Serial.println("AT+CIPSHUT"); //Close the GPRS Connection
  Serial.println("AT+CIPSHUT  Sent!");
  if(GPRS_Serial_wait_for_bytes(4,100) == 0)
  {  
    Serial.println("Timeout");
    goto loop_start;
  }
  else
  {
    Serial.print("Received:");
    config = false;
    powerOff();
    return 1;
    while(GPRS_Serial.available()!=0)
    {
      Serial.print((unsigned char)GPRS_Serial.read());
      Serial.print("\n");
    }
  }
}else{
  config = false;
  powerOff();
  return -1;
}
 }
 char GPRS_Serial_wait_for_bytes(char no_of_bytes, int timeout)
{
  while(GPRS_Serial.available() < no_of_bytes)
  {
    delay(200);
    timeout-=1;
    if(timeout == 0)
    {
      return 0;
    }
  }
  return 1;
}
void powerOn(){
  delay(1000);
  pinMode(9, OUTPUT); 
   digitalWrite(9,LOW);
 delay(1000);
 digitalWrite(9,HIGH);
 delay(2500);
 digitalWrite(9,LOW);
 delay(15500);
 power = true;
}
void powerOff(){
  delay(1000);
  pinMode(9, OUTPUT); 
   digitalWrite(9,LOW);
 delay(1000);
 digitalWrite(9,HIGH);
 delay(2500);
 digitalWrite(9,LOW);
 power = false;
 //delay(10500);
}
