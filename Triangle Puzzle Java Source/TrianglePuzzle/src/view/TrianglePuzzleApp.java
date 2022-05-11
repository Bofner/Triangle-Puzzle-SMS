package view;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import controllers.ResetPuzzleController;
import controllers.SelectNodeController;
import controllers.SwapEdgeController;
import controllers.UnselectAllController;
import model.Model;
import model.Node;

import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import java.awt.Color;
import javax.swing.JButton;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;

import javax.swing.JTextField;
import javax.swing.LayoutStyle.ComponentPlacement;

public class TrianglePuzzleApp extends JFrame {

	private JPanel contentPane;
	private JTextField txtTrianglePuzzle;
	private JTextField txtScore;
	private JTextField txtMoves;

	Model model;
	public DrawingPanel drawingPanel;
	JButton btnUnselectAll;  
	JButton btnSwapColors; 
	JButton btnResetPuzzle;
	JLabel numSwaps;
	JLabel score;
	public JLabel youWin;
	
	public DrawingPanel getDrawingPanel() {return drawingPanel;}
	public JButton getUnselectAllButton() {return btnUnselectAll;}
	public JButton getSwapColorsButton() {return btnSwapColors;}
	public JButton getResetPuzzleButton() {return btnResetPuzzle;}
	public JLabel getNumSwaps() {return numSwaps;}
	public JLabel getScore() {return score;}


	
	/**
	 * Launch the application.
	 
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					TrianglePuzzleApp frame = new TrianglePuzzleApp();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	*/

	/**
	 * Create the frame.
	 */
	public TrianglePuzzleApp(Model m) {
		super();
		this.model = m;
		setTitle("Triangle Puzzle App");
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 640, 480);
		contentPane = new JPanel();
		contentPane.setBackground(Color.LIGHT_GRAY);
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		
		drawingPanel = new DrawingPanel(model);
		
		
		
		//Adding our mouse event listener
		drawingPanel.addMouseListener(new MouseAdapter() {
			
			//Whenever mouse clicked in app, it gets dedicated to the controller
			@Override
			public void mousePressed(MouseEvent me) {
				
				new SelectNodeController(model, TrianglePuzzleApp.this).process(me.getPoint());
				
			}
			
		});
		
		
		txtTrianglePuzzle = new JTextField();
		txtTrianglePuzzle.setEditable(false);
		txtTrianglePuzzle.setBackground(Color.LIGHT_GRAY);
		txtTrianglePuzzle.setFont(new Font("Tahoma", Font.PLAIN, 34));
		txtTrianglePuzzle.setText("Triangle Puzzle");
		txtTrianglePuzzle.setColumns(10);
		
		txtScore = new JTextField();
		txtScore.setEditable(false);
		txtScore.setBackground(Color.LIGHT_GRAY);
		txtScore.setFont(new Font("Tahoma", Font.PLAIN, 20));
		txtScore.setText("Score:");
		txtScore.setColumns(10);
		
		txtMoves = new JTextField();
		txtMoves.setEditable(false);
		txtMoves.setBackground(Color.LIGHT_GRAY);
		txtMoves.setFont(new Font("Tahoma", Font.PLAIN, 20));
		txtMoves.setText("Moves:");
		txtMoves.setColumns(10);
		
