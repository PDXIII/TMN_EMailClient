class PD13MailManager {
	
	// Variablen
	ArrayList pd13Mails;
	// Constructor
	PD13MailManager(){
		
		pd13Mails = new ArrayList();
		
	}
	
	
	// Methoden
	
	void add(PD13Mail _pd13Mail){
		
		PD13Mail currentPD13Mail = _pd13Mail;
		
		pd13Mails.add(currentPD13Mail);
		
	}
	
	void printInfo(){
		
		for(int i = 0; i < pd13Mails.size(); i++){
			
			PD13Mail currentMail = (PD13Mail) pd13Mails.get(i);
			println(currentMail.getFrom());
			println(currentMail.getShortFrom());
			println(currentMail.getSubject());
			println(currentMail.getSize());
		}
	}
	
	int getCount(){
		
		return pd13Mails.size();
	}
	
	PD13Mail getMailAt(int _index){
		
		int index = _index;
		PD13Mail currentMail = (PD13Mail)pd13Mails.get(index);
		
		return currentMail;
	}
	
}