package model;

import static org.junit.jupiter.api.Assertions.*;

import java.awt.Color;
import java.util.ArrayList;

import org.junit.jupiter.api.Test;

class TestTrianglePuzzle {

	@Test
	void testAdd() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node nodeA = new Node(1, 0, 2, tp); 
		Node nodeB = new Node(2, 0, 1, tp);
		Edge e = new Edge(0, 1, nodeA, nodeB, Color.red);
		
		tp.addNode(nodeA);
		
		tp.addNode(nodeB);
		
		tp.addEdge(e);
		
		assertEquals(1, tp.edges.size());
		int count = 0;

		for(Node n: tp) {
			count++;
		}
		assertEquals(count, 2);
		
	}
	
	@Test
	//I discovered a bug with this one! The fix is horribly inefficient, but it works
	void testReset() {
		TrianglePuzzle tri  =  new TrianglePuzzle(4, 7);
		Node nodeA = new Node(1, 0, 2, tri); 
		Node nodeB = new Node(2, 0, 1, tri);
		Edge e = new Edge(0, 1, nodeA, nodeB, Color.red);
		
		ArrayList<Color> testMid = new ArrayList<>(); 
		testMid.add(Color.red);
		testMid.add(Color.green);
		testMid.add(Color.blue);
		testMid.add(Color.blue);
		testMid.add(Color.green);
		testMid.add(Color.red);
		
		assertEquals(testMid, tri.initialState.getMid());
		
		tri.initialState.setTop(Color.red, Color.blue, Color.green);
		assertEquals(tri.initialState.top, tri.initialState.getTop() );
		
		tri.initialState.setMid(Color.red, Color.blue, Color.green, Color.red, Color.blue, Color.green);
		assertEquals(tri.initialState.mid, tri.initialState.getMid() );
		
		tri.initialState.setBot(Color.red, Color.blue, Color.green, Color.red, Color.blue, Color.green, Color.red, Color.blue, Color.green);
		assertEquals(tri.initialState.bot, tri.initialState.getBot() );
		
		assertNotEquals(testMid, tri.initialState.getMid());
		
		tri.resetEdges();
		
		assertEquals(testMid, tri.initialState.getMid());
		
		
		
	}

}
