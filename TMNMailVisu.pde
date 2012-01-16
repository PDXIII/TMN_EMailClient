public class TMNMailVisu extends TMNMail{
	
	// Variablen
	
	PVector position;
	PVector destination;
	
	color mainColor = color (0,0,0);;
	
	float angle = 0;
	
	int subjectIndex = 0;
	
	//Constructor
	TMNMailVisu(){
		
		
	}
	
	// Methods

	void setPos(PVector _pos){
		position = new PVector();
		position = _pos;
	}
	
	void setPos(float _x, float _y){
		position = new PVector(_x, _y);
	}
	
	PVector getPosition(){
		return position;
	}
	
	float getPosX(){
		return position.x;
	}
	
	float getPosY(){
		return position.y;
	}
	
	void setDest(PVector _dest){
		destination = new PVector();
		destination = _dest;
	}
	
	void setDest(float _x, float _y){
		destination = new PVector(_x, _y);
	}
	
	PVector getDestination(){
		return destination;
	}
	
	float getDestX(){
		return destination.x;
	}
	
	float getDestY(){
		return destination.y;
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
	
	void setAngle(float _angle){
		angle = _angle;
	}
	
	float getAngle(){
		return angle;
	}
	
	void setSubjectIndex(int _subjectIndex){
		subjectIndex = _subjectIndex;
	}
	
	int getSubjectIndex(){
		return subjectIndex;
	}
	
	void drawRect(){
		
		noStroke();
		fill(mainColor,200);
		
		float xSize = 1;
		float ySize = getSize()/25;
		rect(position.x, position.y, xSize, ySize);
	}
	
	void drawRectInCircle(){
		
		noStroke();
		fill(mainColor,100);
		rectMode(CENTER);
		float xSize = 1;
		float ySize = getSize()/25;
		pushMatrix();
		translate(position.x, position.y);
		rotate(radians(angle-90));
		rect(0,0, xSize, ySize);
		
		popMatrix();
	}
	
	void drawCircle(){
		
		noStroke();
		fill(mainColor,100);
		
		float xSize = getSize()/100;
		float ySize = getSize()/100;
		ellipse(position.x, position.y, xSize, ySize);
	}
	
	void drawBezier(int _mailCount){
		stroke(getColor(), 100);
		strokeWeight(getSize()/2000);
				
		PVector point1  = new PVector(getPosX(), getPosY());
		PVector handle1 = new PVector(getPosX(), 468);
		PVector handle2 = new PVector(1024/_mailCount*getNumber(), 300);
		PVector point2  = new PVector(1024/_mailCount*getNumber(), 0);
				
		bezier(point1.x, point1.y, handle1.x, handle1.y, handle2.x, handle2.y, point2.x, point2.y);
		
	}

}