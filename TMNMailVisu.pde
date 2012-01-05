public class TMNMailVisu extends TMNMail{
	
	// Variablen
	
	PVector position;
	PVector destination;
	
	color mainColor;
	
	//Constructor
	TMNMailVisu(){
		
		colorMode(HSB);
		mainColor = color (0,0,0);
		
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
	
	void drawRect(){
		
		noStroke();
		fill(mainColor,100);
		
		float xSize = 1;
		float ySize = getSize()/25;
		rect(position.x, position.y, xSize, ySize);
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
		PVector anchor1 = new PVector(getPosX(), 468);
		PVector anchor2 = new PVector(1024/_mailCount*getNumber(), 300);
		PVector point2  = new PVector(1024/_mailCount*getNumber(), 0);
				
		bezier(point1.x, point1.y, anchor1.x, anchor1.y, anchor2.x, anchor2.y, point2.x, point2.y);
		
	}

}