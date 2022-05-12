;==============================================================
;All Structs that are sprites MUST have the following
;==============================================================
/*
    sprNum      db      ;The draw-number of the sprite      
    hw          db      ;The hight and width of the entire OBJ
    y           db      ;The Y coord of the OBJ
    x           db      ;The X coord of the OBJ
    cc          db      ;The first character code for the OBJ 
    sprSize     db      ;The total area of the OBJ
*/

;==============================================================
; Strip structure
;==============================================================
.struct strip
    stripNum    db      ;The ID for the strip
    nodeOne     db      ;Each strip has 2 nodes
    nodeTwo     db      ;
    selected    db      ;If both nodes are selected, edge is selected

    orientation db      ;Is the strip Left, Right or Hori (this will also act as an offset for CC)
                        ;Left = $00, Right = $09, Hori = $12
    initColor   db      ;Color of strip at the start of the puzzle
    finalColor  db      ;Color of strip at the win condition
    color       db      ;Is the strip Red, Green or Blue  
                        ;Red = $00, Green = $03, Blue = $06

    sprNum      db
    hw          db
    y           db
    x           db 
    cc          db
    sprSize     db
.endst

;==============================================================
; Node structure
;==============================================================
.struct node
    nodeNum     db      ;The ID of the node ($00 - $0A)
    nodeRow     db      ;The row the node lies on
    selected    db      ;Selected = $FF, Unselected = $00
    nodeY       db
    nodeX       db
    nodeCC      db
.endst

;==============================================================
; Player Selector structure
;==============================================================
.struct selector
    currentNode db      ;ID of the node being hovered over ($00 - $0A, $FF is in Menu)
    nodeOne     db      ;ID of the first selected node ($00 - $0A, $FF is NULL)
    nodeTwo     db      ;ID of the second selected node ($00 - $0A, $FF is NULL)
    nodeThree   db      ;ID of the third selected node ($00 - $0A, $FF is NULL)
    moveBuffer  db      ;Buffer so our movement isn't too touchy

    sprNum      db
    hw          db
    y           db
    x           db 
    cc          db
    sprSize     db
.endst

;==============================================================
; Player Menu structure
;==============================================================
.struct menuStruct
    status      db      ;Is menu ON ($FF) or OFF ($00)
    position    db      ;Swap = $00, Unselect = $01, Reset = $02
    swapable    db      ;Are we allowed to perform a swap? YES = $FF, NO = $00
    ;moveBuffer  db     We will share with selector struct for ease of use

;Top Left (Menu is made up of 4 different sprites spaced far away)
    sprNum1     db
    hw1         db
    y1          db
    x1          db 
    cc1         db
    sprSize1    db
;Top Right
    sprNum2     db
    hw2         db
    y2          db
    x2          db 
    cc2         db
    sprSize2    db
;Bottom Left
    sprNum3     db
    hw3         db
    y3          db
    x3          db 
    cc3         db
    sprSize3    db
;Bottom Right
    sprNum4     db
    hw4         db
    y4          db
    x4          db 
    cc4         db
    sprSize4    db
.endst

;==============================================================
; Status Bar
;==============================================================
;NOTE This struct will be used with an interrupt, and will utilize 8x16 sprites!
.struct statusBarStruct
    score       db
    moves       db
    triPoints   db              ;Points to add on to the score for complete triangles
    totalScore  db              ;triPoints + score
;SCORE
;Hundreds digit
    sprNum1     db
    hw1         db
    y1          db
    x1          db 
    cc1         db
    sprSize1    db
;Tens digit
    sprNum2     db
    hw2         db
    y2          db
    x2          db 
    cc2         db
    sprSize2    db
;Ones digit
    sprNum3     db
    hw3         db
    y3          db
    x3          db 
    cc3         db
    sprSize3    db

;MOVES
;Tens digit
    sprNum4     db
    hw4         db
    y4          db
    x4          db 
    cc4         db
    sprSize4    db
;Ones Digit
    sprNum5     db
    hw5         db
    y5          db
    x5          db 
    cc5         db
    sprSize5    db

.endst


