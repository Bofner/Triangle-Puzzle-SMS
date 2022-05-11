package controllers;

import model.Model;
import model.Node;
import model.TrianglePuzzle;
import view.TrianglePuzzleApp;

public class ResetPuzzleController {
	
	Model model;
	TrianglePuzzle trianglePuzzle;
	TrianglePuzzleApp app;
	
	public ResetPuzzleController(Model m, TrianglePuzzleApp app) {
		this.model = m;
		this.app = app;
		this.trianglePuzzle = model.getTrianglePuzzle();
	}
	
	public boolean resetPuzzle() {
		
		for(Node n: trianglePuzzle) {
			n.setUnselected();
		}
		
		trianglePuzzle.resetEdges();
		
		model.resetNumSwaps();
		model.resetScore();
		app.getNumSwaps().setText("" + model.getNumSwaps());
		app.getScore().setText("" + model.getScore());
		model.resetModel(model.top, model.mid, model.bot);
		app.drawingPanel.remove(app.youWin);
		
		app.repaint();
		
		return true; 
	}

}
