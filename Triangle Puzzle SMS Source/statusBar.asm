;==============================================================
; Status Bar
;==============================================================
;NOTE This struct will be used with an interrupt, and will utilize 8x16 sprites!
/*
.struct statusBarStruct
    score       db
    moves       db
    triPoints   db              ;Points to add on to the score for complete triangles
*/

;==============================================================
; Moves Graphics
;==============================================================
UpdateMovesGraphic:
;Check if our number is divisible by 10
    ld a, (statusBar.moves)
    ld d, $0A
    ld h, a
    call Div8Bit                                ;statusBar.Moves/10, A = remainder
    
    ld hl, statusBar.cc4                        ;ld hl, statusBar.moves1cc
    ld de, statusBar.cc5                        ;ld hl, statusBar.moves10cc
    ld c, $00                                   ;If Remainder == 0, then it is divisible by 10
    cp c
    jp z, PlusTenMoves                          ;If we are at nine, we update 10's
    inc (hl)                                    ;Point to next number
    inc (hl)    
    ld hl, statusBar.cc9                        ;Update bottom half
    inc (hl)                                    ;Point to next number
    inc (hl)

    jp DrawMovesGraphic
 

;Parameters: DE = 10's cc
PlusTenMoves:
    ld (hl), zeroSpr                            ;1's becomes 0
    ld hl, statusBar.cc9
    ld (hl), zeroSpr + 1
    ld a, (de)
    inc a
    inc a
    ld (de), a                                  ;10's increases by 1
;Bottom half of tens
    ld de, statusBar.ccA
    ld a, (de)
    inc a
    inc a
    ld (de), a                                  ;10's increases by 1

    jp DrawMovesGraphic


DrawMovesGraphic:
    ld de, statusBar.sprNum4                    ;1's digit
    call MultiUpdateSATBuff 
    ld de, statusBar.sprNum5                    ;10's digit
    call MultiUpdateSATBuff 

    ld de, statusBar.sprNum9                    ;1's digit
    call MultiUpdateSATBuff 
    ld de, statusBar.sprNumA                    ;10's digit
    call MultiUpdateSATBuff 

    ret

;==============================================================
; Score Graphics
;==============================================================

UpdateScoreGraphic:
;Check if our number is divisible by 10
    ld a, (statusBar.score)
    ld hl, statusBar.triPoints
    add a, (hl)                                 ;A = Total score
    inc hl                                      ;ld hl, statusBar.totalScore
    ld (hl), a                                  ;Total Score updated
;Check if score is lower than zero
    ld c, $00
    cp c
    jp c, ScoreLessThanZero

;Calculate ten's place
    ld a, (statusBar.totalScore)
    ld h, a
    ld d, $0A
;totalScore/10 + zeroSpr = tens place cc
    call Div8Bit                                ;L = quotient A = remainder
    add a, a                                    ;double for 8x16
    add a, zeroSpr                              ;A = One's place cc 
    ld de, statusBar.cc3
    ld (de), a                                  ;Update One's place
    ld de, statusBar.cc8
    inc a                                       ;A + 1 for 8x16
    ld (de), a
    ld a, l                                     ;A = Ten's place
    ld c, $0A
    cp c
    jp nc, ScoreOver100
    add a, a                                    ;double for 8x16
    add a, zeroSpr
    ld hl, statusBar.cc2
    ld (hl), a
    ld hl, statusBar.cc7
    inc a
    ld (hl), a

    jp DrawScoreGraphic

ScoreOver100:
;Scores cannot exceed 119 (A single move that solves the puzzle, which is impossible already)
    ld a, (statusBar.totalScore)
    ld c, 110
    cp c
    jr nc, +                                    ;If score is over 110, write 11x
;Set score to 10x
    ld hl, statusBar.cc1
    ld (hl), zeroSpr + 2                        ;1
    ld hl, statusBar.cc6
    ld (hl), zeroSpr + 3                        ;1 bottom
    ld hl, statusBar.cc2
    ld (hl), zeroSpr                            ;0
    ld hl, statusBar.cc7
    ld (hl), zeroSpr + 1                        ;0 Bottom

    jp DrawScoreGraphic

+:
;Set score to 11x
    ld hl, statusBar.cc1
    ld (hl), zeroSpr + 2                        ;1
    ld hl, statusBar.cc6
    ld (hl), zeroSpr + 3                        ;1 bottom
    ld hl, statusBar.cc2
    ld (hl), zeroSpr + 2                        ;1
    ld hl, statusBar.cc7
    ld (hl), zeroSpr + 3                        ;1 Bottom

    jp DrawScoreGraphic


ScoreLessThanZero:
    ld hl, statusBar.cc1
    ld (hl), zeroSpr - 1
    ld hl, statusBar.cc2
    ld (hl), zeroSpr
    ld hl, statusBar.cc3
    ld (hl), zeroSpr

    jp DrawScoreGraphic

DrawScoreGraphic:
    ld de, statusBar.sprNum1                    ;100's digit
    call MultiUpdateSATBuff 
    ld de, statusBar.sprNum6                    ;100's digit
    call MultiUpdateSATBuff 

    ld de, statusBar.sprNum2                    ;10's digit
    call MultiUpdateSATBuff
    ld de, statusBar.sprNum7                    ;100's digit
    call MultiUpdateSATBuff 

    ld de, statusBar.sprNum3                    ;1's digit
    call MultiUpdateSATBuff
    ld de, statusBar.sprNum8                    ;100's digit
    call MultiUpdateSATBuff 

    ret