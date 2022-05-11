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
; Check Menu Inputs
;==================================================
CheckMenuDown:
    ld a, (joypadOne)
    bit 1, a                                ;If bit is zero, Z flag set
    jp nz, MenuGoDown


CheckMenuUp:
    bit 0, a                                ;If bit is zero, Z flag set
    jp nz, MenuGoUp


CheckMenuButtons:
;SW 1
    bit 4, a                                ;If bit is zero, Z flag set
    jp nz, PressMenuButton
;SW 2    
    bit 5, a                                ;If bit is zero, Z flag set
    jp nz, CheckMenuStatus
;All Joypad 1 inputs have been checked
    ret


;==================================================
; Menu Navigation Proper
;==================================================
MenuGoDown:
    ld hl, player.moveBuffer
    ld (hl), $10
;If we aren't at position 2, move down
    ld hl, menu.position
    ld a, (hl)
    ld c, 2                                 ;Reset Puzzle Button
    cp c
    jp z, +                                 ;If we are at the bottom, don't wrap around
    inc a
    ld (hl), a                              ;Otherwise, move down one
;Update menu Y coordinates
    ld hl, menu.y1
    ld a, (hl)
    add a, 48
    ld (hl), a
    ld hl, menu.y2
    ld a, (hl)
    add a, 48
    ld (hl), a
    ld hl, menu.y3
    ld a, (hl)
    add a, 48
    ld (hl), a
    ld hl, menu.y4
    ld a, (hl)
    add a, 48
    ld (hl), a

+:
    ret


MenuGoUp:
;Set up out Movement buffer so we don't get double inputs 
    ld hl, player.moveBuffer
    ld (hl), $10
;If we aren't at position 2, move down
    ld hl, menu.position
    ld a, (hl)
    ld c, 0                                 ;Reset Puzzle Button
    cp c
    jp z, +                                 ;If we are at the top, don't wrap around
    dec a
    ld (hl), a                              ;Otherwise, move up one
;Update menu Y coordinates
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

+:
    ret

