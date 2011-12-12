class PD13Mail {
	
	// Variablen
	int number;
	int bytes;
	String from;
	String subject;
	String message;
	// Constructor
	PD13Mail(){
		
		
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
	
	void setFrom(String _from){
		from = _from;
	}
	
	String getFrom(){
		return from;
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
//		subject.replaceAll("&", "&amp");
	}
	
	String getSubject(){
		return subject;
	}
	
	void setMessage(String _message){
		message = _message;
		
//		message.replaceAll("&", "&amp");
	}
	
	String getMessage(){
		return message;
	}
}