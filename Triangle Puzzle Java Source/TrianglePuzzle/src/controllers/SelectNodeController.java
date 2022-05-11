package controllers;

import java.awt.Point;

import model.Coordinate;
import model.Model;
import model.Node;
import model.TrianglePuzzle;
import view.TrianglePuzzleApp;
import view.UpdateButtons;

public class SelectNodeController {
	
	Model model;
	TrianglePuzzleApp app; 

	public SelectNodeController(Model m, TrianglePuzzleApp app) {
		this.model = m;
		this.app = app;
	}

	//Checking where we clicked on our drawingPanel
	public void process(Point point) {
		
		Coordinate c = app.getDrawingPanel().pointToCoordinate(point);
		
		TrianglePuzzle trianglePuzzle = model.getTrianglePuzzle();
		
		
		//We only want 3 to be able to be selected, this way we don't have to
		//deal with the player trying to swap more edges than possible
		int selectCounter = 0;
		for(Node n: trianglePuzzle) {
			if(n.getSelectStatus()) {
				selectCounter++;
			}
		}
		
		//Did we click on a node???
		for(Node n: trianglePuzzle ) {
				
			//Beacuse if we did, we want to select it, or unselect it 
			if(n.contains(c)) {
				
				if(n.getSelectStatus()) {
					n.setUnselected();
				}
				else if(selectCounter < 3 && n.getSelectStatus() == false) {
					n.setSelected();
				}
				UpdateButtons.enableButtons(app, model.getTrianglePuzzle());
				app.repaint();
				
			}
		}
		
	}
	
}
