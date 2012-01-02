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
	
	void sortByShortFrom(){
	
        Collections.sort(tmnMails, new Comparator(){
 
            public int compare(Object o1, Object o2) {
                TMNMail m1 = (TMNMail) o1;
                TMNMail m2 = (TMNMail) o2;
               return m1.getShortFrom().compareToIgnoreCase(m2.getShortFrom());
            }
        });
	}
	
	void sortBySize(){
	
		Comparator<TMNMail> comp = new ComparatorTMNMAilBySize();
        Collections.sort(tmnMails, comp);
	}
	
	void sortBySizeReverse(){
	
		Comparator<TMNMail> comp = new ComparatorTMNMAilBySize();
        Collections.sort(tmnMails, comp);
		Collections.reverse(tmnMails);
	}


}