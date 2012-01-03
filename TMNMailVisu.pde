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
		fill(mainColor);
		
		float xSize = 1;
		float ySize = getSize()/20;
		rect(position.x, position.y, xSize, ySize);
	}
	
	void drawCircle(){
		
		noStroke();
		fill(mainColor,100);
		
		float xSize = getSize()/100;
		float ySize = getSize()/100;
		ellipse(position.x, position.y, xSize, ySize);
	}

}