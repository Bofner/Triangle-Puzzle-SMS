package controllers;

import java.awt.Color;

import model.Edge;
import model.Model;
import model.TrianglePuzzle;
import view.TrianglePuzzleApp;

//We are going to be doing our edge swapping here. My idea is that I will
//actually just leave all the edges where they are, and instead change 
//their color. This will then update the screen with the new color, as well
//as the currentState object's array of colors. We will then perform a 
//finalState check to see if the player has completed the puzzle or not
public class SwapEdgeController {
	
	Model model;
	TrianglePuzzle trianglePuzzle;
	TrianglePuzzleApp app; 
	

	public SwapEdgeController(Model m, TrianglePuzzleApp app) {
		this.model = m;
		this.app = app;
		this.trianglePuzzle = model.getTrianglePuzzle();
		
	}
	
	public boolean swap() {
		int activeEdges = 0;
		Edge edgeOne = null;
		Edge edgeTwo = null;
		Edge edgeThree = null;
		//Here we are finding out active edges for the swap
		for(Edge e : trianglePuzzle.edges) {
			if(e.edgeActivation()) {
				activeEdges++;
				if(activeEdges == 1) {
					edgeOne = e;
				}
				else if(activeEdges == 2) {
					edgeTwo = e;
				}
				else{
					edgeThree = e;
				}
			}
		}
		//This is the standard case of 2 active edges
		if(activeEdges == 2) {
			edgeOne.swapEdge(edgeTwo);
			model.numSwaps++;
			model.score--;
		}
		//This is the case where we selected a whole triangle. 
		else {
			edgeOne.cycleEdges(edgeTwo,edgeThree);
			model.numSwaps++;
			model.score--;
		}
		//Now we need to update the current state, as well as the score
		int colorCount = 0;
		//Used for checking edge Color for Triangle based score
		Color eC0 = Color.black;
		Color eC1 = Color.black;
		Color eC2 = Color.black;
		
		Color eC3 = Color.black;
		Color eC4 = Color.black;
		Color eC5 = Color.black;
		
		Color eC6 = Color.black;
		Color eC7 = Color.black;
		Color eC8 = Color.black;
		
		Color eC9 = Color.black;
		Color eC10 = Color.black;
		Color eC11 = Color.black;
		
		Color eC12 = Color.black;
		Color eC13 = Color.black;
		Color eC14 = Color.black;
		
		Color eC15 = Color.black;
		Color eC16 = Color.black;
		Color eC17 = Color.black;
		
		
		
		for(Edge e : trianglePuzzle.edges) {
			trianglePuzzle.currentState.all.set(colorCount, e.color);
			//We're gonna hard code the checks for triangles being the same
			//color, because there really aren't that many
			
			//Logic for the top triangle
			if(colorCount == 0) {
				eC0 = e.getEdgeColor();
			}
			if(colorCount == 1) {
				eC1 = e.getEdgeColor();
			}
			if(colorCount == 2) {
				eC2 = e.getEdgeColor();
				if(eC0 == eC1 && eC1 == eC2 && model.t1 == false) {
					model.score = model.score + 10;	
					model.t1 = true;
				}
				else if(eC0 != eC1 || eC1 != eC2 ) {
					if(model.t1 == true) {
						model.score = model.score - 10;	
						model.t1 = false;
					}
				}
			}
			
			//Logic for the middle left triangle
			if(colorCount == 3) {
				eC3 = e.getEdgeColor();
			}
			if(colorCount == 4) {
				eC4 = e.getEdgeColor();
			}
			if(colorCount == 5) {
				eC5 = e.getEdgeColor();
				if(eC3 == eC4 && eC4 == eC5 && model.t2 == false) {
					model.score = model.score + 10;	
					model.t2 = true;
				}
				else if(eC3 != eC4 || eC4 != eC5) {
					if(model.t2 == true) {
						model.score = model.score - 10;	
						model.t2 = false;
					}
				}
			}
			
			//Logic for the middle right triangle
			if(colorCount == 6) {
				eC6 = e.getEdgeColor();
			}
			if(colorCount == 7) {
				eC7 = e.getEdgeColor();
			}
			if(colorCount == 8) {
				eC8 = e.getEdgeColor();
				if(eC6 == eC7 && eC7 == eC8 && model.t3 == false) {
					model.score = model.score + 10;	
					model.t3 = true;
				}
				else if(eC6 != eC7 || eC7 != eC8) {
					if(model.t3 == true) {
						model.score = model.score - 10;	
						model.t3 = false;
					}
				}
			}
			
			//Logic for the bottom left triangle
			if(colorCount == 9) {
				eC9 = e.getEdgeColor();
			}
			if(colorCount == 10) {
				eC10 = e.getEdgeColor();
			}
			if(colorCount == 11) {
				eC11 = e.getEdgeColor();
				if(eC9 == eC10 && eC10 == eC11 && model.t4 == false) {
					model.score = model.score + 10;	
					model.t4 = true;
				}
				else if(eC9 != eC10 || eC10 != eC11) {
					if(model.t4 == true) {
						model.score = model.score - 10;	
						model.t4 = false;
					}
				}
			}
			
			//Logic for the bottom middle triangle
			if(colorCount == 12) {
				eC12 = e.getEdgeColor();
			}
			if(colorCount == 13) {
				eC13 = e.getEdgeColor();
			}
			if(colorCount == 14) {
				eC14 = e.getEdgeColor();
				if(eC12 == eC13 && eC13 == eC14 && model.t5 == false) {
					model.score = model.score + 10;	
					model.t4 = true;
				}
				else if(eC12 != eC13 || eC13 != eC14) {
					if(model.t5 == true) {
						model.score = model.score - 10;	
						model.t5 = false;
					}
				}
			}
			
			//Logic for the bottom right triangle
			if(colorCount == 15) {
				eC15 = e.getEdgeColor();
			}
			if(colorCount == 16) {
				eC16 = e.getEdgeColor();
			}
			if(colorCount == 17) {
				eC17 = e.getEdgeColor();
				if(eC15 == eC16 && eC16 == eC17 && model.t6 == false) {
					model.score = model.score + 10;	
					model.t4 = true;
				}
				else if(eC15 != eC16 || eC16 != eC17) {
					if(model.t6 == true) {
						model.score = model.score - 10;	
						model.t6 = false;
					}
				}
			}
			
			colorCount++;
		}
		
		//Is our current state equal to our final state?
		if(trianglePuzzle.currentState.all.equals(trianglePuzzle.finalState.all)) {
			//Then YOU WIN!!
			app.drawingPanel.add(app.youWin);
			
		}
		//We also need to unselect the nodes that were selected
		new UnselectAllController(model, app).unselectAll();
		app.getSwapColorsButton().setEnabled(false);
		app.getNumSwaps().setText("" + model.getNumSwaps());
		app.getScore().setText("" + model.getScore());
		app.repaint();
		return true; 
	}

}