		btnSwapColors = new JButton("Swap Colors");
		btnSwapColors.setForeground(Color.BLUE);
		btnSwapColors.setFont(new Font("Tahoma", Font.PLAIN, 36));
		btnSwapColors.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				
				new SwapEdgeController(model, TrianglePuzzleApp.this).swap();
				
			}
			
		});
		
		btnUnselectAll = new JButton("Unselect All");
		btnUnselectAll.setForeground(new Color(0, 128, 0));
		btnUnselectAll.setFont(new Font("Tahoma", Font.PLAIN, 36));
		btnUnselectAll.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				
				new UnselectAllController(model, TrianglePuzzleApp.this).unselectAll();
				
			}
			
		});
		
		btnResetPuzzle  = new JButton("Reset Puzzle");
		btnResetPuzzle.setForeground(Color.RED);
		btnResetPuzzle.setFont(new Font("Tahoma", Font.PLAIN, 36));
		btnResetPuzzle.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				
				new ResetPuzzleController(model, TrianglePuzzleApp.this).resetPuzzle();
				
			}
		});
		
		numSwaps = new JLabel("" + model.getNumSwaps());
		numSwaps.setFont(new Font("Tahoma", Font.PLAIN, 20));
		
		score = new JLabel("" + model.getScore());
		score.setFont(new Font("Tahoma", Font.PLAIN, 20));
		GroupLayout gl_contentPane = new GroupLayout(contentPane);
		gl_contentPane.setHorizontalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addContainerGap()
					.addComponent(drawingPanel, GroupLayout.PREFERRED_SIZE, 271, GroupLayout.PREFERRED_SIZE)
					.addGap(63)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.TRAILING)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addGroup(gl_contentPane.createParallelGroup(Alignment.TRAILING)
								.addComponent(btnUnselectAll, Alignment.LEADING, GroupLayout.DEFAULT_SIZE, 246, Short.MAX_VALUE)
								.addGroup(gl_contentPane.createSequentialGroup()
									.addPreferredGap(ComponentPlacement.RELATED)
									.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
										.addComponent(btnSwapColors, GroupLayout.PREFERRED_SIZE, 242, GroupLayout.PREFERRED_SIZE)
										.addComponent(txtTrianglePuzzle, GroupLayout.DEFAULT_SIZE, 246, Short.MAX_VALUE)
										.addGroup(gl_contentPane.createSequentialGroup()
											.addGroup(gl_contentPane.createParallelGroup(Alignment.TRAILING, false)
												.addComponent(txtScore, Alignment.LEADING, 0, 0, Short.MAX_VALUE)
												.addComponent(txtMoves, Alignment.LEADING, GroupLayout.DEFAULT_SIZE, 76, Short.MAX_VALUE))
											.addPreferredGap(ComponentPlacement.RELATED)
											.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
												.addComponent(score, GroupLayout.PREFERRED_SIZE, 45, GroupLayout.PREFERRED_SIZE)
												.addComponent(numSwaps, GroupLayout.PREFERRED_SIZE, 45, GroupLayout.PREFERRED_SIZE))))))
							.addGap(36))
						.addGroup(gl_contentPane.createSequentialGroup()
							.addComponent(btnResetPuzzle, GroupLayout.PREFERRED_SIZE, 242, GroupLayout.PREFERRED_SIZE)
							.addContainerGap(40, Short.MAX_VALUE))))
		);
		gl_contentPane.setVerticalGroup(
			gl_contentPane.createParallelGroup(Alignment.TRAILING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addContainerGap()
					.addGroup(gl_contentPane.createParallelGroup(Alignment.TRAILING)
						.addComponent(drawingPanel, GroupLayout.PREFERRED_SIZE, 412, GroupLayout.PREFERRED_SIZE)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addComponent(txtTrianglePuzzle, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
							.addPreferredGap(ComponentPlacement.UNRELATED)
							.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
								.addComponent(txtScore, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
								.addComponent(score, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE))
							.addGap(18)
							.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING, false)
								.addComponent(numSwaps, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
								.addComponent(txtMoves, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
							.addPreferredGap(ComponentPlacement.RELATED, 20, Short.MAX_VALUE)
							.addComponent(btnSwapColors, GroupLayout.PREFERRED_SIZE, 73, GroupLayout.PREFERRED_SIZE)
							.addGap(18)
							.addComponent(btnUnselectAll, GroupLayout.PREFERRED_SIZE, 73, GroupLayout.PREFERRED_SIZE)
							.addGap(18)
							.addComponent(btnResetPuzzle, GroupLayout.PREFERRED_SIZE, 73, GroupLayout.PREFERRED_SIZE)))
					.addGap(21))
		);
		
		youWin = new JLabel("YOU WIN!!");
		youWin.setFont(new Font("Tahoma", Font.PLAIN, 42));
		contentPane.setLayout(gl_contentPane);
		UpdateButtons.enableButtons(this, model.getTrianglePuzzle());
	}
}
