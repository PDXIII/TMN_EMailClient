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

public class ComparatorTMNMAilByTime implements Comparator<TMNMailVisu> {
	
	public int compare(TMNMailVisu m1, TMNMailVisu m2) {
	
		if (m1.getTime() == m2.getTime()) {
			return 0;
		}
		else if (m1.getTime() > m2.getTime()) {
			return -1;
		}
		else {
			return 1;
		}
	}	
}

// public class ComparatorTMNMAilMByName implements Comparator<TMNMailManager> {
// 	
// 	public int compare(TMNMailManager m1, TMNMailManager m2) {
// 		
//         return m1.getName().compareToIgnoreCase(m2.getName());
// 	}	
// }

public class ComparatorArrayListByFrom implements Comparator<String> {
	
	public int compare(String m1, String m2) {
		
        return m1.compareToIgnoreCase(m2);
	}	
}

