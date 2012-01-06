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
		
		if(_kindSort == "Time"){
			sortByTime();			
		}
		
		if(_kindSort == "Time Reverse"){
			sortByTimeReverse();			
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
	
	void sortByTime(){
	
		Comparator<TMNMailVisu> comp = new ComparatorTMNMAilByTime();
        Collections.sort(tmnMails, comp);
	}
	
	void sortByTimeReverse(){
	
		Comparator<TMNMailVisu> comp = new ComparatorTMNMAilByTime();
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
				float yPos = 300; 
		
				currentMail.setPos(xPos, yPos);
				currentMail.drawRect();	
	
			}
			else if(_kind == "Links"){
				noFill();
				stroke(255,100);
				strokeWeight(1);
				
				// int identifier = currentMail.getNumber()%2;
				int identifier = i%2;
				
				TMNMailVisu nextMail = new TMNMailVisu();
				
				if(i < tmnMails.size()-1){
					nextMail = (TMNMailVisu)tmnMails.get(i+1);
					
				}
				else{					
					nextMail = (TMNMailVisu)tmnMails.get(0);		
				}
				// PVector point1 = new PVector(currentMail.getPosX(), currentMail.getPosY());
				// PVector point2 = new PVector(nextMail.getPosX(), nextMail.getPosY());
				// PVector anchor1;
				// PVector anchor2;
				// if(identifier==1){
				// 	anchor1 = new PVector(currentMail.getPosX()-sqrt(abs(nextMail.getPosY() - currentMail.getPosY()))*10, currentMail.getPosY()-sqrt(abs(nextMail.getPosX() - currentMail.getPosX()))*10);
				// 	anchor2 = new PVector(nextMail.getPosX()-sqrt(abs(nextMail.getPosY() - currentMail.getPosY()))*10, nextMail.getPosY()-sqrt(abs(nextMail.getPosX() - currentMail.getPosX()))*10);
				// }
				// else{
				// 	anchor1 = new PVector(currentMail.getPosX()+sqrt(abs(nextMail.getPosY() - currentMail.getPosY()))*10, currentMail.getPosY()+sqrt(abs(nextMail.getPosX() - currentMail.getPosX()))*10);
				// 	anchor2 = new PVector(nextMail.getPosX()+sqrt(abs(nextMail.getPosY() - currentMail.getPosY()))*10, nextMail.getPosY()+sqrt(abs(nextMail.getPosX() - currentMail.getPosX()))*10);
				// }
				// bezier(point1.x, point1.y, anchor1.x, anchor1.y, anchor2.x, anchor2.y, point2.x, point2.y);
				
				PVector point1 = new PVector(currentMail.getPosX(), currentMail.getPosY());
				PVector point2 = new PVector(nextMail.getPosX(), nextMail.getPosY());
				
				float radius = 15 * sqrt(3*abs(currentMail.getAngle() - nextMail.getAngle())); 

				PVector anchor1 = new PVector(point1.x + cos(radians(180 + currentMail.getAngle()))*(radius/2), point1.y + sin(radians(180 + currentMail.getAngle()))*(radius/2));
				PVector anchor2 = new PVector(point2.x + cos(radians(180 + nextMail.getAngle()))*(radius/2), point2.y + sin(radians(180 + nextMail.getAngle()))*(radius/2));
				
			   
				bezier(point1.x, point1.y, anchor1.x, anchor1.y, anchor2.x, anchor2.y, point2.x, point2.y);
				
				
			}
			else if(_kind == "Bezier"){

				noFill();
				
				float xStep = 1024 / getCount();
				float xPos = i * xStep;
				float yPos = 768;
				
				currentMail.setPos(xPos, yPos);
				currentMail.drawBezier(tmnMails.size());
			}
			else if(_kind == "Circulation"){
				
				noFill();
				int time = currentMail.getSentDate().getHours()*60 + currentMail.getSentDate().getMinutes();
				int angle = 360/12 * time/60;
				// int angle = 360/12 * currentMail.getSentDate().getHours();
				// println(angle + " " + currentMail.getSentDate().getHours());
				int radius = 500;
				
			    float xPos = width/2 + cos(radians(angle))*(radius/2);
			    float yPos = height/2 + sin(radians(angle))*(radius/2);				
				
				currentMail.setPos(xPos, yPos);
				currentMail.setAngle(angle);
				currentMail.drawCircle();
				// currentMail.drawRectInCircle();
			}

			else if(_kind =="Color"){
				currentMail.setColor(mainColor);		
			}			
			
		}
	}
}