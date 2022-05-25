;==============================================================
; Strip structure
;==============================================================
/*
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
*/

;Parameters: A = currentStrip.stripNum
;Affects: A, HL, BC
;Returns: HL points to currentStripNum.stripNumNum
PointToCurrentStrip:
    ;First we have to point to the correct node
        ;ld a, currentStrip.stripNumNum
    push de
        ld bc, stripPointer              ;HL points to stripNum.1.pointer
        sub 1                           ;stripNum aren't zero indexed, so they have a +1 offset
        ld d, 0
        ld e, stripSize
        push bc
            call Mult8Bit                   ;Multiplies AxDE
        pop bc
        add hl, bc                      ;HL points to currentStrip.stripNumNum
    pop de

    ret


UpdateStripSelectedness:
;Update strips
    ld hl, strips.1.nodeOne
    ld de, strips.1.selected
    ;ld b, 18                                            ;18 strips to go through
    ;ld c, 0                                             ;
    ld bc, $1200                                         ;
-:                                                      ;LOOP start
;Start by checking if currentStrip's first node is selected
    push bc
        push de
        push hl
            ld a, (hl)                                          ;ld a, (strips.current.nodeOne)
            call CheckNodeSelectedStatus                        ;A = (node.selected)
            ld c, $00
            cp c                                                ;If node is not selected, check next strip
            jp z, +
        pop hl                                              ;If node IS selected, check current strip's second node
        inc hl                                              ;ld hl, nodeTwo
        push hl
            ld a, (hl)                                          ;ld a, (strips.current.nodeTwo)
            call CheckNodeSelectedStatus                        ;A = (node.selected)
            ld c, $00
            cp c                                                ;If node is not selected, check next strip
            jp z, ++           

;If BOTH currentStrip's node are selected, HL = (strip.current.nodeTwo)
        pop hl
        pop de
        ld a, $FF
        ld (de), a                                          ;strips.current.selected = $FF
/*
;Gotta work the LAST STRIP edge case
        dec hl                                              ;ld hl, strips.current.nodeOne
        dec hl                                              ;ld hl, strips.current.stripNum
        ld a, (hl)
        ld c, 18                                            ;If we are at the last strip, skip this
        cp c
        jp z, Strip18Skip   
;End LAST STRIP check
;Adjust for LAST STRIP check
        inc hl                                              ;ld hl, strips.current.nodeOne
        inc hl                                              ;ld hl, strips.current.nodeTwo
*/
        ld bc, stripSize    
        ld b, $00                                           ;Only need 8-bits
        add hl, bc                                          ;HL points to strips.next.nodeTwo
        dec hl                                              ;ld hl, strips.next.nodeOne
        ld d, h
        ld e, l                                             ;DE points to strips.next.nodeOne
        inc de                                              ;ld de, strips.next.nodeTwo
        inc de                                              ;ld de, strips.next.selected
    pop bc
    inc c                                               ;This will become numSelectedStrips
;Assign to global selected strip
    ld a, 1
    cp c
    call z, UpdateSelectedStripOne
    ld a, 2
    cp c
    call z, UpdateSelectedStripTwo
    ld a, 3
    cp c
    call z, UpdateSelectedStripThree
    djnz -

    jp UpdateGlobalSelectedStrips


;If nodeOne was not selected 
+:     
        pop hl
        pop de

        xor a                                               ;A = 0
        ld bc, stripSize    
        ld b, a                                             ;Only need 8-bits
        ld (de), a                                          ;strips.current = $00
        add hl, bc                                          ;HL points to strips.next.nodeOne
        ld d, h
        ld e, l                                             ;DE points to strips.next.nodeOne
        inc de                                              ;ld de, strips.next.nodeTwo
        inc de                                              ;ld de, strips.next.selected
    pop bc
    djnz -                                               ;LOOP ending 1

    jp UpdateGlobalSelectedStrips


;If nodeTwo was not selected
++:
        pop hl
        pop de

        xor a                                               ;A = 0
        ld bc, stripSize    
        ld b, a                                             ;Only need 8-bits
        ld (de), a                                          ;strips.current = $00
        add hl, bc                                          ;HL points to strips.next.nodeTwo
        dec hl                                              ;ld hl, strips.next.nodeOne
        ld d, h
        ld e, l                                             ;DE points to strips.next.nodeOne
        inc de                                              ;ld de, strips.next.nodeTwo        
        inc de                                              ;ld de, strips.next.selected
    pop bc
    djnz -                                               ;LOOP ending 2

    jp UpdateGlobalSelectedStrips


