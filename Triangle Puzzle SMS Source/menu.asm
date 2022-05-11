;==================================================
; Menu Button Functions
;==================================================
ResetMenu:
;Reset Menu Position
    ld hl, menu.position
    ld a, (hl)                              ;Save position for later
    ld (hl), $00
;Adjust Y coords
    ld c, 0
    cp c
    jr z, +                                 ;If we are already at zero, then just leave
;
    ld b, a                                 ;Use position to determine loop length
-:
    ld hl, menu.y1
    ld a, (hl)
    sub 48
    ld (hl), a
    ld hl, menu.y2
    ld a, (hl)
    sub 48
    ld (hl), a
    ld hl, menu.y3
    ld a, (hl)
    sub 48
    ld (hl), a
    ld hl, menu.y4
    ld a, (hl)
    sub 48
    ld (hl), a
    djnz -

+:
    ret

;==================================================
; Menu Button Actions
;==================================================
PressMenuButton:
    ld hl, menu.position
    ld a, (hl)
;If position is 0, then we will check Swap Edges
    ld c, 0
    cp c
    jp z, CheckSwapable
;If position is 1, then we will Unselect all nodes
    ld c, 1
    cp c
    jp z, UnselectAllNodes
;If position is 2, then we will Reset the puzzle
    ld c, 2
    cp c
    jp z, ResetPuzzle

    ret


UnselectAllNodes:
;Nodes don't change much, so we can just re-initialize them and change their color
    call InitNodes
;Unselect our nodes
    ld b, 10                            ;Cycle through 10 nodes
    ld hl, nodes.1.nodeNum
-:                                      ;djnz LOOP starts here
;Set up the prereqs for unselecting nodes 
    push hl
    push bc
        ld a, (hl)
        ld b, $00
        ld c, a
        ld hl, $0000
;Reset Node Color
        call UpdateUnselectedNodeColor 
    pop bc
    pop hl   
;Reset Next Node
    ld de, nodeSize                     ;Pointer adjuster for nextNode.nodeNum
    add hl, de                          ;HL points to nextNode.nodeNum
    djnz -

;Update our global to shwo that no nodes are selected
    ld hl, numSelectedNodes
    ld (hl), $00

;We will need to reset the strip.Selected though
    call UpdateStripSelectedness

;SelectedStripNums
    call UpdateSelectedStripAll

    call TriangleMode

    ret


ResetPuzzle:
;Reinitialize Nodes
    call UnselectAllNodes
;Reinitialize Strips
    call InitStrips
;Reinitialize Selector
    call InitSelector
;Set up out Movement buffer so we don't get double inputs after we reinitialize the buffer
    ld hl, player.moveBuffer
    ld (hl), $10
;Reinitialize Menu
    call InitMenu
;Reinitialize StatusBar
    call InitStatusBar
;SelectedStripNums
    call UpdateSelectedStripAll
;Redraw our strips
    call DrawStrips


    ret


CheckSwapable:
    ld a, (menu.swapable)
    ld c, $FF
    cp c
    jp z, SwapStrips

    ret


SwapStrips:
;Set up out Movement buffer so we don't get double inputs after we reinitialize the buffer
    ld hl, player.moveBuffer
    ld (hl), $10
;Update Score
    ld hl, statusBar.score
    dec (hl)                                    ;Score goes minus 1 for each move
    inc hl                                      ;ld hl, statusBar.moves
    inc (hl)                                    ;Moves increased every time we swap

;Update Moves


;How many colors are we swapping?
    ld a, (numSelectedStrips)
    ld c, 3
    cp c
    jp z, SwapThree
    jp SwapTwo


;This is the easier, standard swap between two colors
SwapTwo:
;Point to the first selected strip color
    ld hl, selectedStripOne                             ;Take the first strip
    ld a, (hl)
    call PointToCurrentStrip                            ;ld hl, selectedStripOne.stripNum
    ld bc, $0007
    add hl, bc                                          ;ld hl, selectedStripOne.color
    ld d, h
    ld e, l                                             ;ld de, selectedStripOne.stripNum

;Point to the second selected strip color
    ld hl, selectedStripTwo                             ;Take the first strip
    ld a, (hl)
    call PointToCurrentStrip                            ;ld hl, selectedStripTwo.stripNum
    ld bc, $0007
    add hl, bc                                          ;ld hl, selectedStripTwo.color

;Swap Colors (DE = selectedStripOne.color, HL = selectedStripTwo.color)
    ld a, (de)                                          
    ld b, a                                             ;ld b, (selectedStripOne.color)
    ld a, (hl)                                          ;ld a, (selectedStripTwo.color)
    ld (de), a                      
    ld (hl), b                                          ;Colors have been swapped

;Update CC (DE = selectedStripOne.color, HL = selectedStripTwo.color) 
;Update the first strip 
    ld a, (de)                                          ;ld a, (selectedStripOne.color)               
    dec de                                              ;ld de, finalColor
    dec de                                              ;ld de, initColor
    dec de                                              ;ld de, orientation
    push hl
        ld h, d
        ld l, e                                             ;ld hl, selectedStripOne.orientation
        call AdjustSelectedNodeCC
    pop hl                                              ;ld hl, selectedStripTwo.color
;Update the second strip
    ld a, (hl)                                          ;ld a, (selectedStripOne.color)               
    dec hl                                              ;ld hl, finalColor
    dec hl                                              ;ld hl, initColor
    dec hl                                              ;ld hl, orientation
    call AdjustSelectedNodeCC

    jp SwapCompleted


SwapThree:
;Point to the First selected strip orientation
    ld hl, selectedStripOne                             ;Take the first strip
    ld a, (hl)
    call SaveStripColorSW3
