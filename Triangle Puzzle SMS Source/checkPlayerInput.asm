;==================================================
; Input $DC
;==================================================
/*
    BIT 
    0   |   P1-UP
    1   |   P1-DOWN
    2   |   P1-LEFT
    3   |   P1-RIGHT
    4   |   P1-SW1
    5   |   P1-SW2

    6   |   P2-UP
    7   |   P2-DOWN
*/

CheckPlayerInput:
;==================================================
; Check Controls
;==================================================
;Read INPUT from joypad 1
    in a, $DC                       ;Gives us 1's for no input
    cpl                             ;So let's invert that
;We don't care about Joypad 2 right now
    res 6, a
    res 7, a
;Save Joypad 1's input
    ld hl, joypadOne
    ld (hl), a
;If there's no input from Joypad 1, reset Movement Buffer and leave
    ld c, 0
    cp c
    jr z, ++
;==================================================
;Check Player Movement Buffer
;==================================================
    ld hl, player.moveBuffer
    ld a, (hl)
    ld c, 0
    cp c
    jr z, +
;If our buffer isn't zero, then don't move, and decrement buffer 
    ld a, (hl)
    dec a
    ld (hl), a
    ;jp EndCheckPlayerInput
    ret
+:
;Check if we are on Tringle side or Menu side
    ld a, (menu.status)
    ld c, $FF
    cp c
    jp z, CheckMenuDown
    ld a, (joypadOne)
    jp CheckDown

++:
    ld hl, player.moveBuffer
    ld (hl), 0
    jp EndCheckPlayerInput

;==================================================
; Determine what was pressed
;==================================================
CheckDown:
    bit 1, a                        ;If bit is zero, Z flag set
    jp nz, CheckDR
    jp CheckUp

CheckDR:
    bit 3, a                        ;If bit is zero, Z flag set
    jp nz, GoDownRight
    jp GoDownLeft

CheckUp:
    bit 0, a                        ;If bit is zero, Z flag set
    jp nz, CheckUL
    jp CheckLeft

CheckUL:
    bit 2, a                        ;If bit is zero, Z flag set
    jp nz, GoUpLeft
    jp GoUpRight

CheckLeft:
    bit 2, a                        ;If bit is zero, Z flag set
    jp nz, GoLeft
    ;jp CheckRight

CheckRight:
    bit 3, a                        ;If bit is zero, Z flag set
    jp nz, GoRight
    jp EndCheckPlayerInput

;==================================================
; Move based on input
;==================================================
GoDownLeft:
;Down Left = nodeNum + rowNum + 1
    ld hl, player.currentNode
    ld a, (hl)                      ;A is the currentNode
    call PointToCurrentNode         ;HL points to currentNode.nodeNum
    ld d, h
    ld e, l
    inc de                          ;ld de, currentNode.nodeRow
;Row check before jumping for literal Edge case
    ld a, (de)
    ld c, 3                         ;Check if we are on row 3
    cp c
    jp z, GoToNodeOne               ;If we are on row three, go to Node 1
;End Row Check
    ld a, (hl)
    ld b, a                         ;B = (currentNode.nodeNum) +
    ld a, (de)                      ;A = (currentNode.nodeRow) 
    add a, b
    inc a                           ;[+1] A = (downLeftNode.nodeNum)
    jp UpdatePlayerPosition

GoDownRight:
;Down Right = nodeNum + rowNum + 2
    ld hl, player.currentNode
    ld a, (hl)                      ;A is the currentNode
    call PointToCurrentNode         ;HL points to currentNode.nodeNum
    ld d, h
    ld e, l
    inc de                          ;ld de, currentNode.nodeRow
;Row check before jumping for literal Edge case
    ld a, (de)
    ld c, 3                         ;Check if we are on row 3
    cp c
    jp z, GoToNodeOne               ;If we are on row three, go to Node 1
;End Row Check
    ld a, (hl)
    ld b, a                         ;B = (currentNode.nodeNum) +
    ld a, (de)                      ;A = (currentNode.nodeRow) 
    add a, b
    inc a                           ;[+1] A = (downLeftNode.nodeNum)
    inc a                           ;[+1] A = (DownRightNode.nodeNum) 
    jp UpdatePlayerPosition

GoUpRight:
;Up Right = nodeNum - rowNum
    ld hl, player.currentNode
;Node check before jumping for literal Edge case
    ld a, (hl)                      ;A is the currentNode    
    ld c, 10                         ;Check if we are on node 10
    cp c
    jp z, GoToNodeSix               ;If we are on node 10, go to Node 6
    ld c, 6                         ;Check if we are on node 4
    cp c
    jp z, GoToNodeThree             ;If we are on node 6, go to Node 3
    ld c, 3                         ;Check if we are on node 3
    cp c
    jp z, GoToNodeOne               ;If we are on node 3, go to Node 1
;End Node Check
    call PointToCurrentNode         ;HL points to currentNode.nodeNum
    ld d, h
    ld e, l
    inc de                          ;ld de, currentNode.nodeRow
