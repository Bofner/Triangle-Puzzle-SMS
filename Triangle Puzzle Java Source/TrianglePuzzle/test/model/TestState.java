package model;

import static org.junit.jupiter.api.Assertions.*;

import java.awt.Color;

import org.junit.jupiter.api.Test;

class TestState {

	@Test
	void testGetSet() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node nodeA = new Node(1, 0, 2, tp); 
		Node nodeB = new Node(2, 0, 1, tp);
		Edge e = new Edge(0, 1, nodeA, nodeB, Color.red);
		
		tp.initialState.setTop(Color.red, Color.blue, Color.green);
		assertEquals(tp.initialState.top, tp.initialState.getTop() );
		
		tp.initialState.setMid(Color.red, Color.blue, Color.green, Color.red, Color.blue, Color.green);
		assertEquals(tp.initialState.mid, tp.initialState.getMid() );
		
		tp.initialState.setBot(Color.red, Color.blue, Color.green, Color.red, Color.blue, Color.green, Color.red, Color.blue, Color.green);
		assertEquals(tp.initialState.bot, tp.initialState.getBot() );
		
		
	}

}
