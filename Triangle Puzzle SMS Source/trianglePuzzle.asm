TrianglePuzzle:
;==============================================================
; Scene beginning
;==============================================================
    ld hl, sceneComplete
    ld (hl), $00

    inc hl                                  ;ld hl, sceneID
    ld (hl), $02

;==============================================================
; Memory (Structures, Variables & Constants) 
;==============================================================

.enum postPal export
    player instanceof selector
    menu instanceof menuStruct
    strips instanceof strip     18
    bufferStrip instanceof strip                ;To avoid adding last strip edge cases
    selectedStripOne            db
    selectedStripTwo            db
    selectedStripThree          db
    nodes instanceof node       10
    statusBar instanceof statusBarStruct
    joypadOne                   db
    numSelectedNodes            db    
    numSelectedStrips           db
    horiColorSwapThree          dw              ;High byte: Color, Low Byte: stripNum
    rightColorSwapThree         dw              ;High byte: Color, Low Byte: stripNum
    leftColorSwapThree          dw              ;High byte: Color, Low Byte: stripNum
    numWinningTriangles         db
.ende

;Useful constants for using pointers without a linked list structure
.define nodePointer     nodes.1.nodeNum
.define nodeSize        nodes.1.nodeCC - nodes.1.nodeNum + 1

.define stripPointer    strips.1.stripNum
.define stripSize       strips.1.sprSize - strips.1.stripNum + 1


;==============================================================
; Clear VRAM
;==============================================================
    call BlankScreen

    call ClearVRAM

    call ClearSATBuff


;==============================================================
; Load Palette
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

;Shares the same palette as the title screen, and it won't be wiped

;Actually update the palettes in VRAM
    call LoadBackgroundPalette
    call LoadSpritePalette

;==============================================================
; Load BG tiles 
;==============================================================
/*
;Decompressing Triangle Puzzle Screen
    ld hl, TrianglePuzzleTiles
    ld de, $0000 | VRAMWrite
    call Decompress
*/

;Load Triangle Puzzle Screen
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ld hl, TrianglePuzzleTiles
    ld bc, TrianglePuzzleTilesEnd-TrianglePuzzleTiles
    call CopyToVDP

;Selected Nodes
    ld hl, SelectedNodeTiles
    ld de, $0C20 | VRAMWrite
    call Decompress

;Set button inactive
    call SetActiveSwapColors
    call SetInactiveSwapColors


;Load You Win Tiles
    ld hl, $1200 | VRAMWrite
    call SetVDPAddress
    ld hl, YouWinTiles
    ld bc, YouWinTilesEnd-YouWinTiles
    call CopyToVDP
 

;==============================================================
; Write background map
;==============================================================
;Loading in the testing background
/*
;Haven't gotten this to work. I also haven't tried fixing it though soooooo
    ld hl, TrianglePuzzleMap
    ld de, $3800
    call Decompress
*/

    ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, TrianglePuzzleMap
    ld bc, TrianglePuzzleMapEnd-TrianglePuzzleMap
    call CopyToVDP

;A remnant of this being for writing the map
    ;call SetInactiveSwapColors
    ;call SetActiveSwapColors
    call ChangeSwapTiles
    

;==============================================================
; Load Sprite tiles 
;==============================================================
    
;Now we want to write the character data. For now, we will just
;keep all the frames in VRAM since there's so few
    ld hl, $2000 | VRAMWrite
    call SetVDPAddress
;Left Facing Colored Strips
    ld hl, RedLeft
    ld de, redLeftAdr | VRAMWrite
    call Decompress
    ld hl, GreenLeft
    ld de, grnLeftAdr | VRAMWrite
    call Decompress
    ld hl, BlueLeft
    ld de, bluLeftAdr | VRAMWrite
    call Decompress

;Right Facing Colored Strips
    ld hl, RedRight
    ld de, redRightAdr | VRAMWrite
    call Decompress
    ld hl, GreenRight
    ld de, grnRightAdr | VRAMWrite
    call Decompress
    ld hl, BlueRight
    ld de, bluRightAdr | VRAMWrite
    call Decompress

;Horizontal Colored Strips
    ld hl, RedHori
    ld de, redHoriAdr | VRAMWrite
    call Decompress
    ld hl, GreenHori
    ld de, grnHoriAdr | VRAMWrite
    call Decompress
    ld hl, BlueHori
    ld de, bluHoriAdr | VRAMWrite
    call Decompress