;Point to the Second selected strip orientation
    ld hl, selectedStripTwo                             ;Take the first strip
    ld a, (hl)
    call SaveStripColorSW3
;Point to the Third selected strip orientation
    ld hl, selectedStripThree                           ;Take the first strip
    ld a, (hl)
    call SaveStripColorSW3

;Colors have been saved, now let's swap them
    ld a, (leftColorSwapThree)
    ld b, a                                             ;ld b, (leftColorSwapThree)
    ld a, (rightColorSwapThree)
    ld c, a                                             ;ld c, (rightColorSwapThree)
    ld a, (horiColorSwapThree)
    ld hl, horiColorSwapThree
    ld (hl), c
    inc hl                                              ;ld hl, rightColorSwapThree
    inc hl                                              ;word
    ld (hl), b
    inc hl                                              ;ld hl, leftColorSwapThree
    inc hl                                              ;word
    ld (hl), a

;Colors have been swapped, now to assign them to the correct strips
;Hori
    ld hl, horiColorSwapThree
    inc hl                                              ;ld hl, horiStrip Address
    ld a, (hl)
    call PointToCurrentStrip                            ;ld hl, selectedStrip.stripNum
    ld bc, $0007
    add hl, bc                                          ;ld hl, selectedStrip.color
    ld a, (horiColorSwapThree)                          ;A = selected strip color
    ld (hl), a 
    dec hl                                              ;ld hl, selectedStrip.finalColor
    dec hl                                              ;ld hl, selectedStrip.initColor
    dec hl                                              ;ld hl, selectedStrip.orientation
    call AdjustSelectedNodeCC
;Left
    ld hl, leftColorSwapThree
    inc hl                                              ;ld hl, leftStrip Address
    ld a, (hl)
    call PointToCurrentStrip                            ;ld hl, selectedStrip.stripNum
    ld bc, $0007
    add hl, bc                                          ;ld hl, selectedStrip.color
    ld a, (leftColorSwapThree)                          ;A = selected strip color
    ld (hl), a 
    dec hl                                              ;ld hl, selectedStrip.finalColor
    dec hl                                              ;ld hl, selectedStrip.initColor
    dec hl                                              ;ld hl, selectedStrip.orientation
    call AdjustSelectedNodeCC
;Right
    ld hl, rightColorSwapThree
    inc hl                                              ;ld hl, rightStrip Address
    ld a, (hl)
    call PointToCurrentStrip                            ;ld hl, selectedStrip.stripNum
    ld bc, $0007
    add hl, bc                                          ;ld hl, selectedStrip.color
    ld a, (rightColorSwapThree)                         ;A = selected strip color
    ld (hl), a 
    dec hl                                              ;ld hl, selectedStrip.finalColor
    dec hl                                              ;ld hl, selectedStrip.initColor
    dec hl                                              ;ld hl, selectedStrip.orientation
    call AdjustSelectedNodeCC

    jp SwapCompleted


;Saves selected strip color and stripNum to the proper orientation variable
;Parameters: HL = selectedStrip.StripNum, A = (selectedStrip.StripNum)
SaveStripColorSW3:
    call PointToCurrentStrip                            ;ld hl, selectedStrip.stripNum
    ld bc, $0004
    add hl, bc                                          ;ld hl, selectedStrip.orientation
    ld a, (hl)                                          ;ld a, (selectedStrip.orientation)
    inc hl                                              ;ld hl, selectedStrip.initColor
    inc hl                                              ;ld hl, selectedStrip.finalColor
    inc hl                                              ;ld hl, selectedStrip.color
    ld c, HORI
    cp c
    jp z, +                                             
    ld c, RIGHT
    cp c
    jp z, ++
    jp +++
;SelectedStrip is the Hori Strip, HL = selectedStrip.color
+:
    ld de, horiColorSwapThree
    ld a, (hl)                                          ;ld a, (selectedStrip.color) 
    ld (de), a                                          ;ld horiColorSwapThree, selectedStrip.color
    inc de                                              ;ld de, horiColorSwapThree.Num
    ld bc, -7
    add hl, bc                                          ;ld hl, selectedStrip.stripNum
    ld a, (hl)
    ld (de), a

    ret

;SelectedStripTwo is the Right Strip, HL = selectedStripTwo.color
++:
    ld de, rightColorSwapThree
    ld a, (hl)                                          ;ld a, (selectedStripTwo.color) 
    ld (de), a                                          ;ld rightColorSwapThree, selectedStripTwo.color
    inc de                                              ;ld de, horiColorSwapThree.Num
    ld bc, -7
    add hl, bc                                          ;ld hl, selectedStrip.stripNum
    ld a, (hl)
    ld (de), a

    ret

;SelectedStripTwo is the Left Strip, HL = selectedStripTwo.color
+++:
    ld de, leftColorSwapThree
    ld a, (hl)                                          ;ld a, (selectedStripTwo.color) 
    ld (de), a                                          ;ld leftColorSwapThree, selectedStripTwo.color
    inc de                                              ;ld de, horiColorSwapThree.Num
    ld bc, -7
    add hl, bc                                          ;ld hl, selectedStrip.stripNum
    ld a, (hl)                                          
    ld (de), a

    ret



;Parameters: HL = selectedStrip.orientation, A = selectedStrip.color
AdjustSelectedNodeCC:
    ;ld a, selectedStripColor
    ;ld hl, selectedStrip.Orientation
    add a, (hl)
    ld bc, $0008
    add hl, bc                                          ;ld hl, selectedStrip.cc
    ld (hl), a                                          ;Plus colorOffset

    ret
