
InitStatusBar:
    xor a
    ld hl, statusBar.score
    ld (hl), 60                     ;Score starts as 60
    inc hl                          ;ld hl, moves
    ld (hl), 0                      ;Moves start at -1 so the first draw incs to 0
    inc hl                          ;ld hl, triPoints
    ld (hl), a
    inc hl                          ;ld hl, totalScore
    ld (hl), a

    
;MUSB Data 1    100's Score
    inc hl                          ;ld hl, sprNum1
    inc hl                          ;ld hl, hw1
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y1
    ld (hl), 4
    inc hl                          ;ld hl, x1
    ld (hl), 54
    inc hl                          ;ld hl, cc1
    ld (hl), zeroSpr - 2
    inc hl                          ;ld hl, sprSize1

;MUSB Data 2    10's Score
    inc hl                          ;ld hl, sprNum2
    inc hl                          ;ld hl, hw2
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y2
    ld (hl), 4
    inc hl                          ;ld hl, x2
    ld (hl), 62
    inc hl                          ;ld hl, cc2
    ld (hl), zeroSpr + 12
    inc hl                          ;ld hl, sprSize2


;MUSB Data 3    1's Score
    inc hl                          ;ld hl, sprNum3
    inc hl                          ;ld hl, hw3
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y3
    ld (hl), 4
    inc hl                          ;ld hl, x3
    ld (hl), 70
    inc hl                          ;ld hl, cc3
    ld (hl), zeroSpr
    inc hl                          ;ld hl, sprSize3


;MUSB Data 4 Ones Digit
    inc hl                          ;ld hl, sprNum4
    inc hl                          ;ld hl, hw4
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y4
    ld (hl), 4
    inc hl                          ;ld hl, x4
    ld (hl), 198
    inc hl                          ;ld hl, cc4
    ld (hl), zeroSpr
    inc hl                          ;ld hl, sprSize5


;MUSB Data 5 Tens digit
    inc hl                          ;ld hl, sprNum5
    inc hl                          ;ld hl, hw5
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y5
    ld (hl), 4
    inc hl                          ;ld hl, x5
    ld (hl), 190
    inc hl                          ;ld hl, cc5
    ld (hl), zeroSpr
    inc hl                          ;ld hl, sprSize5

;========================================
; Bottom
;========================================
;MUSB Data 6    100's Score
    inc hl                          ;ld hl, sprNum1
    inc hl                          ;ld hl, hw1
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y1
    ld (hl), 12
    inc hl                          ;ld hl, x1
    ld (hl), 54
    inc hl                          ;ld hl, cc1
    ld (hl), zeroSpr - 1
    inc hl                          ;ld hl, sprSize1

;MUSB Data 7    10's Score
    inc hl                          ;ld hl, sprNum2
    inc hl                          ;ld hl, hw2
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y2
    ld (hl), 12
    inc hl                          ;ld hl, x2
    ld (hl), 62
    inc hl                          ;ld hl, cc2
    ld (hl), zeroSpr + 13
    inc hl                          ;ld hl, sprSize2


;MUSB Data 8    1's Score
    inc hl                          ;ld hl, sprNum3
    inc hl                          ;ld hl, hw3
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y3
    ld (hl), 12
    inc hl                          ;ld hl, x3
    ld (hl), 70
    inc hl                          ;ld hl, cc3
    ld (hl), zeroSpr + 1
    inc hl                          ;ld hl, sprSize3


;MUSB Data 9 Ones Digit
    inc hl                          ;ld hl, sprNum4
    inc hl                          ;ld hl, hw4
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y4
    ld (hl), 12
    inc hl                          ;ld hl, x4
    ld (hl), 198
    inc hl                          ;ld hl, cc4
    ld (hl), zeroSpr + 1
    inc hl                          ;ld hl, sprSize5


;MUSB Data A Tens digit
    inc hl                          ;ld hl, sprNum5
    inc hl                          ;ld hl, hw5
    ld (hl), $11                    ;First corner is 1x1
    inc hl                          ;ld hl, y5
    ld (hl), 12
    inc hl                          ;ld hl, x5
    ld (hl), 190
    inc hl                          ;ld hl, cc5
    ld (hl), zeroSpr + 1
    inc hl                          ;ld hl, sprSize5


    ret