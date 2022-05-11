package model;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class TestNode {

	@Test
	void testConstruction() {
		TrianglePuzzle tp = null;
		Node node = new Node(1, 0, 2, tp); 
		assertEquals(1, node.id);
		assertEquals(0, node.col);
		assertEquals(2, node.row);
		assertEquals(tp, node.trianglePuzzle);
	}
	
	@Test
	void testSet() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node node = new Node(1, 0, 2, tp); 
		node.setCol(3);
		node.setRow(4);
		node.setUnselected();
		assertEquals(3,node.col);
		assertEquals(4,node.row);
		assertEquals(false, node.selectStatus);
		node.setSelected();
		assertEquals(true, node.selectStatus);
		;
	}
	@Test
	void testGet() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node node = new Node(1, 0, 2, tp); 
		int col = node.getCol();
		int row = node.getRow();
		assertEquals(col,node.getCol());
		assertEquals(row,node.getRow());
		assertEquals(false, node.getSelectStatus());
	}
	
	@Test
	void testContains() {
		TrianglePuzzle tp  =  new TrianglePuzzle(4, 7);
		Node node = new Node(1, 0, 2, tp); 
		Coordinate c = new Coordinate(0,2);
		Coordinate notC = new Coordinate(1,3);
		assertEquals(true, node.contains(c));
		assertEquals(false, node.contains(notC));
	}

}
