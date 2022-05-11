TitleScreen:
;==============================================================
; Scene beginning
;==============================================================
    ld hl, sceneComplete
    ld (hl), $00

;==============================================================
; Clear VRAM
;==============================================================
    
    ;First, let's set the VRAM write address to $0000
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ;Next, let's clear the VRAM with a bunch of zeros
    ld bc, $4000        ;Counter for our zeros in VRAM
-:  xor a
    out (VDPData), a    ;Output data in A to VRAM address (which auto increments)
    dec bc              ;Adjust the counter
    ld a, b             
    or c                ;Check if we are at zero
    jr nz,-             ;If not, loop back up

;==============================================================
; Initialize other variables
;==============================================================
    ld hl, scrollX          ;Set horizontal scroll to zero
    xor a                   ;
    ld (hl), a              ;

    ld hl, scrollY          ;Set vertical scroll to zero
    ld (hl), a              ;

    ld hl, frameCount       ;Set frame count to 0
    ld (hl), a              ;   

 ;Turn on screen (Maxim's explanation is too good not to use)
    ld a, %01100000
;           ||||||`- Zoomed sprites -> 16x16 pixels
;           |||||`-- Not doubled sprites -> 1 tile per sprite, 8x8
;           ||||`--- Mega Drive mode 5 enable
;           |||`---- 30 row/240 line mode
;           ||`----- 28 row/224 line mode
;           |`------ VBlank interrupts
;            `------- Enable display    
    ld c, $81
    call UpdateVDPRegister

    ;This could be used to make sure we only have the sprites that we need
    ;.redefine endSprite $c002
  
    ei
    
;==============================================================
; Game loop 
;==============================================================
TitleLoop:       ;This is the loop
    halt

;Start game, this won't always be here, I just don't want to make a title screen right now
    ld hl, sceneComplete
    ld a, $01
    ld (hl), a
    ret

    ld a, (sceneComplete)
    ld c, 0
    cp c
    jp z, +
    call BlankScreen
    ret

+:

    jp TitleLoop     ;Keep us on the title screen

;========================================================
; Assets
;========================================================

    ;--------------------------------
    ; Background Palette
    ;--------------------------------

    ;.include "assets\\palettes\\backgrounds\\prologueTitle_bg_palette.inc"

    ;--------------------------------
    ; Background Tiles
    ;--------------------------------

    ;Testing Ground for animations/collision etc
    ;.include "assets\\tiles\\prologueTitle_tiles.inc"
TitleTiles:
    ;.incbin "assets\\tiles\\backgrounds\\prologueTitle_tiles.pscompr"

    ;--------------------------------
    ; Sprite Palette
    ;--------------------------------
    
    ;Same as in Village Fight, so it's already included
    ;.include "assets\\palettes\\sprites\\villageFight_spr_palette.inc"

    ;--------------------------------
    ; Sprite Tiles
    ;--------------------------------
    ;For now I'm using inc files, I can edit them directly
    ;.include "assets\\tiles\\sprites\\cursor_tiles.inc" 


;========================================================
; Tile Maps
;========================================================
    ;.include "assets\\maps\\prologueTitle_map.inc"
TitleMap:
    ;.incbin "assets\\maps\\prologueTitle_map.pscompr"