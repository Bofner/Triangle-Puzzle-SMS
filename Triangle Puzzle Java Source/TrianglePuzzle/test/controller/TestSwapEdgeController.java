package controller;

import static org.junit.jupiter.api.Assertions.*;

import java.awt.Color;

import org.junit.jupiter.api.Test;

import controllers.SwapEdgeController;
import model.Edge;
import model.Model;
import model.Node;
import model.TrianglePuzzle;
import view.TrianglePuzzleApp;

class TestSwapEdgeController {

	@Test
	void testSwap() {
		
		Model m = new Model();
		
		TrianglePuzzle tp = m.puzzle;
		
Node nodeA = new Node(1, 4, 3, tp); 
		
		Node nodeB = new Node(2, 3, 5, tp);
		Node nodeC = new Node(3, 5, 5, tp); //swap 2
		
		Node nodeD = new Node(4, 2, 7, tp); //swap 3
		TrianglePuzzleApp app = new TrianglePuzzleApp(m);
		
		Edge e1 = new Edge(0, 0, nodeA, nodeB, Color.red);
		Edge e2 = new Edge(0, 1, nodeA, nodeC, Color.green);
		Edge e3 = new Edge(0, 2, nodeB, nodeC, Color.blue); //swap 3
		
		SwapEdgeController swap = new SwapEdgeController(m, app);
		int count = 0;
		for(int i = 0; i <3; i++) {
			for(Node n: tp) {
				if(count<3) {
					n.setSelected();
					count++;
				}
				
			}
		}
		nodeB.setSelected();
		nodeC.setSelected();
		e1.edgeActivation();
		e2.edgeActivation();
		
		swap.swap();
		
		
		
	}

}
