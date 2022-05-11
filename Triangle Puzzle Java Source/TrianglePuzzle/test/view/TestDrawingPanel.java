package view;

import java.awt.Color;

import javax.swing.JFrame;

import org.junit.After;
import org.junit.Before;
import org.junit.jupiter.api.Test;

import model.Edge;
import model.Model;
import model.Node;
import model.TrianglePuzzle;

class TestDrawingPanel {
	
/*
	@Before
	public void setUp() {
		TrianglePuzzle tp = new TrianglePuzzle(4, 7);;
		Node nodeA;
		Node nodeB;
		Edge e;
		Model m = new Model();
		TrianglePuzzleApp app = new TrianglePuzzleApp(m);
		nodeA = new Node(1, 0, 2, tp); 
		nodeB = new Node(2, 0, 1, tp);
		e = new Edge(0, 1, nodeA, nodeB, Color.red);
		
	
		
		app.setVisible(true);
	}
	
	@After
	public void takeDown() {
		Model m = new Model();
		TrianglePuzzleApp app = new TrianglePuzzleApp(m);
		app.setVisible(false);
	}
	
	*/
	
	@Test
	public void testObjects() {
		TrianglePuzzle tp = new TrianglePuzzle(4, 7);
		Node nodeA = new Node(1, 0, 2, tp); 
		Model m = new Model();
		TrianglePuzzleApp app = new TrianglePuzzleApp(m);
		app.drawingPanel.calcRectNode(nodeA);
		
	}

}
