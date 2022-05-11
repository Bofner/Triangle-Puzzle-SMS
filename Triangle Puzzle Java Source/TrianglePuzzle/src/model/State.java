package model;

import java.awt.Color;
import java.util.List;

public class State {
	
	// TrianglePuzzle is made up of a top, two middle, and three bottom
	// triangles, so we model that with the state class. 
	//NOTE: top, mid and bot are a bit archaic. They helped me think of how to
	//organize it as a human, but they didn't end up getting used. 
	public List<Color> top;
	public List<Color> mid;
	public List<Color> bot;
	public List<Color> all;
	
	public State(List<Color> top, List<Color> mid, List<Color> bot ) {
		
		this.top = top;	
		this.mid = mid;
		this.bot = bot;
		//Here we are making a single big state
		this.all = top;
		this.all.addAll(mid);
		this.all.addAll(bot);
		
		
	}
	
	// Setting the state. Starts with left most edge and moves clock-wise
	public void setTop(Color a, Color b, Color c) {
		
		this.top.add(a);
		this.top.add(b);
		this.top.add(c);
		
	}
	
	// Setting the state. Starts with left most edge of left-most triangle
	// and moves clock-wise and to the right
	public void setMid(Color a, Color b, Color c, Color d, Color e, Color f) {
		
		this.mid.add(a);
		this.mid.add(b);
		this.mid.add(c);
		this.mid.add(d);
		this.mid.add(e);
		this.mid.add(f);
		
	}
	
	// Setting the state. Starts with left most edge of left-most triangle
	// and moves clock-wise and to the right
	public void setBot(Color a, Color b, Color c, Color d, Color e, Color f,
			Color g, Color h, Color i) {
		
		this.bot.add(a);
		this.bot.add(b);
		this.bot.add(c);
		this.bot.add(d);
		this.bot.add(e);
		this.bot.add(f);
		this.bot.add(g);
		this.bot.add(h);
		this.bot.add(i);
		
	}
	
	
	public List<Color> getTop() { return top; }
	public List<Color> getMid() { return mid; }
	public List<Color> getBot() { return bot; }
	
	
	
}
