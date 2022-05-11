	package model;

import java.awt.Color;
import java.util.List;

public class Model{
	
	//This is our TrianglePuzzle object
	TrianglePuzzle puzzle; 
	
	//We also need to keep track of the number of swaps the player has done
	public int numSwaps = 0; 
	public int score = 60;
	//Variables to check on score
	public boolean t1 = false;
	public boolean t2 = false;
	public boolean t3 = false;
	public boolean t4 = false;
	public boolean t5 = false;
	public boolean t6 = false;
	
	public List<Color> top;
	public List<Color> mid;
	public List<Color> bot;
	
	
	public Model( ) {
				
		resetModel(top, mid, bot);
		
	}
	
	public void resetModel(List<Color> top, List<Color> mid, List<Color> bot) {
		
		// I am instantiating the puzzle itself. 
		puzzle  =  new TrianglePuzzle(4, 7);
				
		top = puzzle.currentState.getTop();
		mid = puzzle.currentState.getMid();
		bot = puzzle.currentState.getBot();

		// Here I am adding all of my nodes for the triangle puzzle
		puzzle.addNode(new Node(1, 4, 3, puzzle));
				
		puzzle.addNode(new Node(2, 3, 5, puzzle));
		puzzle.addNode(new Node(3, 5, 5, puzzle));
				
		puzzle.addNode(new Node(4, 2, 7, puzzle));
		puzzle.addNode(new Node(5, 4, 7, puzzle));
		puzzle.addNode(new Node(6, 6, 7, puzzle));
				
		puzzle.addNode(new Node(7, 1, 9, puzzle));
		puzzle.addNode(new Node(8, 3, 9, puzzle));
		puzzle.addNode(new Node(9, 5, 9, puzzle));
		puzzle.addNode(new Node(10, 7, 9, puzzle));
		
		// With all the nodes created, I can now make my edges
		//These are made in the same order that the state's edges are, so
		//we should be able to do a simple swap trick
		//Starting with the top row
		puzzle.addEdge(new Edge(0, 0, puzzle.nodes.get(0), puzzle.nodes.get(1), 
				top.get(0)));
		puzzle.addEdge(new Edge(0, 1, puzzle.nodes.get(1), puzzle.nodes.get(2), 
				top.get(1)));
		puzzle.addEdge(new Edge(0, 2, puzzle.nodes.get(0), puzzle.nodes.get(2), 
				top.get(2)));
				
		//And now for the middle row
		puzzle.addEdge(new Edge(1, 0, puzzle.nodes.get(1), puzzle.nodes.get(3), 
				mid.get(0)));
		puzzle.addEdge(new Edge(1, 1, puzzle.nodes.get(3), puzzle.nodes.get(4), 
				mid.get(1)));
		puzzle.addEdge(new Edge(1, 2, puzzle.nodes.get(1), puzzle.nodes.get(4), 
				mid.get(2)));
		puzzle.addEdge(new Edge(1, 3, puzzle.nodes.get(4), puzzle.nodes.get(2), 
				mid.get(3)));
		puzzle.addEdge(new Edge(1, 4, puzzle.nodes.get(4), puzzle.nodes.get(5), 
				mid.get(4)));
		puzzle.addEdge(new Edge(1, 5, puzzle.nodes.get(2), puzzle.nodes.get(5), 
				mid.get(5)));
				
		//And the bottom row
		puzzle.addEdge(new Edge(2, 0, puzzle.nodes.get(3), puzzle.nodes.get(6), 
				bot.get(0)));
		puzzle.addEdge(new Edge(2, 1, puzzle.nodes.get(6), puzzle.nodes.get(7), 
				bot.get(1)));
		puzzle.addEdge(new Edge(2, 2, puzzle.nodes.get(3), puzzle.nodes.get(7), 
				bot.get(2)));
		puzzle.addEdge(new Edge(2, 3, puzzle.nodes.get(4), puzzle.nodes.get(7), 
				bot.get(3)));
		puzzle.addEdge(new Edge(2, 4, puzzle.nodes.get(7), puzzle.nodes.get(8), 
				bot.get(4)));
		puzzle.addEdge(new Edge(2, 5, puzzle.nodes.get(4), puzzle.nodes.get(8), 
				bot.get(5)));
		puzzle.addEdge(new Edge(2, 6, puzzle.nodes.get(5), puzzle.nodes.get(8), 
				bot.get(6)));
		puzzle.addEdge(new Edge(2, 7, puzzle.nodes.get(8), puzzle.nodes.get(9), 
				bot.get(7)));
		puzzle.addEdge(new Edge(2, 8, puzzle.nodes.get(5), puzzle.nodes.get(9), 
				bot.get(8)));
		
	}

	public TrianglePuzzle getTrianglePuzzle() { return puzzle; }

	public int getNumSwaps() {
		return numSwaps;
	}
	
	public int getScore() {
		return score;
	}
	
	public void resetNumSwaps() {
		numSwaps = 0;
	}
	
	public void resetScore() {
		score = 60;
	}
	
}



