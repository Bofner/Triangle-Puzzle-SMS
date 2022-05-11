package model;

import static org.junit.jupiter.api.Assertions.*;

import java.awt.Color;

import org.junit.jupiter.api.Test;

class TestModel {

	@Test
	void testModelMethods() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node nodeA = new Node(1, 0, 2, tp); 
		Node nodeB = new Node(2, 0, 1, tp);
		Edge e = new Edge(0, 1, nodeA, nodeB, Color.red);
		
		Model m = new Model();
		
		assertEquals(m.puzzle, m.getTrianglePuzzle());
		assertEquals(m.numSwaps, m.getNumSwaps());
		assertEquals(m.score, m.getScore());
		
	}
	 
	@Test
	void testResets() {
		Model m = new Model();
		m.score = 55;
		assertNotEquals(60, m.score);
		m.resetScore();
		assertEquals(60, m.score);
		
		m.numSwaps = 55;
		assertNotEquals(0, m.getNumSwaps());
		m.resetNumSwaps();
		assertEquals(0,m.getNumSwaps());
		
	}

}
