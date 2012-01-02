import java.util.Comparator;


public class ComparatorTMNMAilBySize implements Comparator<TMNMail> {
	
	public int compare(TMNMail m1, TMNMail m2) {
	
		if (m1.getSize() == m2.getSize()) {
			return 0;
		}
		else if (m1.getSize() > m2.getSize()) {
			return -1;
		}
		else {
			return 1;
		}
	}	
}