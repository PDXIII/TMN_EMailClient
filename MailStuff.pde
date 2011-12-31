// Daniel Shiffman               
// http://www.shiffman.net       

// Example functions that check mail (pop3) and send mail (smtp)
// You can also do imap, but that's not included here

// A function to check a mail account
void checkMailsOnline() {
	
	currentMailManager = new TMNMailManager();
	
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
			
			TMNMail currentTMNMail = new TMNMail();
			
			currentTMNMail.setNumber(mailIndex);
			currentTMNMail.setFrom(message[i].getFrom()[0].toString());
			currentTMNMail.setSubject(message[i].getSubject());
			currentTMNMail.setSize(message[i].getSize());
			
			
			if (message[i].isMimeType("TEXT/PLAIN")) {
			  currentTMNMail.setMessage(message[i].getContent().toString());
			}
			
			if (message[i].isMimeType("multipart/ALTERNATIVE")) {
				
				MimeMultipart content = (MimeMultipart)message[i].getContent();
				
				for (int k = 0; k < content.getCount(); k++) {
					
					MimeBodyPart thisBodyPart = (MimeBodyPart)content.getBodyPart(k);
					
					if (thisBodyPart.isMimeType("TEXT/PLAIN")) {
						
						currentTMNMail.setMessage(thisBodyPart.getContent().toString());
					}
				}
			}
			
			mailIndex++;
			currentMailManager.add(currentTMNMail);
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
}

// Function to parse the downloaded mails int a JSON file on your system
void parse2JSON(){	
	// println("parse 2 JSON NOW!");
	String[] storedMails = new String[currentMailManager.getCount()+2];	
	// String introJSON = "{\"mails\":[";
	String introJSON = "{\"total\": \"" + currentMailManager.getCount() +"\",\"mails\":[";
	String outroJSON = "]}";
	storedMails[0] = introJSON;
	storedMails[currentMailManager.getCount()+1] = outroJSON;
	
	for(int i = 0; i < currentMailManager.getCount(); i++){		
		TMNMail currentMail = (TMNMail)currentMailManager.getMailAt(i);		
		String currentMail2JSONString =  "{" + "\"number\":\"" + currentMail.getNumber() + "\"," + "\"bytes\" :\"" + currentMail.getSize() + "\"," + "\"from\" :\"" +currentMail.getFrom() + "\"," + "\"subject\" :\"" +currentMail.getSubject() + "\"," + "\"message\" :\"" +currentMail.getMessage() + "\"" + "}";
		if(i < currentMailManager.getCount()-1){
			currentMail2JSONString = currentMail2JSONString + ",";
		}		
		// println(currentMail2JSONString);	
		storedMails[i+1] = currentMail2JSONString;
	}
	saveStrings("./data/allMails.json", storedMails);
	parseFromJSON();	
}

void parseFromJSON(){

	try {		
		JSONObject allMails = new JSONObject(join(loadStrings("./data/allMails.json"), ""));
		JSONArray mails = allMails.getJSONArray("mails");
		int total = allMails.getInt("total");
		println ("There were " + total + " mails in your json file.");
		currentMailManager = new TMNMailManager();

		for(int i = 0; i < total; i++){
			
			try{

				JSONObject currentJSONObj = mails.optJSONObject(i);			
				TMNMail currentMail = new TMNMail();			
				currentMail.setNumber(currentJSONObj.getInt("number"));
				currentMail.setSize(currentJSONObj.getInt("bytes"));
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
		println("OnlineCheck done!");
	}
	catch (Exception e) {
		
		println ("There was an error parsing the JSONObject.");
		// if there is something wring with the JSON file, we download the maisl out of the cloud
		checkMailsOnline();
	}
}

// A function to send mail
// doesn't work
void sendMail() {
  // Create a session
  String host="smtp.gmail.com";

  // SMTP Session
  /*
	Properties props=new Properties();
   	props.put("mail.transport.protocol", "smtp");
   	props.put("mail.smtp.host", host);
   	props.put("mail.smtp.port", "465");  // 25, 465, 587
   	props.put("mail.smtp.auth", "true");
   	// props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
   	// We need TTLS, which gmail requires
   	props.put("mail.smtp.starttls.enable", "true");
   	*/


  Properties props = new Properties();
  props.put("mail.transport.protocol", "smtp");

  props.put("mail.smtp.host", host);
  props.put("mail.smtp.auth", "true");
  props.put("mail.debug", "true");
  props.put("mail.smtp.port", 587);
  props.put("mail.smtp.socketFactory.port", 587);
  props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
  props.put("mail.smtp.socketFactory.fallback", "false");



  //debug
  println("Properties created");
  println(props);

  // Create a new authentification
  Auth auth = new Auth(incoming);

  //debug
  println("Auth created");

  // Create a session
  Session session = Session.getDefaultInstance(props, auth);

  //debug  
  println("Session created");

  try {
    // Make a new message
    MimeMessage message = new MimeMessage(session);

    // Who is this message from
    message.setFrom(new InternetAddress(mailAcc, "MailCodingBot"));

    // Who is this message to (we could do fancier things like make a list or add CC's)
    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(mailRecipient, false));

    // Subject and body
    message.setSubject("Hello World!");
    message.setText("It's great to be here. . .");

    // We can do more here, set the date, the headers, etc.
    Transport.send(message);
    println("Mail sent!");
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}