;Player Select Ring
    ld hl, SelectRing
    ld de, slctRngAdr | VRAMWrite
    call Decompress

;Menu Selectors
    ld hl, MenuTL
    ld de, menuTLAdr | VRAMWrite
    call Decompress
    ld hl, MenuTR
    ld de, menuTRAdr | VRAMWrite
    call Decompress
    ld hl, MenuBL
    ld de, menuBLAdr | VRAMWrite
    call Decompress
    ld hl, MenuBR
    ld de, menuBRAdr | VRAMWrite
    call Decompress

;Font Tiles
    ld hl, $27E0 | VRAMWrite
    call SetVDPAddress
    ld hl, FontTiles
    ld bc, FontTilesEnd-FontTiles
    call CopyToVDP

;Tall Numbers
    ld hl, $3000 | VRAMWrite
    call SetVDPAddress
    ld hl, TallNumbers
    ld de, $3000 | VRAMWrite
    call Decompress


;==============================================================
; Intialize our Variables
;==============================================================
    xor a                               ;A = 0
    ld hl, joypadOne
    ld (hl), a
    inc hl                              ;ld hl, numSelectedNodes
    ld (hl), a
    inc hl                              ;ld hl, numSelectedStrips
    ld (hl), a
;Zero out our words
    inc hl                              ;ld hl, horiColorSwapThreeH
    ld (hl), a
    inc hl                              ;ld hl, horiColorSwapThreeL
    ld (hl), a
    inc hl                              ;ld hl, rightColorSwapThreeH
    ld (hl), a
    inc hl                              ;ld hl, rightColorSwapThreeL
    ld (hl), a
    inc hl                              ;ld hl, leftColorSwapThreeH
    ld (hl), a
    inc hl                              ;ld hl, leftColorSwapThreeL
    ld (hl), a
    inc hl                              ;ld hl, numWinningTriangles
    ld (hl), a


    ld hl, selectedStripOne
    ld (hl), a
    inc hl                              ;ld hl, selectedStripTwo
    ld (hl), a
    inc hl                              ;ld hl, selectedStripThree
    ld (hl), a


;==============================================================
; Intialize our objects
;==============================================================

    call InitStrips

    call InitNodes

    call InitSelector

    call InitMenu

    call InitStatusBar

;==============================================================
; Set Registers for HBlank
;==============================================================
    ld a, $FF                               ;$FF = no HBlank
    ld c, $8A
    call UpdateVDPRegister

;Unblank Left Column
    ld a, %00010100
    ld c, $80
    call UpdateVDPRegister

;==============================================================
; Turn on screen
;==============================================================
;Draw the selector first since it has to be the top-most sprite
    ld de, player.sprNum
    call MultiUpdateSATBuff

;Draw strips to screen, we don't have to do this all every single frame
    call DrawStrips

;Initial draw for the move graphics
    call DrawMovesGraphic

;Initial for score graphics
    call DrawScoreGraphic

;Must manually call due to not wanting to update all strips every frame
    call EndSprites

