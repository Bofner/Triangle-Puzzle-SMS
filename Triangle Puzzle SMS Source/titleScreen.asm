TitleScreen:
;==============================================================
; Scene beginning
;==============================================================
    ld hl, sceneComplete
    ld (hl), $00

    inc hl                                  ;ld hl, sceneID
    ld (hl), $01

;==============================================================
; Memory (Structures, Variables & Constants) 
;==============================================================

.enum postPal export
;Scroll values for each parallax layer
    scrollX1        db
    scrollX2        db
    scrollX3        db
    scrollX4        db
    palSwapBuff     db          ;Wait a moment before swapping palette again
    classicOrDesert db          ;Which palette are we using? $00 = Classic, $FF = Desert
.ende

;==============================================================
; Clear Data
;==============================================================
    
    call ClearVRAM

    call ClearSATBuff


;==============================================================
; Load Title Palettes
;==============================================================
;Write current BG palette to currentPalette struct
    ld hl, currentBGPal.color0
    ld de, FadedPalette
    ld b, $10
    call PalBufferWrite

;Write current SPR palette to currentPalette struct
    ld hl, currentSPRPal.color0
    ld de, FadedPalette
    ld b, $10
    call PalBufferWrite

;Write target BG palette to targetPalette struct
    ld hl, targetBGPal.color0
    ld de, TitleBGPalette
    ld b, $10
    call PalBufferWrite

;Write target SPR palette to targetPalette struct
    ld hl, targetSPRPal.color0
    ld de, TrianglePuzzle_sprPal
    ld b, $10
    call PalBufferWrite

;Actually update the palettes in VRAM
    call LoadBackgroundPalette
    call LoadSpritePalette


;==============================================================
; Load Title Tiles
;==============================================================
;Load SteelFginer Studios Screen
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ld hl, TitleTiles
    ld bc, TitleTilesEnd-TitleTiles
    call CopyToVDP


;==============================================================
; Load Title Map
;==============================================================

    ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, TitleStudiosMap
    ld bc, TitleStudiosMapEnd-TitleStudiosMap
    call CopyToVDP

;==============================================================
; Initialize Variables
;==============================================================
;Boilers
    ld hl, scrollX          ;Set horizontal scroll to zero
    xor a                   ;
    ld (hl), a              ;

    ld hl, scrollY          ;Set vertical scroll to zero
    ld (hl), a              ;

    ld hl, frameCount       ;Set frame count to 0
    ld (hl), a              ;   

;Scene Specific

    ld hl, scrollX1         ;Set second scroll to zero
    ld (hl), a
    inc hl                  ;ld hl, scrollX2
    ld (hl), a
    inc hl                  ;ld hl, scrollX3
    ld (hl), a
    inc hl                  ;ld hl, scrollX4
    ld (hl), a

    ld hl, palSwapBuff
    ld (hl), a

    ld hl, classicOrDesert
    ld (hl), $00            ;$00 is classic

;==============================================================
; Turn on screen
;==============================================================

;Must manually call due to not wanting to update all strips every frame
    call EndSprites

;Update VRAM before display turns on
    call UpdateSAT

 ;Turn on screen (Maxim's explanation is too good not to use)
    ld a, %01100000
;           ||||||`- Zoomed sprites -> 16x16 pixels
;           |||||`-- Doubled sprites -> 2 tile per sprite, 8x16
;           ||||`--- Mega Drive mode 5 enable
;           |||`---- 30 row/240 line mode
;           ||`----- 28 row/224 line mode
;           |`------ VBlank interrupts
;            `------- Enable display    
    ld c, $81
    call UpdateVDPRegister
  
    ei
    
;==============================================================
; Game logic 
;==============================================================

;Fade screen in
    call FadeIn

    halt                    ;Reset INTNumber at VBlank

    ld hl, INTNumber        ;Set INT counter to 0
    ld (hl), $00

;==============================================================
; Set Registers for HBlank
;==============================================================
;HBlank every 15 scanlines
    ld a, $0F                                 
    ld c, $8A
    call UpdateVDPRegister

;Blank Left Column
    ld a, %00110100
    ld c, $80
    call UpdateVDPRegister


TitleLoop:
    halt

;Check status of interrupt
    call TitleHBlank
    ld a, (INTNumber)
    cp $00
    jp nz, TitleLoop

;------------------------------------------------------------

;Check for our button calls
    call CheckStartGame
;Update palSwapBuffer
    ld hl, palSwapBuff
    ld a, (hl)
    cp $00
    jr z, +
    dec (hl)
+:
;Timer so that we don't write to VRAM while drawing the border
    ld a, $EF
-:
    dec a
    cp $00
    jr nz, -
;Actually update the palettes in VRAM (Don't need to do this every frame, but w/e)
    call LoadBackgroundPalette
    call LoadSpritePalette

;------------------------------------------------------------

;Check if scene has finished
    ld a, (sceneComplete)
    cp $01
    jr z, ++

    jp TitleLoop

;------------------------------------------------------------

;Scene Complete, ゲム　スタト！
++:
;Turn HBlank off
    ld a, $FF                                 
    ld c, $8A
    call UpdateVDPRegister
    halt
    call FadeToBlack
    call BlankScreen
;Set up next screen for starting with 0 sprites
    ld hl, spriteCount
    ld (hl), $00
    ld hl, sprUpdCnt
    ld (hl), $00

    ret

;========================================================
; HBlank Logic
;========================================================

TitleHBlank:
;Check if we are below the title letters
    ld de, INTNumber
    ld a, (de)
    cp $05
    jp nc, ParallaxTriangles
;Stop Scrolling
    ld hl, scrollX
    ld a, (hl)                               
    ld c, $88                               ;Update X-Scroll-speed
    call UpdateVDPRegister

    ret

;We are beyond the title letters
ParallaxTriangles:
;Check if we are beyond the small triangles
    cp $0A
    jp nc, PressStartScroll
;Check which line we are on, and enable scrolling
    cp $06
    jr z, +
    cp $07
    jr z, ++
    cp $08
    jr z, +++
    cp $09
    jp z, PressStartScroll

;We are at the FIRST line of Parallax
    ld hl, scrollX1
    dec (hl)
    ld a, (hl)      
    jp ParallaxTrianglesEnd
;We are at the SECOND line of Parallax   
+:
    ld hl, scrollX2
    dec (hl)
    dec (hl)
    ld a, (hl)      
    jp ParallaxTrianglesEnd

;We are at the THIRD line of Parallax
++:
    ld hl, scrollX3
    dec (hl)
    dec (hl)
    dec (hl)
    ld a, (hl)      
    jp ParallaxTrianglesEnd

;We are at the FOURTH line of Parallax
+++:
    ld hl, scrollX4
    dec (hl)
    dec (hl)
    dec (hl)
    dec (hl)
    ld a, (hl)      
    jp ParallaxTrianglesEnd


ParallaxTrianglesEnd:                    
    ld c, $88                               ;Update X-Scroll-speed
    call UpdateVDPRegister

    ret


;We are beyond the triangles
PressStartScroll:
;Check if we are at the last HBlank
    cp $0D
    jp z, BottomScreenScroll
;Stop Scrolling
    ld hl, scrollX
    ld a, (hl)                               
    ld c, $88                               ;Update X-Scroll-speed
    call UpdateVDPRegister

    ret


;We have reached the bottom of the screen
BottomScreenScroll:
    ld a, $00
    ld (de), a                                  ;Reset INTNumber
;Stop Scrolling
    ld hl, scrollX
    ld a, (hl)                               
    ld c, $88                               ;Update X-Scroll-speed
    call UpdateVDPRegister

    ret


;========================================================
; Check Start
;========================================================
CheckStartGame:
;Read INPUT from joypad 1
    in a, $DC                       ;Gives us 1's for no input
    cpl                             ;So let's invert that
;Check Button 1
    bit 4, a                        ;If bit is zero, Z flag set
    jr nz, +
;Check Button 2
    bit 5, a                        ;If bit is zero, Z flag set
    jr nz, ++

    ret
    

;Button 1 was hit
+:
;Complete scene
    ld hl, sceneComplete
    ld (hl), $01

    ret


;Button 2 was hit
++:
;Update palSwapBuffer
    ld hl, palSwapBuff
    ld a, (hl)
    cp $00
    jp z, SwapPalette

    ret
    
;We are free to change the palette
SwapPalette:
;Update palSwapBuffer
    ld (hl), $10

;Are we currently in Classic?
    ld a, (classicOrDesert)
    cp $00
    jp nz, ClassicSwap

DesertSwap:
;Swap between palettes
;Write current BG palette to currentPalette struct
;NOTE, this palette is different than the target because I like the way
;the title screen looks better when switched around this way
    ld hl, currentBGPal.color6                      ;RED
    ld (hl), $2F                                    ;Light Yellow
    inc hl                                          ;ld hl, currentBGPal.color7, GREEN
    ld (hl), $07                                    ;Burnt Orange
    inc hl                                          ;ld hl, currentBGPal.color8, BLUE
    ld (hl), $38                                    ;Faded Purple Blue
;Same thing but for Sprite palette
    ld hl, currentSPRPal.color1                      ;RED
    ld (hl), $2F                                    ;Light Yellow
    inc hl                                          ;ld hl, currentSPRPal.color2, GREEN
    ld (hl), $07                                    ;Burnt Orange
    inc hl                                          ;ld hl, currentSPRPal.color3, BLUE
    ld (hl), $38                                    ;Faded Purple Blue

;Same thing but for BG target palette
    ld hl, targetBGPal.color6                      ;RED
    ld (hl), $07                                    ;Burnt Orange
    inc hl                                          ;ld hl, targetSPRPal.color2, GREEN
    ld (hl), $2F                                    ;Light Yellow
    inc hl                                          ;ld hl, targetSPRPal.color3, BLUE
    ld (hl), $38                                    ;Faded Purple Blue

;Same thing but for Sprite target palette
    ld hl, targetSPRPal.color1                      ;RED
    ld (hl), $07                                    ;Burnt Orange
    inc hl                                          ;ld hl, targetSPRPal.color2, GREEN
    ld (hl), $2F                                    ;Light Yellow
    inc hl                                          ;ld hl, targetSPRPal.color3, BLUE
    ld (hl), $38                                    ;Faded Purple Blue

    ld hl, classicOrDesert
    ld (hl), $FF

    ret

ClassicSwap:
;Swap between palettes
;Write current BG palette to currentPalette struct
    ld hl, currentBGPal.color6                      ;RED
    ld (hl), $03                                    ;RED
    inc hl                                          ;ld hl, currentBGPal.color7, GREEN
    ld (hl), $0C                                    ;GREEN
    inc hl                                          ;ld hl, currentBGPal.color8, BLUE
    ld (hl), $30                                    ;BLUE
;Same thing but for Sprite palette
    ld hl, currentSPRPal.color1                      ;RED
    ld (hl), $03                                    ;Light Yellow
    inc hl                                          ;ld hl, currentSPRPal.color2, GREEN
    ld (hl), $0C                                    ;Burnt Orange
    inc hl                                          ;ld hl, currentSPRPal.color3, BLUE
    ld (hl), $30                                    ;Faded Purple Blue

;Same thing but for Sprite target palette
    ld hl, targetSPRPal.color1                      ;RED
    ld (hl), $03                                    ;Burnt Orange
    inc hl                                          ;ld hl, targetSPRPal.color2, GREEN
    ld (hl), $0C                                    ;Light Yellow
    inc hl                                          ;ld hl, targetSPRPal.color3, BLUE
    ld (hl), $30                                    ;Faded Purple Blue

    ld hl, classicOrDesert
    ld (hl), $00

    ret


;========================================================
; Assets
;========================================================

    ;--------------------------------
    ; Background Palette
    ;--------------------------------

TitleBGPalette:
    .include "assets\\palettes\\backgrounds\\trianglePuzzle_bgPal.inc"
TitleBGPaletteEnd:

    ;--------------------------------
    ; Background Tiles
    ;--------------------------------

TitleTiles:
    .include "assets\\tiles\\backgrounds\\titleScreen_tiles.inc"
TitleTilesEnd:

;========================================================
; Tile Maps
;========================================================
TitleStudiosMap:
    .include "assets\\maps\\titleScreen_map.inc"
TitleStudiosMapEnd:

    ;--------------------------------
    ; Sprite Palette
    ;--------------------------------