;Row check before jumping for literal Edge case
    ld a, (de)
    ld c, 0                         ;Check if we are on row 0
    cp c
    jp z, GoToNodeNine              ;If we are on row three, go to Node 1
;End Row Check
    ld a, (de)
    ld b, a                         ;B = (currentNode.nodeRow) +
    ld a, (hl)                      ;A = (currentNode.nodeNum) 
    sub b                           ;A = (upRightNode.nodeNum) 
    jp UpdatePlayerPosition
    

GoUpLeft:
;Up Left = nodeNum - rowNum - 1
    ld hl, player.currentNode
;Node check before jumping for literal Edge case
    ld a, (hl)                      ;A is the currentNode    
    ld c, 7                         ;Check if we are on node 7
    cp c
    jp z, GoToNodeFour              ;If we are on node 7, go to Node 4
    ld c, 4                         ;Check if we are on node 4
    cp c
    jp z, GoToNodeTwo               ;If we are on node 4, go to Node 2
    ld c, 2                         ;Check if we are on node 2
    cp c
    jp z, GoToNodeOne               ;If we are on node 2, go to Node 1
;End Node Check
    call PointToCurrentNode         ;HL points to currentNode.nodeNum
    ld d, h
    ld e, l
    inc de                          ;ld de, currentNode.nodeRow
;Row check before jumping for literal Edge case
    ld a, (de)
    ld c, 0                         ;Check if we are on row 0
    cp c
    jp z, GoToNodeEight             ;If we are on row three, go to Node 1
;End Row Check
    ld a, (de)
    ld b, a                         ;B = (currentNode.nodeRow) +
    ld a, (hl)                      ;A = (currentNode.nodeNum) 
    sub b                           ;A = (upRightNode.nodeNum) 
    dec a                           ;[-1] A = (upLeftNode.nodeNum)
    jp UpdatePlayerPosition

GoLeft:
;Left = nodeNum - 1
    ld hl, player.currentNode
;Node check before jumping for literal Edge case
    ld a, (hl)                      ;A is the currentNode
    ld c, 1                         ;Check if we are on node 1
    cp c
    jp z, GoToNodeTen               ;If we are on node 10, go to Node 10
;End Node Check
    ;A is the currentNode
    dec a                           ;[-1] A = (rightNode.nodeNum)
    jp UpdatePlayerPosition

GoRight:
;Right = nodeNum + 1
    ld hl, player.currentNode
;Node check before jumping for literal Edge case
    ld a, (hl)                      ;A is the currentNode    
    ld c, 10                        ;Check if we are on node 10
    cp c
    jp z, GoToNodeOne               ;If we are on node 10, go to Node 1
;End Node Check
    ;A is the currentNode
    inc a                           ;[+1] A = (rightNode.nodeNum)
    jp UpdatePlayerPosition


;==================================================
; Literal Edge Cases
;==================================================
GoToNodeOne:
    ld a, 1
    jp UpdatePlayerPosition

GoToNodeTwo:
    ld a, 2
    jp UpdatePlayerPosition

GoToNodeThree:
    ld a, 3
    jp UpdatePlayerPosition

GoToNodeFour:
    ld a, 4
    jp UpdatePlayerPosition

GoToNodeSix:
    ld a, 6
    jp UpdatePlayerPosition

GoToNodeEight:
    ld a, 8
    jp UpdatePlayerPosition

GoToNodeNine:
    ld a, 9
    jp UpdatePlayerPosition

GoToNodeTen:
    ld a, 10
    jp UpdatePlayerPosition

UpdatePlayerPosition:
;Update Player Current Node
    call PointToCurrentNode         ;HL points to newNode.nodeNum
    ld de, player.currentNode
    ld a, (hl)
    ld (de), a                      ;player.currentNode = newNode.nodeNum
;Update Player Y Coordinate
    inc hl                          ;ld hl, nodeRow
    inc hl                          ;ld hl, selected
    inc hl                          ;ld hl, nodeY
    ld de, player.y
    ld a, (hl)
    ld (de), a                      ;player.y = newNode.y
;Update Player X Coordinate
    inc hl                          ;ld hl, nodeX
    inc de                          ;ld de, player.x
    ld a, (hl)
    ld (de), a                      ;player.x = newNode.x
;Set Player Movement Buffer
    ld hl, player.moveBuffer
    ld (hl), $10

EndCheckPlayerInput:
;Check SW 1 and 2 input
    call CheckSWInput
    ret

;==================================================
; Which player sprite do we draw?
;==================================================
CheckMenuOrTri:
    ld a, (menu.status)
    ld c, $FF
    cp c
    jr z, +
    ld de, player.sprNum

    ret
+:
;Gotta draw the first 3, the last is handled by the default
    ld de, menu.sprNum1
    call MultiUpdateSATBuff
    ld de, menu.sprNum2
    call MultiUpdateSATBuff
    ld de, menu.sprNum3
    call MultiUpdateSATBuff
    ld de, menu.sprNum4

    ret

