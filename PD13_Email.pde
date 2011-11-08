// Daniel Shiffman               
// http://www.shiffman.net       

// Simple E-mail Checking        
// This code requires the Java mail library
// smtp.jar, pop3.jar, mailapi.jar, imap.jar, activation.jar
// Download:// http://java.sun.com/products/javamail/

import javax.mail.*;
import javax.mail.internet.*;

import controlP5.*;

ControlP5 controlP5;
DropdownList dropDownList;
Textarea textArea;

PD13MailManager allPD13Mails;

String []incoming = new String [5]; 
String mailAcc;
String password;
String imapHost;
String imapPort;
String mailRecipient;


void setup() {
  size(400, 400);

 incoming = loadStrings("private.txt");
  mailAcc = incoming[0];
  password = incoming[1];
  imapHost = incoming[2];
  imapPort = incoming[3];
  mailRecipient = incoming[4];  

  controlP5 = new ControlP5(this);

  allPD13Mails = new PD13MailManager();
  // Function to check mail
  checkMail();

  allPD13Mails.printInfo();
  // Function to send mail
  // doesn't work
  //sendMail();

  textArea = controlP5.addTextarea(
  "messageText", 
  "EMPTY\n"+
    "We will display the Messagetext here.\n"+
    "Please, choose an Email from the Droplist", 
  100, 100, 200, 200);

  dropDownList = controlP5.addDropdownList("Mails", 100, 100, 200, 120);
  customize(dropDownList);
}

void draw() {
  background(128);
}

void customize(DropdownList ddl) {
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.captionLabel().set("Choose a Mail");
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  for (int i=0;i< allPD13Mails.getCount();i++) {

    PD13Mail currentPD13Mail = allPD13Mails.getMailAt(i);
    String shortFrom = currentPD13Mail.getShortFrom();
    ddl.addItem(shortFrom, i);
  }
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void controlEvent(ControlEvent theEvent) {
  // PulldownMenu is if type ControlGroup.
  // A controlEvent will be triggered from within the ControlGroup.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message from controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup

      int i = round(theEvent.group().value());
    PD13Mail currentPD13Mail = allPD13Mails.getMailAt(i);
    String message = currentPD13Mail.getMessage();
    textArea.setText(message);
  } 
  else if (theEvent.isController()) {

    int i = round(theEvent.controller().value());
    PD13Mail currentPD13Mail = allPD13Mails.getMailAt(i);
    String message = currentPD13Mail.getMessage();
    textArea.setText(message);
  }
}

