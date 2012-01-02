class TMNMail {
	
	// Variablen
	int number;
	int bytes;
	Date sentDate;
	String from;
	String subject;
	String message;
	
	PVector position ;
	
	// Constructor
	
	TMNMail(){		
		
	}
	
	// Methoden	
	void setSize(int _bytes){
		bytes = _bytes;
	}
	
	int getSize(){
		return bytes;
	}
	
	void setNumber(int _nr){
		number = _nr;
	}
	
	int getNumber(){
		return number;
	}
	
	void setSentDate(Date _sentDate){
		sentDate = _sentDate;
	}
	
	Date getSentDate(){
		return sentDate;
	}
	
	void setTime(long _sentDate){
		sentDate = new Date(_sentDate);
	}
	
	long getTime(){
		return sentDate.getTime();	
	}
	
	String getFrom(){
		return from;
	}
	
	void setFrom(String _from){
		from = _from;		
		from = from.replaceAll("\"", " ");
	}
	
	String getShortFrom(){
		
		int lastSpace = 0;
		
		for(int i = 0; i < from.length()-1; i++){
			
			char currentChar = from.charAt(i);
			if(currentChar == ' '){
				
				lastSpace = i;
			}
		}
		
		String shortFrom = from.substring(lastSpace+2, from.length()-1);
		return shortFrom;
	}
	
	void setSubject(String _subject){
		subject = _subject;
		subject = subject.replaceAll("\"", " ");
	}
	
	String getSubject(){
		return subject;
	}
		
	void setMessage(String _message){
		message = _message;	
		message = message.replaceAll("\"", " ");		
	}
	
	String getMessage(){
		return message;
	}
	
	void setPos(PVector _pos){
		position = new PVector();
		position = _pos;
	}
	
	void setPos(float _x, float _y){
		position = new PVector(_x, _y);
	}
}