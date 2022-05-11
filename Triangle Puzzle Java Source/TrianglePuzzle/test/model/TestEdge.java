package model;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import java.awt.Color;

public class TestEdge {
	
	@Test
	void testConstruction() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node nodeA = new Node(1, 0, 2, tp); 
		Node nodeB = new Node(2, 0, 1, tp);
		Edge e = new Edge(0, 1, nodeA, nodeB, Color.red);
		assertEquals(Color.red, e.color);
		assertEquals(nodeA, e.nodeA);
		assertEquals(nodeB, e.nodeB);
		
	}
	
	@Test
	void testActivation() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node nodeA = new Node(1, 0, 2, tp); 
		Node nodeB = new Node(2, 0, 1, tp);
		Edge e = new Edge(0, 1, nodeA, nodeB, Color.red);
		assertEquals(false, e.edgeActivation());
		nodeA.setSelected();
		nodeB.setSelected();
		assertEquals(true, e.edgeActivation());
		
		assertEquals(Color.red, e.getEdgeColor());
	}
	
	@Test
	void testSwaps() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node nodeA = new Node(1, 4, 3, tp); 
		
		Node nodeB = new Node(2, 3, 5, tp);
		Node nodeC = new Node(3, 5, 5, tp); //swap 2
		
		Node nodeD = new Node(4, 2, 7, tp); //swap 3
		Edge e1 = new Edge(0, 0, nodeA, nodeB, Color.red);
		Edge e2 = new Edge(0, 1, nodeA, nodeC, Color.green);
		Edge e3 = new Edge(0, 2, nodeB, nodeC, Color.blue); //swap 3
		
		Edge e4 = new Edge(1, 0, nodeB, nodeD, Color.green);
		e1.swapEdge(e2);
		assertEquals(Color.green, e1.color);
		e1.swapEdge(e2);
		assertEquals(Color.red, e1.color);
		
		e1.cycleEdges(e2, e3);
		assertEquals(Color.green, e3.color);
		assertEquals(Color.blue, e1.color);
		assertEquals(Color.red, e2.color);
		
		
	}
	
}
