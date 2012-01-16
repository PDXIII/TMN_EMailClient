public class ThreadLine{

	// Variablen
	String subject;
	int subjectIndex;
	ArrayList <PVector> vectors;

	// Constructor
	ThreadLine(int _subjectIndex){		
		this.subjectIndex = _subjectIndex;
		vectors = new ArrayList();	
	}
	
	// Methoden
	void setSubject(String _subject){
		subject = _subject;
	}
	
	String getSubject(){
		return subject;
	}
	
	int getSubjectIndex(){
		return subjectIndex;
	}
	
	void add(PVector _vector){
		vectors.add(_vector);
	}
	
	void clear(){
		vectors.clear();
	}

	// void drawLine(){
	// 	noFill();
	// 	stroke(255,100);
	// 	strokeWeight(1);
	// 	
	// 	PVector currentVector;
	// 	PVector nextVector;
	// 	for(int i = 0; i < vectors.size();i++){
	// 		
	// 		int identifier = i%2;
	// 		currentVector = vectors.get(i);
	// 		if(i < vectors.size()-1){
	// 			nextVector = vectors.get(i+1);
	// 		
	// 		}
	// 		else{					
	// 			nextVector = vectors.get(0);		
	// 		}
	// 		
	// 		PVector handle1;
	// 		PVector handle2;
	// 		if(identifier==1){
	// 			handle1 = new PVector(currentVector.x -sqrt(abs(nextVector.y - currentVector.y))*10, currentVector.y-sqrt(abs(nextVector.x - currentVector.x))*10);
	// 			handle2 = new PVector(nextVector.x-sqrt(abs(nextVector.y - currentVector.y))*10, nextVector.y-sqrt(abs(nextVector.x - currentVector.x))*10);
	// 		}
	// 		else{
	// 			handle1 = new PVector(currentVector.x+sqrt(abs(nextVector.y - currentVector.y))*10, currentVector.y+sqrt(abs(nextVector.x - currentVector.x))*10);
	// 			handle2 = new PVector(nextVector.x +sqrt(abs(nextVector.y - currentVector.y))*10, nextVector.y +sqrt(abs(nextVector.x - currentVector.x))*10);
	// 		}
	// 		
	// 		bezier(currentVector.x, currentVector.y, handle1.x, handle1.y, handle2.x, handle2.y, nextVector.x, nextVector.y);		
	// 		
	// 		// println("draw Line " + subjectIndex);	
	// 	}	
	// }
		
	// void drawLine(){
	// 	
	// 		noFill();
	// 		stroke(255,100);
	// 		strokeWeight(1);
	// 		
	// 		// noStroke();
	// 		// fill(255,50);
	// 		
	// 		int magnifier = 10;
	// 		PVector currentVector = new PVector();
	// 		PVector prevVector = new PVector();
	// 	
	// 		PVector startVector = vectors.get(vectors.size()-1);
	// 	
	// 		beginShape();
	// 		vertex(startVector.x, startVector.y);
	// 		for(int i = 0; i < vectors.size();i++){
	// 		
	// 			int identifier = i%2;
	// 			currentVector = vectors.get(i);
	// 			if(i == 0){
	// 			
	// 				prevVector = vectors.get(vectors.size()-1);			
	// 			}
	// 			else {
	// 				prevVector = vectors.get(i-1);		
	// 			}
	// 		
	// 			PVector handle1;
	// 			PVector handle2;
	// 		
	// 			if(identifier < 1){
	// 				handle1 = new PVector(prevVector.x, prevVector.y + sqrt(abs(prevVector.x - currentVector.x))*magnifier);
	// 				handle2 = new PVector(currentVector.x, currentVector.y + sqrt(abs(prevVector.x - currentVector.x))*magnifier);
	// 		
	// 			}
	// 			else{
	// 				handle1 = new PVector(prevVector.x, prevVector.y - sqrt(abs(prevVector.x - currentVector.x))*magnifier);
	// 				handle2 = new PVector(currentVector.x, currentVector.y - sqrt(abs(prevVector.x - currentVector.x))*magnifier);
	// 		
	// 			}
	// 			bezierVertex(handle1.x, handle1.y, handle2.x, handle2.y, currentVector.x, currentVector.y);		
	// 			// println("draw Line " + subjectIndex);
	// 		
	// 		}
	// 		endShape();	
	// 	}
	void drawLine(){
		int magnifier = 8;
	
		noFill();
		stroke(255,100);
		strokeWeight(1);
		PVector currentVector = new PVector();
		PVector prevVector = new PVector();
	
		PVector startVector = vectors.get(vectors.size()-1);
	
		beginShape();
		vertex(startVector.x, startVector.y);
		for(int i = 0; i < vectors.size();i++){
		
			int identifier = i%2;
			currentVector = vectors.get(i);
			if(i == 0){
			
				prevVector = vectors.get(vectors.size()-1);			
			}
			else {
				prevVector = vectors.get(i-1);		
			}
		
			PVector handle1 = new PVector();
			PVector handle2 = new PVector();
		
		
			if(currentVector.y >= prevVector.y){
				handle1.x =  prevVector.x - (sqrt(abs(prevVector.y - currentVector.y)))*magnifier;
				handle2.x =  currentVector.x + (sqrt(abs(prevVector.y - currentVector.y)))*magnifier;			
			}
			else{
				handle1.x =  prevVector.x + (sqrt(abs(prevVector.y - currentVector.y)))*magnifier;
				handle2.x =  currentVector.x - (sqrt(abs(prevVector.y - currentVector.y)))*magnifier;
		
			}
		
			if(currentVector.x >= prevVector.x ){
				handle1.y =  prevVector.y + (sqrt(abs(prevVector.x - currentVector.x)))*magnifier;
				handle2.y =  currentVector.y - (sqrt(abs(prevVector.x - currentVector.x)))*magnifier;
				}
			else{
				handle1.y =  prevVector.y - (sqrt(abs(prevVector.x - currentVector.x)))*magnifier;
				handle2.y =  currentVector.y + (sqrt(abs(prevVector.x - currentVector.x)))*magnifier;
			}
				
			bezierVertex(handle1.x, handle1.y, handle2.x, handle2.y, currentVector.x, currentVector.y);						
		}
		endShape();	
	}
		
}