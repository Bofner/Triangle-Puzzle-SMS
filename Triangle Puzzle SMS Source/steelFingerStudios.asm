SteelFingerStudios:
;==============================================================
; Scene beginning
;==============================================================
    ld hl, sceneComplete
    ld (hl), $00

    inc hl                                  ;ld hl, sceneID
    ld (hl), $00

;==============================================================
; Memory (Structures, Variables & Constants) 
;==============================================================

.enum postBoiler export
    currentBGPal instanceof paletteStruct   ;Used for Fade
    currentSPRPal instanceof paletteStruct  ;Used for Fade
    targetBGPal instanceof paletteStruct    ;Used for Fade
    targetSPRPal instanceof paletteStruct   ;Used for Fade
    postPal                 db              ;Used for keeping our palette buffers 
    topShimmer instanceof shimmerStruct     ;Shimmer effect
    botShimmer instanceof shimmerStruct     ;Shimmer effect
.ende

;==============================================================
; Clear Data
;==============================================================
    
    call ClearVRAM

    call ClearSATBuff

;==============================================================
; Load SFS Palettes
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
    ld de, SteelFingerBGPalette
    ld b, $10
    call PalBufferWrite

;Write target SPR palette to targetPalette struct
    ld hl, targetSPRPal.color0
    ld de, SteelFingerSPRPalette
    ld b, $10
    call PalBufferWrite

;Actually update the palettes in VRAM
    call LoadBackgroundPalette
    call LoadSpritePalette
    

;==============================================================
; Load SFS Tiles
;==============================================================
;Load SteelFginer Studios Screen
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ld hl, SteelFingerTiles
    ld bc, SteelFingerTilesEnd-SteelFingerTiles
    call CopyToVDP

;Load SteelFginer Studios Sprites
    ld hl, $2000 | VRAMWrite
    call SetVDPAddress
    ld hl, SteelFingerShimmerTiles
    ld bc, SteelFingerShimmerTilesEnd-SteelFingerShimmerTiles
    call CopyToVDP

;==============================================================
; Load SFS Map
;==============================================================

    ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, SteelFingerStudiosMap
    ld bc, SteelFingerStudiosMapEnd-SteelFingerStudiosMap
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
;==============================================================
; Intialize our objects
;==============================================================
;Top Shimmer
    ld hl, topShimmer.sprNum
    inc hl                              ;ld hl, topShimmer.hw
    ld (hl), $11                        ;Sprite is 1x1 for 8x16
    inc hl                              ;ld hl, topShimmer.y
    ld (hl), 62
    inc hl                              ;ld hl, topShimmer.x
    ld (hl), 1
    inc hl                              ;ld hl, topShimmer.cc
    ld (hl), $00

;Bottom Shimmer
    ld hl, botShimmer.hw
    ld (hl), $11
    inc hl                              ;ld hl, botShimmer.y
    ld (hl), 86
    inc hl                              ;ld hl, botShimmer.x
    ld (hl), 9
    inc hl                              ;ld hl, botShimmer.cc
    ld (hl), $00



;==============================================================
; Set HBlank
;==============================================================
    ld a, $FF                               ;24 = $18, but it's OFF now, $0C = 12
    ld c, $8A
    call UpdateVDPRegister

;==============================================================
; Turn on screen
;==============================================================
;Draw the SFS Shimmer
    ld de, topShimmer.sprNum
    call MultiUpdateSATBuff             ;Our shimmers are 1x1, so they will work with the 8x8 MUSB
    ld de, botShimmer.sprNum
    call MultiUpdateSATBuff             ;Our shimmers are 1x1, so they will work with the 8x8 MUSB

;Must manually call due to not wanting to update all strips every frame
    call EndSprites

;Update VRAM before display turns on
    call UpdateSAT

 ;Turn on screen (Maxim's explanation is too good not to use)
    ld a, %01100010
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

SFSLoop:       ;This is the loop
    halt

    call UpdateSAT

    call UpdateFrameCount

;Draw the SFS Shimmer
    ld de, topShimmer.sprNum
    call MultiUpdateSATBuff             ;Our shimmers are 1x1, so they will work with the 8x8 MUSB
    ld de, botShimmer.sprNum
    call MultiUpdateSATBuff             ;Our shimmers are 1x1, so they will work with the 8x8 MUSB

;Move shimmer across the screen
    ld hl, topShimmer.x
    ld a, (hl)
    add a, $03
    ld (hl), a
    ld hl, botShimmer.x
    ld a, (hl)
    add a, $03
    ld (hl), a

;Check if shimmer has wrapped around the screen
    ld a, (topShimmer.x)
    cp $00
    jr nz, +
;Complete scene
    ld hl, sceneComplete
    ld (hl), $01


;Shimmer hasn't wrapped yet, so scene isn't over   
+:
;Check if scene has finished
    ld a, (sceneComplete)
    cp $00
    jp z, +
    ld b, $2A
-:
    halt
    djnz -

    call FadeToBlack
    call BlankScreen
;Set up next screen for starting with 0 sprites
    ld hl, spriteCount
    ld (hl), $00
    ld hl, sprUpdCnt
    ld (hl), $00

    ret


;Scene isn't finished, so loop
+:  
    
    jp SFSLoop     ;Keep us on the title screen


;========================================================
; Assets
;========================================================

    ;--------------------------------
    ; Background Palette
    ;--------------------------------

SteelFingerBGPalette:
    .include "assets\\palettes\\backgrounds\\steelFinger_bgPal.inc"
SteelFingerBGPaletteEnd:

    ;--------------------------------
    ; Background Tiles
    ;--------------------------------

SteelFingerTiles:
    .include "assets\\tiles\\backgrounds\\steelFingerStudios_tiles.inc"
SteelFingerTilesEnd:

;========================================================
; Tile Maps
;========================================================
SteelFingerStudiosMap:
    .include "assets\\maps\\steelFingerStudios_map.inc"
SteelFingerStudiosMapEnd:

    ;--------------------------------
    ; Sprite Palette
    ;--------------------------------
    
SteelFingerSPRPalette:
    .include "assets\\palettes\\sprites\\steelFinger_SprPal.inc"
SteelFingerSPRPaletteEnd:

    ;--------------------------------
    ; Sprite Tiles
    ;--------------------------------
    ;For now I'm using inc files, I can edit them directly
SteelFingerShimmerTiles:
    .include "assets\\tiles\\sprites\\sfsShimmer\\sfsShimmer_tiles.inc" 
SteelFingerShimmerTilesEnd:


