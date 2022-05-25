
;========================================================
; JP Routines
;========================================================
;Checks if last interrupt was VBlank or HBlank 
CheckVBlank:
;Check if we are at VBlank, or HBlank
    ld a, (VDPStatus)
    bit 7, a                            ;Z set if bit is 0
    jp z, CheckHBlankNum                ;If bit 7 != 1, NOT VBlank and halt
;Else, we are at VBlank
    ld hl, INTNumber    
    ld (hl), $00             
    jp PostVBlank         


CheckHBlankNum:
;On the first HBlank, we will swap the sprites back to 8x8

    ld a, (INTNumber)
    cp $02
    call z, SetSmallSprites
;Set sprites to 8x16 so that when we draw the score and moves, we use tall numbers
    ld a, (INTNumber)
    cp $0E
    call z, SetTallSprites   

    
    jp TrianglePuzzleMainLoop           ;Return to halting for VBlank


;========================================================
; HBlank Effects
;========================================================
SetTallSprites:
    ld a, $62                           ;Update Register for Tall Sprites
    ld c, $81                           ;Update Register 1
    call UpdateVDPRegister

    ret

SetSmallSprites:
    ld a, $60                           ;Update Register for Small Sprites
    ld c, $81                           ;Update Register 1
    call UpdateVDPRegister

    ret