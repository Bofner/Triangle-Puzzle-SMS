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
;------------------------------
;Hundreds digit BOTTOM
    sprNum6     db
    hw6         db
    y6          db
    x6          db 
    cc6         db
    sprSize6    db

;Tens digit BOTTOM
    sprNum7     db
    hw7         db
    y7          db
    x7          db 
    cc7         db
    sprSize7    db
;Ones digit BOTTOM
    sprNum8     db
    hw8         db
    y8          db
    x8          db 
    cc8         db
    sprSize8    db

;MOVES
;Tens digit BOTTOM
    sprNum9     db
    hw9         db
    y9          db
    x9          db 
    cc9         db
    sprSize9    db
;Ones Digit BOTTOM
    sprNumA     db
    hwA         db
    yA          db
    xA          db 
    ccA         db
    sprSizeA    db

.endst

;==============================================================
; Current Palette structure
;==============================================================
.struct paletteStruct
    color0      db
    color1      db
    color2      db
    color3      db
    color4      db
    color5      db
    color6      db
    color7      db
    color8      db
    color9      db
    colorA      db
    colorB      db
    colorC      db
    colorD      db
    colorE      db
    colorF      db
.endst

;==============================================================
; SFS Shimmer
;==============================================================
.struct shimmerStruct
    sprNum      db      ;The draw-number of the sprite      
    hw          db      ;The hight and width of the entire OBJ
    y           db      ;The Y coord of the OBJ
    x           db      ;The X coord of the OBJ
    cc          db      ;The first character code for the OBJ 
    sprSize     db      ;The total area of the OBJ
.endst
