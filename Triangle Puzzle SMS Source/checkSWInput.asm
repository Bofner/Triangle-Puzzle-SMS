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
;==================================================
; Initial Checks
;==================================================
CheckSWInput:
;SW 1
    ld a, (joypadOne)
    bit 4, a                                ;If bit is zero, Z flag set
    jp nz, CheckNodeStatus
;SW 2
    bit 5, a
    jp nz, CheckMenuStatus
;All Joypad 1 inputs have been checked
    ret


CheckNodeStatus:
;Set up out Movement buffer so we don't get double inputs 
    ld hl, player.moveBuffer
    ld (hl), $10
;Determine which node we are currently on
    ld a, (player.currentNode)
    call PointToCurrentNode                 ;HL points to currentNode.nodeNum
    inc hl                                  ;ld hl, currentNode.nodeRow
    inc hl                                  ;ld hl, currentNode.selected
;Check Selected status
    ld a, (hl)
    ld c, $FF                               ;If node is selected already...
    cp c
    jp z, UnselectNode                      ;... then unselect it
    jp SelectNode                           ;else select it


CheckMenuStatus:
;Set up out Movement buffer so we don't get double inputs 
    ld hl, player.moveBuffer
    ld (hl), $10
    ld a, (menu.status)
    ld c, $FF
    cp c
    jp z, TriangleMode
    jp MenuMode


;==================================================
; Mode Switch SW2
;==================================================
TriangleMode:
;Switch to Triangle mode
    ld hl, menu.status
    ld a, (hl)
    ld a, $00
    ld (hl), a
    call ResetMenu

;All Joypad 1 inputs have been checked
    ret

MenuMode:
;Switch to Menu mode
    ld hl, menu.status
    ld a, (hl)
    ld a, $FF
    ld (hl), a

;All Joypad 1 inputs have been checked
    ret