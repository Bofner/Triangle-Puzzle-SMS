# Triangle Puzzle SMS

The first (non-text based) video game I ever created to completion was a Java game called Triangle Puzzle that was assigned as the first project of a software engineering course that I took in graduate school (source code included in this repository!). It's a simple game, just match the edges of the triangles to the solution to win, but it taught me a lot about object oriented programming, and how to organize both my ideas, and my code. Now that I'm starting my journey into a deep understanding of Z80 assembly and the Sega Master System, I thought, what better game to start with than good old Triangle Puzzle!

Here's a run-down of what I've accomplished

Most importantly, it runs on real Sega Master System Hardware:

![](https://github.com/Bofner/Triangle-Puzzle-SMS/blob/main/images/realHardware.gif)

When three nodes are selected that encapsulate 2 edges, those edges colors can be swapped:

![](https://github.com/Bofner/Triangle-Puzzle-SMS/blob/main/images/swap.gif)

When three nodes of a triangle are selected, the edges rotate counter clockwise:

![](https://github.com/Bofner/Triangle-Puzzle-SMS/blob/main/images/rotate.gif)

All nodes may be unselected at once:

![](https://github.com/Bofner/Triangle-Puzzle-SMS/blob/main/images/unselect%20all.gif)

The puzzle can be reset to the starting state:

![](https://github.com/Bofner/Triangle-Puzzle-SMS/blob/main/images/reset.gif)

And the puzzle can be solved!

![](https://github.com/Bofner/Triangle-Puzzle-SMS/blob/main/images/youWin.gif)

There's still some more things to be fixed cosmetically, but functionally, the game works just as it was assigned in class, but for the Sega Master System!

## Updates:

#### Update: 5/19/2022

Added a Dev studio splash screen. Added a title screen. Added a way to restart the game after winning. Made it so that the Pause button shows the solution you are working
towards. Added a secret way to change the palette of the puzzle. 


#### Update: 5/12/2022

Score font now matches the rest of the font in game! Couldn't end up using HBlank for bad choices during programming, but the end result is the same as it would have been.


#### Update: 5/12/2022

Score now works! Sprites are 8x8... for now. Working on an HBlank swap between 8x16 and 8x8 for tall score numbers. It works, but gives some glitches, so it's been left out


#### Launch: 5/11/2022

All features are present, at least in the back end. Still need to work out getting the score to display on screen, and other cosmetic fun stuff

