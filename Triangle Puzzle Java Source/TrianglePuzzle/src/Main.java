import javax.swing.JFrame;

import model.Model;
import view.TrianglePuzzleApp;

public class Main {

	public static void main(String[] args) {
		
		Model m = new Model();		
		JFrame frame = new TrianglePuzzleApp(m);
		frame.setVisible(true);
		
	}
	
}
