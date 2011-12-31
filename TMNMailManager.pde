class TMNMailManager {
	
// Variablen
	ArrayList tmnMails;
	
// Constructor
	TMNMailManager(){
		tmnMails = new ArrayList();		
	}
	
	// Methoden
	
	void add(TMNMail _tmnMail){
		TMNMail currentTMNMail = _tmnMail;		
		tmnMails.add(currentTMNMail);		
	}
	
	void printInfo(){		
		for(int i = 0; i < tmnMails.size(); i++){			
			TMNMail currentMail = (TMNMail) tmnMails.get(i);
			println(currentMail.getFrom());
			println(currentMail.getShortFrom());
			println(currentMail.getSubject());
			println(currentMail.getSize());
		}
	}
		
	int getCount(){		
		return tmnMails.size();
	}
	
	TMNMail getMailAt(int _index){		
		int index = _index;
		TMNMail currentMail = (TMNMail)tmnMails.get(index);		
		return currentMail;
	}
}