UpdateGlobalSelectedStrips:
    ;BC should contain $00(numSelectedStrips)
    ld hl, numSelectedStrips
    ld (hl), c

    jp CheckStripSwapability


CheckStripSwapability:
;Check if we can swap the strips yet
    ld a, (numSelectedStrips)
    ld c, 2
    cp c
    jr nc, +
    call SetInactiveSwapColorsMap                          ;else

    ret
+:
    call SetActiveSwapColorsMap                        ;If numSelectedStrips >= 2

    ret


;==============================================================
; Selected Strip Subroutines
;==============================================================
;HL = strips.Next.nodeOne
UpdateSelectedStripOne:
    push hl
    push de
        dec hl                                      ;ld hl, strip.next.stripNum
        ld a, (hl)
        dec a                                       ;A = (strip.current.stripNum)
        ld de, selectedStripOne
        ld (de), a
    pop de
    pop hl

    ret


;HL = strips.Next.nodeOne
UpdateSelectedStripTwo:
    push hl
    push de
        dec hl                                      ;ld hl, strip.next.stripNum
        ld a, (hl)
        dec a                                       ;A = (strip.current.stripNum)
        ld de, selectedStripTwo
        ld (de), a
    pop de
    pop hl

    ret


;HL = strips.Next.nodeOne
UpdateSelectedStripThree:
    push hl
    push de
        dec hl                                      ;ld hl, strip.next.stripNum
        ld a, (hl)
        dec a                                       ;A = (strip.current.stripNum)
        ld de, selectedStripThree
        ld (de), a
    pop de
    pop hl

    ret

UpdateSelectedStripAll:
    push hl
        xor a
        ld hl, selectedStripOne
        ld (hl), a
        inc hl                                      ;ld hl, selectedStripTwo
        ld (hl), a
        inc hl                                      ;ld hl, selectedStripThree
        ld (hl), a
    pop hl

    ret

SwapCompleted:

    call DrawStrips

    call UnselectAllNodes

    call CheckWinCondition

    call TriangleMode

    ret


CheckWinCondition:
;Set up a counter
    ld b, $00
    ld hl, statusBar.triPoints
    ld (hl), b
;Check T1 (1,4,7)
    ld hl, strips.1.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.4.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.7.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +
    inc b
;Add T1 Complete Points
    ld hl, statusBar.triPoints
    ld a, (hl)
    add a, 10
    ld (hl), a

;Not a winning triangle for T1
+:
;Check T1 (2,9,13)
    ld hl, strips.2.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.9.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.13.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +
    inc b
;Add T2 Complete Points
    ld hl, statusBar.triPoints
    ld a, (hl)
    add a, 10
    ld (hl), a

;Not a winning triangle for T2
+:
;Check T3 (14,5,9)
    ld hl, strips.14.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.5.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.9.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +
    inc b
;Add T3 Complete Points
    ld hl, statusBar.triPoints
    ld a, (hl)
    add a, 10
    ld (hl), a

;Not a winning triangle for T3
+:
;Check T4 (3,10,15)
    ld hl, strips.3.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.10.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.15.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +
    inc b
;Add T4 Complete Points
    ld hl, statusBar.triPoints
    ld a, (hl)
    add a, 10
    ld (hl), a

;Not a winning triangle for T5
+:
;Check T3 (16,17,11)
    ld hl, strips.16.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.17.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.11.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +
    inc b
;Add T5 Complete Points
    ld hl, statusBar.triPoints
    ld a, (hl)
    add a, 10
    ld (hl), a

;Not a winning triangle for T5
+:
;Check T6 (18,12,6)
    ld hl, strips.18.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.12.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +

    ld hl, strips.6.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    call CompareFinalAndCurrent
    ld c, $00
    cp c
    jp z, +
    inc b
;Add T6 Complete Points
    ld hl, statusBar.triPoints
    ld a, (hl)
    add a, 10
    ld (hl), a


;Not a winning triangle for T6/Done
+:
;Update Moves Graphic
    push bc
        call UpdateMovesGraphic
        call UpdateScoreGraphic
    pop bc
    
;Check if we have our Win Condition
    ld hl, numWinningTriangles
    ld (hl), b
    ld a, (hl)
    ld c, 6
    cp c
    jp z, Winner


    ret

