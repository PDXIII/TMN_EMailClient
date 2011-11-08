// Daniel Shiffman               
// http://www.shiffman.net       

// Simple Authenticator          
// Careful, this is terribly unsecure!!

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;



public class Auth extends Authenticator {
  
  public String[] incoming;
	
	public Auth(String[] _incoming) {
		super();

                this.incoming = _incoming;
	}
	
	public PasswordAuthentication getPasswordAuthentication() {
		String username = incoming[0];
		String password = incoming[1];
		System.out.println("authenticating. . ");
		return new PasswordAuthentication(username, password);
	}
}
