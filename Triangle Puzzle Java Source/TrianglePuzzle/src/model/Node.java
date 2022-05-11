package model;

public class Node {
	
	public int id;
	
	public int col;
	public int row;
	
	public TrianglePuzzle trianglePuzzle;
	
	public boolean selectStatus;
	
	public Node(int id, int col, int row, TrianglePuzzle tp) {
		this.id = id;
		this.col = col;
		this.row = row;
		this.selectStatus = false;
		this.trianglePuzzle = tp;
	}
	
	
	public void setCol(int c) {this.col = c;}
	public void setRow(int r) {this.row = r;}
	
	public void setSelected() {
		//After we win, we don't want to be able to select any nodes
		if((trianglePuzzle.currentState.all.equals(trianglePuzzle.finalState.all)) == false) {
			this.selectStatus = true;
		}

		
	}
	public void setUnselected() {
		this.selectStatus = false;
	}
	
	public int getCol() {return this.col;}
	public int getRow() {return this.row;}
	
	public boolean getSelectStatus() {return this.selectStatus;}


	public boolean contains(Coordinate c) {
		
		if(c.col == col && c.row == row) {
			return true;
		}
		
		return false;
		
	}


}