Winner:
;Change scene so we don't mess with the pause screen
    ld hl, sceneID                              ;ld hl, sceneID
    ld (hl), $03
;Wait for VBlank so we can Update sprites
    halt
    call UpdateSAT

    ld de, $0000                                ;Our offset for moving down a row
    ld b, $06                                   ;Number of rows to draw
    ld hl, YouWinMap                            ;Location of tile map data

-:                                              ;LOOP start
    push bc                                     ;Save Counter
        push hl                                 ;Save map address
            ld hl, (WinVRAM)
            add hl, de
            call SetVDPAddress                  ;Draw to correct spot in VRAM
;DE + $40 for the next row to be drawn
            ld hl, $0040                
            add hl, de
            ld d, h
            ld e, l
        pop hl                                  ;ld hl, InactiveSwapColorsMap
        ld bc, 26                               ;Number of tiles to draw x2
        call CopyToVDP
    pop bc
    djnz -                                      ;LOOP end

;Don't want to select on re-entry
    ld hl, player.moveBuffer
    ld (hl), $10
-:
    halt
    ld hl, player.moveBuffer
    ld a, (hl)
    cp $00
    jr z, +
    dec (hl)
    jr -

;Wait for player to reset the puzzle
+:
    halt
;Read INPUT from joypad 1
    in a, $DC                       ;Gives us 1's for no input
    cpl                             ;So let's invert that
;Check Button 1
    bit 4, a                        ;If bit is zero, Z flag set
    jr nz, ++
;Check Button 2
    bit 5, a                        ;If bit is zero, Z flag set
    jr nz, -
    jr -

++:

    call RestartPuzzle

    jp TrianglePuzzleMainLoop

;Very similar to reset, but for restarting the game after a win
RestartPuzzle:
;Go back to puzzle scene
    ld hl, sceneID                             ;ld hl, sceneID
    ld (hl), $02

;Reinitialize Nodes
    call UnselectAllNodes
;Reinitialize Strips
    call InitStrips
;Reinitialize Selector
    call InitSelector
;Reinitialize Menu
    call InitMenu
;Reinitialize StatusBar
    call InitStatusBar
;SelectedStripNums
    call UpdateSelectedStripAll
;Draw the Player Selector on screen
    call CheckMenuOrTri                     ;DE will be appropriate sprite
    ;ld de, player/menu.sprNum
    call MultiUpdateSATBuff  
;Redraw our strips
    call DrawStrips
;Update Moves Graphics
    call DrawMovesGraphic
;Update Score Graphics
    call DrawScoreGraphic

;Redraw Map screen
    ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, TrianglePuzzleMap
    ld bc, TrianglePuzzleMapEnd-TrianglePuzzleMap
    call CopyToVDP

;We cannot Swap
    call SetInactiveSwapColorsMap

;Don't want to select on re-entry
    ld hl, player.moveBuffer
    ld (hl), $10

    halt
    call UpdateSAT

    ret



;Parameters: DE = strips.current.finalColor, HL = strips.current.color
;Returns A = PASS ($FF) or FAIL ($00)
CompareFinalAndCurrent:
    ld a, (hl)                                  ;
    ld c, a                                     ;ld c, (strips.finalColor)
    ld a, (de)                                  ;ld a, (strips.color)
    cp c
    jp z, +
    ld a, $00                                   ;Not good triangle

    ret

+:
    ld a, $FF                                   ;Good triangle        

    ret

OldCheckWin:
    ld hl, strips.1.finalColor                                      
    ld d, h
    ld e, l                                     ;ld de, strips.1.finalColor
    inc de                                      ;ld de, strips.1.Color
    ld b, 18                                    ;18 Strips to go through
-:
    ld a, (hl)                                  ;
    ld c, a                                     ;ld c, (strips.finalColor)
    ld a, (de)                                  ;ld a, (strips.color)
    cp c
    jp nz, +
    push hl
        ld h, d
        ld l, e
        ld de, stripSize
        add hl, de                              ;ld hl, strips.next.color
        ld d, h
        ld e, l                                 ;ld de, strips.nextColor
    pop hl
    push de
        ld de, stripSize
        add hl, de                              ;ld hl, strips.next.finalColor
    pop de
    djnz -
    
;You win!
    call ClearVRAM

    ret

;At least one strip is not the correct color
+:

    ret