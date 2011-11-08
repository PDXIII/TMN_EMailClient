// Daniel Shiffman               
// http://www.shiffman.net       

// Example functions that check mail (pop3) and send mail (smtp)
// You can also do imap, but that's not included here

// A function to check a mail account
void checkMail() {
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


    // Get array of messages and display them
    Message message[] = folder.getMessages();

    for (int i=0; i < message.length; i++) {

      PD13Mail currentPD13Mail = new PD13Mail();

      currentPD13Mail.setNumber(i);
      currentPD13Mail.setFrom(message[i].getFrom()[0].toString());
      currentPD13Mail.setSubject(message[i].getSubject());
      currentPD13Mail.setSize(message[i].getSize());


      if (message[i].isMimeType("TEXT/PLAIN")) {
        currentPD13Mail.setMessage(message[i].getContent().toString());
      }

      if (message[i].isMimeType("multipart/ALTERNATIVE")) {

        MimeMultipart content = (MimeMultipart)message[i].getContent();

        for (int k = 0; k < content.getCount(); k++) {

          MimeBodyPart thisBodyPart = (MimeBodyPart)content.getBodyPart(k);

          if (thisBodyPart.isMimeType("TEXT/PLAIN")) {

            currentPD13Mail.setMessage(thisBodyPart.getContent().toString());
          }
        }
      }

      allPD13Mails.add(currentPD13Mail);

      // old and working
      /*			 System.out.println("---------------------");
       			 System.out.println("Message # " + (i));
       			 // Absender für Umlaute parsen
       			 System.out.println("From: " + message[i].getFrom()[0]); 
       			 System.out.println("Adress Type: " + message[i].getFrom()[0].getType()); 
       			
       			 System.out.println("Subject: " + message[i].getSubject());
       			 System.out.println("Message:");
       			 // Content Type abfragen und verschiedene Funktionen schreiben für Multipart
       			 //System.out.println(message[i].getContentType());
       			
       			if(message[i].isMimeType("TEXT/PLAIN")){
       				String content = message[i].getContent().toString(); 
       				System.out.println(content);
       			
       			}
       			
       			if (message[i].isMimeType("multipart/ALTERNATIVE")) {
       				
       				MimeMultipart content = (MimeMultipart)message[i].getContent();
       				
       				//String content = message[i].getContent().toString();
       				System.out.println(content.getCount());
       				for (int k = 0; k < content.getCount(); k++) {
       					
       					MimeBodyPart thisBodyPart = (MimeBodyPart)content.getBodyPart(k);
       					
       					if(thisBodyPart.isMimeType("TEXT/PLAIN")){
       						
       						System.out.println(thisBodyPart.getContent().toString());
       					}
       					//System.out.println(thisBodyPart.getContentType());
       					
       				}
       			}
       */
    }

    // Close the session
    folder.close(false);
    store.close();
  } 
  // This error handling isn't very good
  catch (Exception e) {
    e.printStackTrace();
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

