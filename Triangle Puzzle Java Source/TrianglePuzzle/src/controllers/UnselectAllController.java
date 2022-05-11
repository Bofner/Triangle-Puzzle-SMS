package controllers;

import model.Model;
import model.Node;
import model.TrianglePuzzle;
import view.TrianglePuzzleApp;

public class UnselectAllController {
	
	Model model;
	TrianglePuzzle trianglePuzzle;
	TrianglePuzzleApp app; 

	public UnselectAllController(Model m, TrianglePuzzleApp app) {
		this.model = m;
		this.app = app;
		this.trianglePuzzle = model.getTrianglePuzzle();
	}
	
	public boolean unselectAll() {
		
		for(Node n: trianglePuzzle) {
			n.setUnselected();
		}
		
		app.repaint();
		
		return true; 
	}

}
