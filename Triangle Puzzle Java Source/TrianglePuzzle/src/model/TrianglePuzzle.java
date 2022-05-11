package model;
import java.awt.Color;
import java.util.*;

public class TrianglePuzzle implements Iterable<Node>{
	ArrayList<Node> nodes = new ArrayList<>();
	public ArrayList<Edge> edges = new ArrayList<>();
	
	public ArrayList<Color> initTop = new ArrayList<>(); 
	public ArrayList<Color> initMid = new ArrayList<>(); 
	public ArrayList<Color> initBot = new ArrayList<>(); 
	
	public ArrayList<Color> curTop = new ArrayList<>(); 
	public ArrayList<Color> curMid = new ArrayList<>(); 
	public ArrayList<Color> curBot = new ArrayList<>(); 
	
	public ArrayList<Color> finTop = new ArrayList<>(); 
	public ArrayList<Color> finMid = new ArrayList<>(); 
	public ArrayList<Color> finBot = new ArrayList<>(); 
	
	int rows;
	int cols;
	
	//The state of our edges in TrianglePuzzle
	public State initialState;
	public State currentState;
	public State finalState; 
	
	
	// The puzzle is made up of a box with rows, columns, and a current state,
	// which by default is the initial state, though that will change as
	// the player tries to solve the puzzle
	public TrianglePuzzle(int rows, int cols){
		
		this.rows = rows;
		this.cols = cols;
		
		//Manually setting up our initial state
		initTop.add(Color.red);
		initTop.add(Color.green);
		initTop.add(Color.red);
		//Middle triangle
		initMid.add(Color.red);
		initMid.add(Color.green);
		initMid.add(Color.blue);
		initMid.add(Color.blue);
		initMid.add(Color.green);
		initMid.add(Color.red);
		//Bottom Triangles
		initBot.add(Color.red);
		initBot.add(Color.green);
		initBot.add(Color.blue);
		initBot.add(Color.blue);
		initBot.add(Color.green);
		initBot.add(Color.blue);
		initBot.add(Color.blue);
		initBot.add(Color.green);
		initBot.add(Color.red);
		
		
		//No idea why, but I have to do this for current state as well... augh
		//Top triangle
		curTop.add(Color.red);
		curTop.add(Color.green);
		curTop.add(Color.red);
		//Middle triangle
		curMid.add(Color.red);
		curMid.add(Color.green);
		curMid.add(Color.blue);
		curMid.add(Color.blue);
		curMid.add(Color.green);
		curMid.add(Color.red);
		//Bottom Triangles
		curBot.add(Color.red);
		curBot.add(Color.green);
		curBot.add(Color.blue);
		curBot.add(Color.blue);
		curBot.add(Color.green);
		curBot.add(Color.blue);
		curBot.add(Color.blue);
		curBot.add(Color.green);
		curBot.add(Color.red);
		
		//And now we do it for the final state
		
		finTop.add(Color.red);
		finTop.add(Color.red);
		finTop.add(Color.red);
		//Middle triangle
		finMid.add(Color.blue);
		finMid.add(Color.blue);
		finMid.add(Color.blue);
		finMid.add(Color.green);
		finMid.add(Color.green);
		finMid.add(Color.green);
		//Bottom Triangles
		finBot.add(Color.green);
		finBot.add(Color.green);
		finBot.add(Color.green);
		finBot.add(Color.red);
		finBot.add(Color.red);
		finBot.add(Color.red);
		finBot.add(Color.blue);
		finBot.add(Color.blue);
		finBot.add(Color.blue);
		
		//Set starting state
		this.initialState = new State(initTop, initMid, initBot);
		
		//Set win state
		this.finalState = new State(finTop, finMid, finBot);
		
		//Setting our current state
		this.currentState = new State(curTop, curMid, curBot);

	}
	
	//Add a node to our puzzle
	public void addNode(Node n) {
		
		nodes.add(n);
		
	}
	
	
	// Our puzzle will also contain edges
	// These edges will start off in the default state
	// TrianglePuzzle is a specific type of puzzle that has a specific
	// initial and final value
	
	public void addEdge(Edge e) {
		
		edges.add(e);
	
	}
	
	public void resetEdges() {
		//Set starting state
		this.initialState = new State(initTop, initMid, initBot);
				
		//Set win state
		this.finalState = new State(finTop, finMid, finBot);
				
		//Setting our current state
		this.currentState = new State(curTop, curMid, curBot);
	}
	
	//We can grab our nodes from our triangle puzzle
	@Override
	public Iterator<Node> iterator(){
		return nodes.iterator();
	}
	
	 
}
