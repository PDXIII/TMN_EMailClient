import java.util.Comparator;


public class ComparatorTMNMAilBySize implements Comparator<TMNMailVisu> {
	
	public int compare(TMNMailVisu m1, TMNMailVisu m2) {
	
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