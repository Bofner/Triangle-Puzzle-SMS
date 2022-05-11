InitSelector:
    ld hl, player.currentNode
    ld (hl), 1                      ;Start at the top-most node
    ld a, (hl)                      ;Save current node
    inc hl                          ;ld hl, nodeOne
    ld (hl), $FF                    ;NULL
    inc hl                          ;ld hl, nodeTwo
    ld (hl), $FF                    ;NULL
    inc hl                          ;ld hl, nodeThree
    ld (hl), $FF                    ;NULL
    inc hl                          ;ld hl, moveBuffer
    ld (hl), $00
;MUSB Data
    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $22                    ;Selector is 2x2
    inc hl                          ;ld hl, y
    call SetSelectPosition          ;Set X and Y  
    inc hl                          ;ld hl, cc
    ld (hl), slctRngSpr

    ret

InitMenu:
    xor a
    ld hl, menu.status
    ld (hl), a                      ;Menu mode is OFF
    inc hl                          ;ld hl, position
    ld (hl), a                      ;Start at top
    inc hl                          ;ld hl, swapable
    ld (hl), a                      ;Not in a swapable state
    ;inc hl                          ;ld hl, moveBuffer
    ;ld (hl), a                      ;Free to move
;MUSB Data 1
    inc hl                          ;ld hl, sprNum1
    inc hl                          ;ld hl, hw1
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y1
    ld (hl), 37
    inc hl                          ;ld hl, x1
    ld (hl), 150
    inc hl                          ;ld hl, cc1
    ld (hl), menuTLSpr
    inc hl                          ;ld hl, sprSize1
;MUSB Data 2
    inc hl                          ;ld hl, sprNum2
    inc hl                          ;ld hl, hw2
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y2
    ld (hl), 37
    inc hl                          ;ld hl, x2
    ld (hl), 234
    inc hl                          ;ld hl, cc2
    ld (hl), menuTRSpr
    inc hl                          ;ld hl, sprSize2
;MUSB Data 3
    inc hl                          ;ld hl, sprNum3
    inc hl                          ;ld hl, hw3
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y3
    ld (hl), 65
    inc hl                          ;ld hl, x3
    ld (hl), 150
    inc hl                          ;ld hl, cc3
    ld (hl), menuBLSpr
    inc hl                          ;ld hl, sprSize3
;MUSB Data 4
    inc hl                          ;ld hl, sprNum4
    inc hl                          ;ld hl, hw4
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y4
    ld (hl), 65
    inc hl                          ;ld hl, x4
    ld (hl), 234
    inc hl                          ;ld hl, cc4
    ld (hl), menuBRSpr
    inc hl                          ;ld hl, sprSize4

    ret