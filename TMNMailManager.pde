class TMNMailManager {
	
// Variablen
	String name;
	ArrayList tmnMails;
	color mainColor;	
// Constructor
	TMNMailManager(String _name){
		
		colorMode(HSB);
		mainColor = color (0,0,0);
		this.name = _name;
		tmnMails = new ArrayList();		
	}
	
	// Methoden
	String getName(){
		return name;
	}
	
	void add(TMNMail _tmnMail){
		TMNMail currentTMNMail = _tmnMail;		
		tmnMails.add(currentTMNMail);		
	}
	
	void add(TMNMailVisu _tmnMail){
		TMNMailVisu currentTMNMail = _tmnMail;		
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
	
	void setColor(color _col){
		mainColor = _col;
	}
	
	void setColor(float _h, float _s, float _b){
		mainColor = color(_h, _s, _b);
	}
	
	color getColor(){
		return mainColor;
	}
	
	TMNMailVisu getMailAt(int _index){		
		int index = _index;
		TMNMailVisu currentMail = (TMNMailVisu)tmnMails.get(index);		
		return currentMail;
	}
	
	void sortBy(String _kindSort, String _kindVisu){
		
		if(_kindSort == "From"){
			sortByShortFrom();			
		}
			
		if(_kindSort == "Size"){
			sortBySize();
		}
			
		if(_kindSort == "Size Reverse"){
			sortBySizeReverse();			
		}
		
		drawVisu(_kindVisu);	
	}
	
	void sortByShortFrom(){
	
        Collections.sort(tmnMails, new Comparator(){
 
            public int compare(Object o1, Object o2) {
                TMNMailVisu m1 = (TMNMailVisu) o1;
                TMNMailVisu m2 = (TMNMailVisu) o2;
               return m1.getShortFrom().compareToIgnoreCase(m2.getShortFrom());
            }
        });
	}
	
	void sortBySize(){
	
		Comparator<TMNMailVisu> comp = new ComparatorTMNMAilBySize();
        Collections.sort(tmnMails, comp);
	}
	
	void sortBySizeReverse(){
	
		Comparator<TMNMailVisu> comp = new ComparatorTMNMAilBySize();
        Collections.sort(tmnMails, comp);
		Collections.reverse(tmnMails);
	}

	void drawVisu(String _kind){
		
		noStroke();
		fill(128);
		//rect(0,0,width,height);
		
		for(int i = 0; i < tmnMails.size(); i++){
			TMNMailVisu currentMail = (TMNMailVisu)tmnMails.get(i);	
			
			if(_kind =="Circle"){
				
				float xStep = 1024 / getCount();
				float xPos = i * xStep +10;
				float yPos = 300;
						
				currentMail.setPos(xPos, yPos);
				currentMail.drawCircle();		
			
			}
			else if(_kind =="Rectangle"){
				
				float xStep = 1024 / getCount();
				float xPos = i * xStep +10;
				float yPos = 150; 
		
				currentMail.setPos(xPos, yPos);
				currentMail.drawRect();	
	
			}
			else if(_kind == "Links"){
				noFill();
				stroke(255,100);
				strokeWeight(1);
				
				if(i < tmnMails.size()-1){
					TMNMailVisu nextMail = (TMNMailVisu)tmnMails.get(i+1);
					bezier(currentMail.getPosX(), currentMail.getPosY(), currentMail.getPosX()-10, currentMail.getPosY()-100, nextMail.getPosX()+10, nextMail.getPosY()-100, nextMail.getPosX(), nextMail.getPosY());
					
				}
				else{					
					TMNMailVisu nextMail = (TMNMailVisu)tmnMails.get(0);
					bezier(currentMail.getPosX(), currentMail.getPosY(), currentMail.getPosX()-10, currentMail.getPosY()-100, nextMail.getPosX()+10, nextMail.getPosY()-100, nextMail.getPosX(), nextMail.getPosY());
					
				}
			}
			else if(_kind =="Color"){
				currentMail.setColor(mainColor);		
			}
		}
	}
}