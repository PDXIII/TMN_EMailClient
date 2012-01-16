// Pete Sekan 
// https://github.com/PDXIII/TMN_EMailClient
// based on a tutorial by
// Daniel Shiffman 
// http://www.shiffman.net/2007/11/13/e-mail-processing/            


// A function to check a mail account
void checkMailsOnline() {
	
	currentMailManager = new TMNMailManager("Current", width, height);
	
	try {
		Properties props = System.getProperties();
		
		props.put("mail.imap.host", imapHost);
		
		// These are security settings required for gmail
		// May need different code depending on the account
		props.put("mail.imap.port", imapPort);
		props.put("mail.imap.starttls.enable", "true");
		props.setProperty("mail.imap.socketFactory.fallback", "false");
		props.setProperty("mail.imap.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		
		
		// Create authentication object
		Auth auth = new Auth(incoming);
		
		// Make a session
		Session session = Session.getDefaultInstance(props, auth);
		Store store = session.getStore("imap");
		store.connect();
		
		// Get inbox
		Folder folder = store.getFolder("INBOX");
		folder.open(Folder.READ_ONLY);
		
		int totalMessages = folder.getMessageCount();
		System.out.println(totalMessages + " total messages.");
		
		int mailIndex = 0;
		// Get array of messages and display them
		Message message[] = folder.getMessages();
		
		for (int i=0; i < message.length; i++) {
			
			TMNMailVisu currentMail = new TMNMailVisu();
			
			currentMail.setNumber(mailIndex);
			currentMail.setFrom(message[i].getFrom()[0].toString());
			currentMail.setSubject(message[i].getSubject());
			currentMail.setSize(message[i].getSize());
			currentMail.setSentDate(message[i].getSentDate());
			
			
			
			if (message[i].isMimeType("TEXT/PLAIN")) {
			  currentMail.setMessage(message[i].getContent().toString());
			}
			
			if (message[i].isMimeType("multipart/ALTERNATIVE")) {
				
				MimeMultipart content = (MimeMultipart)message[i].getContent();
				
				for (int k = 0; k < content.getCount(); k++) {
					
					MimeBodyPart thisBodyPart = (MimeBodyPart)content.getBodyPart(k);
					
					if (thisBodyPart.isMimeType("TEXT/PLAIN")) {
						
						currentMail.setMessage(thisBodyPart.getContent().toString());
					}
				}
			}
			
			mailIndex++;
			currentMailManager.add(currentMail);
			println("message " + mailIndex + " of " + totalMessages);
		}
		
		// Close the session
		folder.close(false);
		store.close();
		// Function to parse the downloaded mails int a JSON file on your system
		parse2JSON();
	} 
	// This error handling isn't very good
	catch (Exception e) {
		e.printStackTrace();
	}
	println("OnlineCheck done!");
}

// Function to parse the downloaded mails into a JSON file on your system
void parse2JSON(){	
	// println("parse 2 JSON NOW!");
	String[] storedMails = new String[currentMailManager.getCount()+2];	
	String introJSON = "{\"total\": \"" + currentMailManager.getCount() +"\",\"mails\":[";
	String outroJSON = "]}";
	storedMails[0] = introJSON;
	storedMails[currentMailManager.getCount()+1] = outroJSON;
	
	for(int i = 0; i < currentMailManager.getCount(); i++){		
		TMNMailVisu currentMail = (TMNMailVisu)currentMailManager.getMailAt(i);		
		String currentMail2JSONString =  "{" + "\"number\":\"" + currentMail.getNumber() + "\"," + "\"bytes\" :\"" + currentMail.getSize() + "\"," + "\"sentDate\" :" + currentMail.getTime() + "," + "\"from\" :\"" +currentMail.getFrom() + "\"," + "\"subject\" :\"" +currentMail.getSubject() + "\"," + "\"message\" :\"" +currentMail.getMessage() + "\"" + "}";
		if(i < currentMailManager.getCount()-1){
			currentMail2JSONString = currentMail2JSONString + ",";
		}		
		// println(currentMail2JSONString);	
		storedMails[i+1] = currentMail2JSONString;
	}
	saveStrings(jsonFile, storedMails);
	parseFromJSON();	
}

// Function to parse mails from the JSON file on your system

void parseFromJSON(){

	try {		
		JSONObject allMails = new JSONObject(join(loadStrings(jsonFile), ""));
		JSONArray mails = allMails.getJSONArray("mails");
		int total = allMails.getInt("total");
		println ("There are " + total + " mails in your json file.");
		currentMailManager = new TMNMailManager("Current", width, height);

		for(int i = 0; i < total; i++){
			
			try{

				JSONObject currentJSONObj = mails.optJSONObject(i);			
				TMNMailVisu currentMail = new TMNMailVisu();			
				currentMail.setNumber(currentJSONObj.getInt("number"));
				currentMail.setSize(currentJSONObj.getInt("bytes"));
				currentMail.setTime(currentJSONObj.getLong("sentDate"));
				currentMail.setFrom(currentJSONObj.getString("from"));
				currentMail.setSubject(currentJSONObj.getString("subject"));
				currentMail.setMessage(currentJSONObj.getString("message"));			
				currentMailManager.add(currentMail);				
			}
			catch(JSONException e){
				println("Something is wrong with this JSONArray!!!");
			}		
		}
		
		mailManager = currentMailManager;
	}
	catch (Exception e) {
		
		println ("There was an error parsing the JSONObject.");
		// if there is something wrong with the JSON file, we download the mails out of the cloud
		checkMailsOnline();
	}
}