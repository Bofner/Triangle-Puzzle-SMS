package view;

import java.util.List;

import model.Edge;
import model.Node;
import model.TrianglePuzzle;

public class UpdateButtons {
	
	public static void enableButtons(TrianglePuzzleApp app, TrianglePuzzle trianglePuzzle) {
		
		//This is all of the criteria for activating the SWAP EDGES button
		app.getSwapColorsButton().setEnabled(false);
		//Do we have three nodes selected?
		int selectedNodes = 0;
		for (Node n: trianglePuzzle ) {
			if(n.getSelectStatus()) {
				selectedNodes++;
			}
		}
		//Do we only have LEGAL swap criteria, ie are two edges FULLY selected
		int activeEdges = 0;
		for(Edge e : trianglePuzzle.edges) {
			if(e.edgeActivation()) {
				activeEdges++;
			}
		}
		// Our edges have an "activated state" when both of their nodes
		// have become selected
		if(selectedNodes == 3 && activeEdges >= 2 && (trianglePuzzle.currentState.all.equals(trianglePuzzle.finalState.all) == false)) {
			app.getSwapColorsButton().setEnabled(true);
		}
		
	}

}
