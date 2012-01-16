class TMNMailManager {
	
// Variablen
	String name;
	
	ArrayList<TMNMailVisu> tmnMails;
	ArrayList<String> fromList;
	ArrayList<String> subjectList;
	ArrayList<ThreadLine> threadLines;
	
// Constructor
	TMNMailManager(String _name){
		
		this.name = _name;
		tmnMails = new ArrayList();		
	}
	
	// Methoden
	
	
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
	
	void initFromList(){
		
		fromList = new ArrayList();
		
		TMNMailVisu currentMail;
		String newFrom;
		
		for(int i = 0; i < getCount(); i++){
				
			currentMail = getMailAt(i);
			newFrom = currentMail.getShortFrom();
			
			if(fromList.isEmpty() || !fromList.contains(newFrom)){			
				fromList.add(newFrom);
			}
		}
	
		Comparator<String> comp = new ComparatorArrayListByFrom();
	    Collections.sort(fromList, comp);
		
		//setting Colors
		
		color[] fromColors = new color[fromList.size()];
		
		println("Number of Senders: " + fromList.size());
		
		for(int j = 0; j < fromList.size(); j++){
			fromColors[j] = color((255/fromList.size())*j,255,255);
		}
		
		for(int k = 0; k < getCount(); k++){
			
			currentMail = getMailAt(k);
			newFrom = currentMail.getShortFrom();
			
			int colorIndex = fromList.indexOf(newFrom);
			currentMail.setColor(fromColors[colorIndex]);			
		}		
	}
	
	void initSubjectList(){
		
		subjectList = new ArrayList();
		TMNMailVisu currentMail;
		String newSubject;
		String currentSubject;
		
		for(int i = 0; i < getCount(); i++){
				
			currentMail = getMailAt(i);
			newSubject = currentMail.getSubject();
			
			if(subjectList.isEmpty()){			
				subjectList.add(newSubject);
			}
			else{
				
				boolean bingo = false;
				for(int j = 0; j < subjectList.size(); j++){
					currentSubject = subjectList.get(j);
					if(newSubject.contains(currentSubject)){
						bingo = true;
						currentMail.setSubjectIndex(j);
					}
				}
				if(!bingo){
					subjectList.add(newSubject);
					currentMail.setSubjectIndex(subjectList.size()-1);
					
				}
				else{
					bingo = false;
				}
			}
		}
		
		Comparator<String> comp = new ComparatorArrayListByFrom();
	    ArrayList newSubjectList = new ArrayList(subjectList);
	    Collections.sort(newSubjectList, comp);
		threadLines = new ArrayList();
		for(int l = 0; l < newSubjectList.size(); l++){
		
			ThreadLine currentTL = new ThreadLine(l);
			threadLines.add(currentTL);
		}
		
		// println("still ok");
		
		for(int k = 0; k < tmnMails.size(); k++){
						
			currentMail = (TMNMailVisu)tmnMails.get(k);
			currentSubject = subjectList.get(currentMail.getSubjectIndex());			
			int newSubjectIndex = newSubjectList.indexOf(currentSubject);
			currentMail.setSubjectIndex(newSubjectIndex);
		}
		// println(subjectList.size());	
	}
	
	void updateThreadLines(){
		for(int i = 0; i < threadLines.size(); i++){
			threadLines.get(i).clear();
		}
		
		for(int j = 0; j < tmnMails.size(); j++){
			
			TMNMailVisu currentMail = tmnMails.get(j);
			PVector currentVector = currentMail.getPosition();
			int currentSubjectIndex = currentMail.getSubjectIndex();
			
			threadLines.get(currentSubjectIndex).add(currentVector);
		}
		
	}
	
	void drawThreadLines(){
		for(int i = 0; i < threadLines.size(); i++){
			
			ThreadLine currentTL = threadLines.get(i);
			
			if(currentTL.vectors.size() > 1){
				currentTL.drawLine();
			}
		}		
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
				// currentMail.drawCircle();
				currentMail.drawRectInCircle();
			}
  		}
		//updateThreadLines();
	}
}