;Write to VRAM before display turns on
    call UpdateSAT


 ;(Maxim's explanation is too good not to use)
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


;========================================================
; Game Logic
;========================================================

    call FadeIn

TrianglePuzzleMainLoop:
    halt
    jp CheckVBlank

PostVBlank:

;Check if we are at pause screen
    ld a, (sceneID)
    cp $FF
    jp z, AtSolutionScreen

    call UpdateSAT

    call UpdateFrameCount

;Draw the Player Selector on screen
    call CheckMenuOrTri                     ;DE will be appropriate sprite
    ;ld de, player/menu.sprNum
    call MultiUpdateSATBuff  

;Check Joypad and save player input
    call CheckPlayerInput

    jp TrianglePuzzleMainLoop               ;Let's keep it going


;========================================================
; Triangle Puzzle Data
;========================================================
;---------------------------------
;Raw data for the selected node
;---------------------------------
SelectedTop:
    .db $61 $00 $61 $02
SelectedBottom:
    .db $61 $04 $61 $06
;---------------------------------
;Raw data for the unselected node
;---------------------------------
UnselectedTop:
    .db $1D $00 $1D $02
UnselectedBottom:
    .db $1D $04 $1D $06

;---------------------------------
;Addresses of Nodes in VRAM
;---------------------------------
;Addresses are OR'd with VRAMWrite, and are sequential so we can access them with a single call
VRAMReadyNodeAddressess:
    .dw nodeOneAdr nodeTwoAdr nodeThreeAdr nodeFourAdr nodeFiveAdr 
    .dw nodeSixAdr nodeSevenAdr nodeEightAdr nodeNineAdr nodeTenAdr



;========================================================
; Background Palette
;========================================================
TrianglePuzzle_bgPal:
    .include "assets\\palettes\\backgrounds\\trianglePuzzle_bgPal.inc"
TrianglePuzzle_bgPalEnd:

;========================================================
; Background Tiles
;========================================================
TrianglePuzzleTilesCompressed:
    .incbin "assets\\tiles\\backgrounds\\trianglePuzzle_tiles.pscompr"


TrianglePuzzleTiles:
    .include "assets\\tiles\\backgrounds\\trianglePuzzle_tiles.inc"
TrianglePuzzleTilesEnd:


AnswerTiles:
    .include "assets\\tiles\\backgrounds\\answers_tiles.inc"
AnswerTilesEnd:


SelectedNodeTiles:
    .incbin "assets\\tiles\\backgrounds\\selectNode_tiles.pscompr"


InactiveSwapColorsTiles:
    .include "assets\\tiles\\backgrounds\\InactiveSwapColors_tiles.inc"
InactiveSwapColorsTilesEnd:

ActiveSwapColorsTiles:
    .include "assets\\tiles\\backgrounds\\activeSwapColors_tiles.inc"
ActiveSwapColorsTilesEnd:

YouWinTiles:
    .include "assets\\tiles\\backgrounds\\youWin_tiles.inc"
YouWinTilesEnd:

;========================================================
; Tile Maps
;========================================================
TrianglePuzzleMap:
    .include "assets\\maps\\trianglePuzzle_map.inc"
TrianglePuzzleMapEnd:


AnswerMap:
    .include "assets\\maps\\answers_map.inc"
AnswerMapEnd:


YouWinMap:
    .include "assets\\maps\\youWin_map.inc"
YouWinMapEnd:
WinVRAM:
    .dw $3A06 | VRAMWrite


InactiveSwapColorsMap:
    .include "assets\\maps\\inactiveSwapColors_map.inc"

ActiveSwapColorsMap:
    .include "assets\\maps\\activeSwapColors_map.inc"
SwapColorsVRAM:
    .dw $3966 | VRAMWrite


TrianglePuzzleMapCompressed:
    .incbin "assets\\maps\\trianglePuzzle_map.pscompr"




;========================================================
; Sprite Palette
;========================================================
TrianglePuzzle_sprPal:
    .include "assets\\palettes\\sprites\\trianglePuzzle_sprPal.inc"
TrianglePuzzle_sprPalEnd:


;========================================================
; Sprite Tiles
;========================================================
RedLeft:
    .incbin "assets\\tiles\\sprites\\left\\rl.pscompr"
GreenLeft:
    .incbin "assets\\tiles\\sprites\\left\\gl.pscompr"
BlueLeft:
    .incbin "assets\\tiles\\sprites\\left\\bl.pscompr"

;-----------------------

RedRight:
    .incbin "assets\\tiles\\sprites\\right\\rr.pscompr"
GreenRight:
    .incbin "assets\\tiles\\sprites\\right\\gr.pscompr"
BlueRight:
    .incbin "assets\\tiles\\sprites\\right\\br.pscompr"

;-----------------------

RedHori:
    .incbin "assets\\tiles\\sprites\\hori\\rh.pscompr"
GreenHori:
    .incbin "assets\\tiles\\sprites\\hori\\gh.pscompr"
BlueHori:
    .incbin "assets\\tiles\\sprites\\hori\\bh.pscompr"

;-----------------------

SelectRing:
    .incbin "assets\\tiles\\sprites\\selectRing\\selectRing.pscompr"

;-----------------------

MenuTL:
    .incbin "assets\\tiles\\sprites\\menuSelector\\TL.pscompr"
MenuTR:
    .incbin "assets\\tiles\\sprites\\menuSelector\\TR.pscompr"
MenuBL:
    .incbin "assets\\tiles\\sprites\\menuSelector\\BL.pscompr"
MenuBR:
    .incbin "assets\\tiles\\sprites\\menuSelector\\BR.pscompr"

;-----------------------

TallNumbers:
    .incbin "assets\\tiles\\sprites\\tallNumbers\\tallNumbers.pscompr"


    