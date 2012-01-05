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

import controlP5.*;
import org.json.*;

// GUI Stuf from ControlP5
ControlP5 controlP5;
DropdownList mailDDL;
DropdownList sortDDL;
DropdownList visuDDL;
Textarea textArea;
String[] visualizations = {"Rectangle", "Circle", "Bezier", "Circulation"};
String[] sorting = {"From", "Size", "Size Reverse", "Time", "Time Reverse"};

String currentVisu = "Bezier";

DateFormat dateFormat = DateFormat.getDateInstance();

TMNMailManager mailManager;
TMNMailManager currentMailManager;

String []incoming = new String [4]; 
String mailAcc;
String password;
String imapHost;
String imapPort;

String jsonFile = "./data/allMails.json";

ArrayList fromList;
ArrayList subjectList;

void setup() {
	size(1024, 768);
	background(128);
	
	frameRate(25);
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
		
	mailManager = new TMNMailManager("Main");
	// Function to check mail
	parseFromJSON();

	fromList = new ArrayList();
	
	parseFromList();
	
	subjectList = new ArrayList();
	parseSubjectList();
	initGUI();
}

void draw() {
	
	background(128);
	smooth();
	mailManager.drawVisu(currentVisu);
	drawLinks();		
}

// GUI

void initGUI(){
	textArea = controlP5.addTextarea(
	"messageText", 
	"EMPTY\n"+
	"We will display the Messagetext here.\n"+
	"Please, choose an Email from the Droplist", 
	100, 100, 200, 200);
	controlP5.addButton("onlineCheck",0,100,65,95,15);
	controlP5.addButton("takeAPicture",0,205,65,95,15);
	
	mailDDL = controlP5.addDropdownList("Mails", 100, 100, 200, 200);
	customizeMailDDL(mailDDL);
	sortDDL = controlP5.addDropdownList("Sort", 310, 100, 95, 200);
	customizeSortDDL(sortDDL);
	visuDDL = controlP5.addDropdownList("Visu", 415, 100, 95, 200);
	customizeVisuDDL(visuDDL);

}

void redrawGUI(){
	
	controlP5.remove("Mails");
	// controlP5.remove("Sort");
	// 	controlP5.remove("Visu");
	
	mailDDL = controlP5.addDropdownList("Mails", 100, 100, 200, 200);
	customizeMailDDL(mailDDL);
	// 	sortDDL = controlP5.addDropdownList("Sort", 310, 100, 95, 200);
	// 	customizeSortDDL(sortDDL);
	// 	visuDDL = controlP5.addDropdownList("Visu", 415, 100, 95, 200);
	// 	customizeVisuDDL(visuDDL);
	
}

void customizeMailDDL(DropdownList ddl) {
	customizeDDL(ddl);
	
	ddl.captionLabel().set("Choose a Mail");
	
	ddl.setColorBackground(color(60));
	ddl.setColorActive(color(255, 128));
	
	for (int i=0;i< mailManager.getCount();i++) {
		
		TMNMailVisu currentTMNMail = mailManager.getMailAt(i);
		String thisLabel = currentTMNMail.getShortFrom();
		String buttonLabel = thisLabel;
		ddl.addItem(buttonLabel, i);
	}

}

void customizeSortDDL(DropdownList ddl) {
	customizeDDL(ddl);
	
	ddl.captionLabel().set("Sort Mails by");
	
	ddl.setColorBackground(color(60));
	ddl.setColorActive(color(255, 128));
	
	for(int i = 0; i< sorting.length;i++){
		ddl.addItem(sorting[i], i);
	}


}

void customizeVisuDDL(DropdownList ddl) {
	customizeDDL(ddl);
	
	ddl.captionLabel().set("Set Visualization");
	
	ddl.setColorBackground(color(60));
	ddl.setColorActive(color(255, 128));
	
	for(int i = 0; i< visualizations.length;i++){
		ddl.addItem(visualizations[i], i);
	}
}

