
InitStatusBar:
    xor a
    ld hl, statusBar.score
    ld (hl), 60                     ;Score starts as 60
    inc hl                          ;ld hl, moves
    ld (hl), a                      ;Moves start at 0
    inc hl                          ;ld hl, triPoints
    ld (hl), a

    
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
    inc hl                          ;ld hl, sprSize5
;MUSB Data 5
    inc hl                          ;ld hl, sprNum5
    inc hl                          ;ld hl, hw5
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y5
    ld (hl), 65
    inc hl                          ;ld hl, x5
    ld (hl), 234
    inc hl                          ;ld hl, cc5
    ld (hl), menuBRSpr
    inc hl                          ;ld hl, sprSize5

    ret