package model;

import java.awt.Color;
import java.util.*;

public class Edge {
	//Which nodes belong to this edge... these can change, but there
	//will always only be two of them
	public Node nodeA;
	public Node nodeB;
	public int nodeIDA;
	public int nodeIDB;
	
	//Top, middle or bottom, represented with 1, 2 or3 respectively
	public int posY;
	//Position in top, mid or bot array
	public int posX;
	
	//Coordinates for drawing our edge as a line
	public int coordX1;
	public int coordX2;
	public int coordY1;
	public int coordY2;
	
	//Becomes activated when both nodes are selected
	public boolean isActivated = false;
	
	
	//Color of our edge, which will correspond to the State array
	public Color color; 
	
	public Edge(int posY, int posX, Node a, Node b, Color c) {
		
		this.posX = posX;
		this.posY = posY;
		this.nodeA = a; 
		this.nodeB = b;
		this.nodeIDA = a.id;
		this.nodeIDB = b.id;
		this.color = c;
		
		this.coordX1 = a.col;
		this.coordY1 = a.row;
		this.coordX2 = b.col;
		this.coordY2 = b.row;
		
		
	}
	
	public boolean edgeActivation() {
		
		if(this.nodeA.getSelectStatus() && this.nodeB.getSelectStatus()) {
			this.isActivated = true;
			return true;
		}
		else{
			this.isActivated = false;
			return false;
		}
	}
	
	//Our standard 2 edge swap method
	public void swapEdge(Edge e) {
		
		//The only thing that matters for the win state is the color, so that's
		//all that I really need to be swapping
		Color tempColor = this.color;
		this.color = e.color;	
		e.color = tempColor;
		
		
	}
	
	//Our 3 edge triangle edge swap method
		public void cycleEdges(Edge e, Edge f) {
			
			//The only thing that matters for the win state is the color, so that's
			//all that I really need to be swapping
			Color tempColorE = e.color;
			Color tempColorF = f.color;
			e.color = this.color;	
			f.color = tempColorE;
			this.color = tempColorF;
			
		}
	
	public Color getEdgeColor() {
		return this.color;
	}
	
	
	
}