DropdownList customizeDDL(DropdownList ddl){
	ddl.setBackgroundColor(color(190));
	ddl.setItemHeight(15);
	ddl.setBarHeight(15);
	ddl.captionLabel().style().marginTop = 3;
	ddl.captionLabel().style().marginLeft = 3;
	ddl.valueLabel().style().marginTop = 3;
	ddl.valueLabel().style().marginLeft = 3;
		
	return ddl;
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
			TMNMailVisu currentTMNMail = mailManager.getMailAt(i);
			String message = dateFormat.format(currentTMNMail.getSentDate());
			message = message +"\n"+ currentTMNMail.getMessage();
			textArea.setText(message);
		}
		
		if(theEvent.group().name() == "Sort"){
			println("groupEvent");
			println(theEvent.group().stringValue());			
			
			mailManager.sortBy(theEvent.group().stringValue(), currentVisu);
			redrawGUI();
			
		}
		
		if(theEvent.group().name() == "Visu"){
			println("groupEvent");
			println(theEvent.group().stringValue());			
			
			mailManager.drawVisu(theEvent.group().stringValue());
			currentVisu = theEvent.group().stringValue();
						
		}
	} 
	else if (theEvent.isController()) {
		println("NoGroupEvent");
		
		int i = round(theEvent.controller().value());
		TMNMailVisu currentTMNMail = mailManager.getMailAt(i);
		String message = dateFormat.format(currentTMNMail.getSentDate());
		message = message +"\n"+ currentTMNMail.getMessage();
		textArea.setText(message);
	}
	
}

void parseFromList(){

	for(int i = 0; i < mailManager.getCount(); i++){
		
		boolean bingo = false;
		
		// println(i);
		TMNMailVisu currentMail = mailManager.getMailAt(i);
		
		if(fromList.isEmpty()){
			
			TMNMailManager newMM = new TMNMailManager(currentMail.getShortFrom());
			fromList.add(newMM);
			
		}else{
			
			for(int j = 0; j < fromList.size(); j++){
				
				TMNMailManager currentMM = (TMNMailManager) fromList.get(j);
				// println("currentMailName " + currentMail.getShortFrom() +" / currentMMName "+ currentMM.getName());
				
				if(currentMail.getShortFrom().equals(currentMM.getName())){
					currentMM.add(currentMail);
					
					// println("Bingo!");
					bingo = true;					
				}
			}
			if(!bingo){
				TMNMailManager newMM = new TMNMailManager(currentMail.getShortFrom());
			    fromList.add(newMM);
			    // println(newMM.getName());
			}else{
				bingo = false;
			}
		}		
	}
	
	Comparator<TMNMailManager> comp = new ComparatorTMNMAilMByName();
    Collections.sort(fromList, comp);
	
	// set Color of the MailManagers in the fromList 
	for(int i = 0; i < fromList.size(); i++){
		TMNMailManager currentMM = (TMNMailManager) fromList.get(i);
		color currentColor = color((255/fromList.size()*i),255,255);
		currentMM.setColor(currentColor);
		currentMM.drawVisu("Color");
		println(currentMM.getName() + " " + currentColor);
	}
	// println("Array fromList contains: "+fromList.size());
}

void parseSubjectList(){

	for(int i = 0; i < mailManager.getCount(); i++){
		
		boolean bingo = false;
		
		// println(i);
		TMNMailVisu currentMail = mailManager.getMailAt(i);
		
		if(subjectList.isEmpty()){
			
			TMNMailManager newMM = new TMNMailManager(currentMail.getSubject());
			subjectList.add(newMM);
			
		}else{
			
			for(int j = 0; j < subjectList.size(); j++){
				
				TMNMailManager currentMM = (TMNMailManager) subjectList.get(j);
				// println("currentMailName " + currentMail.getShortFrom() +" / currentMMName "+ currentMM.getName());
				
				if(currentMM.getName().contains(currentMail.getSubject())){
					currentMM.add(currentMail);
					
					// println("Bingo!");
					bingo = true;					
				}
			}
			if(!bingo){
				TMNMailManager newMM = new TMNMailManager(currentMail.getSubject());
			    subjectList.add(newMM);
			    // println(newMM.getName());
			}else{
				bingo = false;
			}
		}		
	}
	// println("Array fromList contains: "+fromList.size());
}

void drawLinks(){
	for(int i = 0; i < subjectList.size(); i++){
		TMNMailManager currentMM = (TMNMailManager) subjectList.get(i);
		currentMM.drawVisu("Links");
	}
}

public void onlineCheck() {
	println("a button event from onlineCheck: ");
	thread("checkMailsOnline");
}

void takeAPicture() {
	save("./output/TMNEMail-" + year() + month() + day() + hour() + minute() + second() + ".tif");
	
}