package view;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;

import javax.swing.JPanel;

import model.Coordinate;
import model.Edge;
import model.Model;
import model.Node;
import model.TrianglePuzzle;

//Draw our triangle puzzle
public class DrawingPanel extends JPanel {
	
	Model model;
	public static final int nodeSize = 30;

	/**
	 * Create the panel.
	 */
	public DrawingPanel(Model m) {
		this.model = m;
	}
	
	
	public Rectangle calcRectNode(Node n) {
		int col = n.getCol();
		int row = n.getRow();
		Rectangle rect = new Rectangle(col * nodeSize, row * nodeSize, 
				nodeSize, nodeSize);
		return rect;
	}
	
	public Coordinate pointToCoordinate(Point p) {
		return new Coordinate(p.x/nodeSize, p.y/nodeSize);
	}
	 

	@Override
	public void paintComponent(Graphics g){
		Graphics2D g2 = (Graphics2D) g;
		super.paintComponent(g);
		
		if(model == null) {return;} // Special window builder stuff
		
		
		TrianglePuzzle trianglePuzzle =  model.getTrianglePuzzle();
		
		
		int offset = 15;
		
		//Draw our edges
		for(Edge e : trianglePuzzle.edges) {
			
			g.setColor(e.color);
			g2.setStroke(new BasicStroke(6));
			g.drawLine(e.coordX1 * nodeSize + offset,
					e.coordY1 * nodeSize + offset,
					e.coordX2 * nodeSize  + offset,
					e.coordY2 * nodeSize + offset);
			
		}
		
		//Draw our nodes so they have priority over our edges
				for(Node n : trianglePuzzle) {
					
					if(n.getSelectStatus()) {
						g.setColor(Color.gray);
					}
					else {
						g.setColor(Color.black);
					}
					Rectangle r = calcRectNode(n);
					g.fillRect(r.x, r.y, r.width, r.height);
					
				}
		
	}
	
	
}
