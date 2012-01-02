// Pete Sekan 
// https://github.com/PDXIII/TMN_EMailClient
// based on a tutorial by
// Daniel Shiffman 
// http://www.shiffman.net/2007/11/13/e-mail-processing/            
 
// Simple E-mail Checking        
// This code requires the Java mail library
// smtp.jar, pop3.jar, mailapi.jar, imap.jar, activation.jar
// Download:// http://java.sun.com/products/javamail/

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Comparator;

import controlP5.*;
import org.json.*;

// GUI Stuf from ControlP5
ControlP5 controlP5;
DropdownList mailDDL;
DropdownList sortDDL;
Textarea textArea;

DateFormat dateFormat = DateFormat.getDateInstance();

TMNMailManager mailManager;
TMNMailManager currentMailManager;

String []incoming = new String [4]; 
String mailAcc;
String password;
String imapHost;
String imapPort;

void setup() {
	size(1000, 600);
	try{
		incoming = loadStrings("private.txt");
		mailAcc = incoming[0];
		password = incoming[1];
		imapHost = incoming[2];
		imapPort = incoming[3];
	
	}catch(Exception e){
		String[] yourPrivate = new String[5];
		yourPrivate[0] = "insert your email-adress here";
		yourPrivate[1] = "insert your password here";
		yourPrivate[2] = "insert your imap-server here";
		yourPrivate[3] = "insert your port here";
		
		saveStrings("./data/private.txt", yourPrivate);
		
		println("A private.txt file was created in your data folder \n please insert your parameters!");
		exit();
	}
	  	
	controlP5 = new ControlP5(this);
		
	mailManager = new TMNMailManager();
	currentMailManager = new TMNMailManager();
	// Function to check mail
	parseFromJSON();

	initGUI();
}

void draw() {
	background(128);
	
	view01();
}

// GUI

void initGUI(){
	textArea = controlP5.addTextarea(
	"messageText", 
	"EMPTY\n"+
	"We will display the Messagetext here.\n"+
	"Please, choose an Email from the Droplist", 
	100, 100, 200, 200);
	controlP5.addButton("onlineCheck",0,100,65,100,15);
	
	mailDDL = controlP5.addDropdownList("Mails", 100, 100, 200, 200);
	customizeMailDDL(mailDDL);
	sortDDL = controlP5.addDropdownList("Sort", 310, 100, 200, 200);
	customizeSortDDL(sortDDL);
}

void redrawGUI(){
	mailDDL.clear();
	customizeMailDDL(mailDDL);
}

void customizeMailDDL(DropdownList ddl) {
	ddl.setBackgroundColor(color(190));
	ddl.setItemHeight(15);
	ddl.setBarHeight(15);
	ddl.captionLabel().style().marginTop = 3;
	ddl.captionLabel().style().marginLeft = 3;
	ddl.valueLabel().style().marginTop = 3;
	ddl.valueLabel().style().marginLeft = 3;
	
	ddl.captionLabel().set("Choose a Mail");
	
	ddl.setColorBackground(color(60));
	ddl.setColorActive(color(255, 128));
	
	for (int i=0;i< mailManager.getCount();i++) {
		
		TMNMail currentTMNMail = mailManager.getMailAt(i);
		String thisLabel = currentTMNMail.getShortFrom();
		String buttonLabel = thisLabel;
		ddl.addItem(buttonLabel, i);
	}

}

void customizeSortDDL(DropdownList ddl) {
	ddl.setBackgroundColor(color(190));
	ddl.setItemHeight(15);
	ddl.setBarHeight(15);
	ddl.captionLabel().style().marginTop = 3;
	ddl.captionLabel().style().marginLeft = 3;
	ddl.valueLabel().style().marginTop = 3;
	ddl.valueLabel().style().marginLeft = 3;
	
	ddl.captionLabel().set("Sort Mails by");
	
	ddl.setColorBackground(color(60));
	ddl.setColorActive(color(255, 128));
	
	ddl.addItem("From", 0);
	ddl.addItem("Size", 1);
	ddl.addItem("Size reverse", 2);

}


void controlEvent(ControlEvent theEvent) {
	// PulldownMenu is if type ControlGroup.
	// A controlEvent will be triggered from within the ControlGroup.
	// therefore you need to check the originator of the Event with
	// if (theEvent.isGroup())
	// to avoid an error message from controlP5.
	
	if (theEvent.isGroup()) {
		// check if the Event was triggered from a ControlGroup
		
		if(theEvent.group().name() == "Mails"){
			println("groupEvent");
			int i = round(theEvent.group().value());
			TMNMail currentTMNMail = mailManager.getMailAt(i);
			String message = dateFormat.format(currentTMNMail.getSentDate());
			message = message +"\n"+ currentTMNMail.getMessage();
			textArea.setText(message);
		}
		
		if(theEvent.group().name() == "Sort"){
			println("groupEvent");
			int i = round(theEvent.group().value());
			
			if(i == 0){
				thread("sortByFrom");			
			}
			
			if(i == 1){
				thread("sortBySize");
			}
			
			if(i == 2){
				thread("sortBySizeReverse");			
			}
		}
	} 
	else if (theEvent.isController()) {
		println("NoGroupEvent");
		
		int i = round(theEvent.controller().value());
		TMNMail currentTMNMail = mailManager.getMailAt(i);
		String message = dateFormat.format(currentTMNMail.getSentDate());
		message = message +"\n"+ currentTMNMail.getMessage();
		textArea.setText(message);
	}
}
public void onlineCheck() {
	println("a button event from onlineCheck: ");
	thread("checkMailsOnline");
}

public void view01(){

	noStroke();
	fill(255);

	for(int i = 0; i < mailManager.getCount();i++){
	
		TMNMail currentMail = mailManager.getMailAt(i);
		float xStep = width / mailManager.getCount();
		float xPos = i * xStep;
		float yPos = 10; 
		float xSize = 2;
		float ySize = currentMail.getSize()/20;
		rect(xPos, yPos, xSize, ySize);
	}
}

public void sortByFrom(){
	mailManager.sortByShortFrom();
	redrawGUI();
}

public void sortBySize(){
	mailManager.sortBySize();
	redrawGUI();
}

public void sortBySizeReverse(){
	mailManager.sortBySizeReverse();
	redrawGUI();
}
