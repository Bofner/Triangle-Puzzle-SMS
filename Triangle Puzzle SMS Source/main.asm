;==============================================================
; WLA-DX banking setup
;==============================================================
.memorymap
defaultslot 0
slotsize $8000
slot 0 $0000
.endme

.rombankmap
bankstotal 1
banksize $8000
banks 1
.endro

;==============================================================
; SMS defines
;==============================================================
.define VDPCommand  $bf 
.define VDPData     $be
.define VRAMWrite   $4000
.define CRAMWrite   $c000
.define NameTable   $3800
.define TextBox     $3ccc

.define UpBounds    $02
.define DownBounds  $bd
.define LeftBounds  $05
.define RightBounds $fd

;==============================================================
; Game Constants
;==============================================================
;-------------------
; Strips
;-------------------
.define RED             $00
.define GREEN           $03
.define BLUE            $06

.define LEFT            $00
.define RIGHT           $09
.define HORI            $12

.define redLeftAdr      $2000
.define redLeftSpr      $00
.define grnLeftAdr      $2060
.define grnLeftSpr      $03
.define bluLeftAdr      $20c0
.define bluLeftSpr      $06

.define redRightAdr     $2120
.define redRightSpr     $09
.define grnRightAdr     $2180
.define grnRightSpr     $0c
.define bluRightAdr     $21e0
.define bluRightSpr     $0f

.define redHoriAdr      $2240
.define redHoriSpr      $12
.define grnHoriAdr      $22a0
.define grnHoriSpr      $15
.define bluHoriAdr      $2300
.define bluHoriSpr      $18

;-------------------
; Nodes
;-------------------
.define nodeBottom      $40             ;An offset to find the address of the bottom of the node

.define nodeOneAdr      $3990 | VRAMWrite
.define nodeTwoAdr      $3A8C | VRAMWrite
.define nodeThreeAdr    $3A94 | VRAMWrite
.define nodeFourAdr     $3B88 | VRAMWrite
.define nodeFiveAdr     $3B90 | VRAMWrite
.define nodeSixAdr      $3B98 | VRAMWrite
.define nodeSevenAdr    $3C84 | VRAMWrite
.define nodeEightAdr    $3C8C | VRAMWrite
.define nodeNineAdr     $3C94 | VRAMWrite
.define nodeTenAdr      $3C9C | VRAMWrite


.define UNSELECTED       $00
.define SELECTED         $FF

;-------------------
; Selector
;-------------------
.define slctRngAdr      $2360
.define slctRngSpr      $1b

;-------------------
; Menu Selector
;-------------------
;TL
.define menuTLAdr       $23E0
.define menuTLSpr       $1f
;TR
.define menuTRAdr       $2400
.define menuTRSpr       $20
;BL
.define menuBLAdr       $2420
.define menuBLSpr       $21
;BR
.define menuBRAdr       $2440
.define menuBRSpr       $22

;-------------------
; Status Bar
;-------------------
.define zeroAdr $3040
.define zeroSpr $82

;==============================================================
; Variables 
;==============================================================
.enum $c000 export
    SATBuff         dsb 256     ;Set aside 256 bytes for SAT buffer $100

    VDPStatus       db          ;Variable that determines the VDP status, called during interrupt

    INTNumber       db          ;Variable that tells us which interrupt are we on

    spriteCount     dw          ;How many sprites are on screen at once? It's a word to assist the SATBuffer
    sprUpdCnt       db          ;Keeps track of how many sprites we have updated per frame

    scrollX         db          ;Scroll value for BG in x direction
    scrollY         db          ;Scroll value for BG in y direction 

    frameCount      db          ;Used to count frames in intervals of 60

    sceneComplete   db          ;Used to determine if a scene is finished or not

    sprYOff         db          ;Offset for the Y position of sprites when drawing them to the screen (Updates by $10)
    sprXOff         db          ;Offset for the X position of sprites when drawing them to the screen (Updates by $08)
    sprCCOff        db          ;Offset for the CC of sprites when drawing them to the screen         (Updates by $02)

    ;$c000 to $dfff is the space I have to work with for variables and such
    endByte         db          ;The first piece of available data post boiler-plate data
    
.ende



;=============================================================================
; Special numbers 
;=============================================================================
.define postBoiler  endByte     ;Location in memory that is past the boiler plate stuff

;==============================================================
; SDSC tag and ROM header
;==============================================================
.sdsctag 0.1, "Triangle Puzzle", "CS 509 Java Project to SMS","Bofner"

.bank 0 slot 0
.org $0000
;==============================================================
; Boot Section
;==============================================================
    di              ;Disable interrupts
    im 1            ;Interrupt mode 1
    jp init         ;Jump to the initialization program

;==============================================================
; Interrupt Handler
;==============================================================
.orga $0038
    push af
    push hl
        in a,(VDPCommand)
        ld (VDPStatus), a
        ld hl, INTNumber
        ld a, (hl)
        inc a
        ld (hl), a
    pop hl
    pop af
    ei
    reti

;==============================================================
; Pause button handler
;==============================================================
.org $0066
    
    retn


;==============================================================
; Start up/Initialization
;==============================================================
init: 
    ld sp, $dff0

;==============================================================
; Set up VDP Registers
;==============================================================

    ld hl,VDPInitData                       ; point to register init data.
    ld b,VDPInitDataEnd - VDPInitData       ; 11 bytes of register data.
    ld c, $80                               ; VDP register command byte.
    call SetVDPRegisters
    

;==============================================================
; Clear VRAM
;==============================================================
;Set first color in sprite palette to black
    ld hl, $c010 | CRAMWrite
    call SetVDPAddress
    ;Next we send the BG palette data
    ld (hl), $00
    ld bc, $01
    call CopyToVDP

    call BlankScreen
    
    call ClearVRAM

;==============================================================
; Setup general sprite variables
;==============================================================
;Let a hold zero
    xor a

;Initialize the number of sprites on the screen
    ld hl, spriteCount      ;Set sprite count to 0
    ld (hl), a              ;
    inc hl                  ;Saving a memory address ($c000, beginning of SAT buffer)
    ld (hl), $C0

;Initialize the number of sprites that have been updated
    ld hl, sprUpdCnt        ;Set num of updated sprites to 0
    ld (hl), a              ;

;Initialize the offsets for our sprites to be zero
    ld hl, sprYOff
    ld (hl), a
    inc hl                  ;ld hl, sprXOff
    ld (hl), a
    inc hl                  ;ld hl, sprCCOff
    ld (hl), a

;==============================================================
; Game sequence
;==============================================================

    call TitleScreen

    jp TrianglePuzzle

;========================================================
; Include Object Files
;========================================================
.include "structs.asm"
.include "initStripsAndNodes.asm"
.include "initPlayerStructs.asm"
.include "initStatusBar.asm"
.include "playerSelector.asm"
.include "swapColorsButton.asm"
.include "node.asm"
.include "strip.asm"
.include "menu.asm"
.include "statusBar.asm"

;========================================================
; Include Game Mechanic Files
;========================================================
.include "checkPlayerInput.asm"
.include "checkSWInput.asm"
.include "navigateMenu.asm"

;========================================================
; Include Helper Files
;========================================================
.include "psDecompression.asm"
.include "helperFunctions.asm"
.include "drawStrips.asm"
.include "interruptSubroutines.asm"

;========================================================
; Include Level Files
;========================================================
.include "titleScreen.asm"
.include "trianglePuzzle.asm"


;========================================================
; Registers
;========================================================
; There are 11 registers, so 11 data
VDPInitData:
              .db %00010100             ; reg. 0

              .db %10100000             ; reg. 1

              .db $ff                   ; reg. 2, Name table at $3800

              .db $ff                   ; reg. 3 Always set to $ff

              .db $ff                   ; reg. 4 Always set to $ff

              .db $ff                   ; reg. 5 Address for SAT, $ff = SAT at $3f00 

              .db $ff                   ; reg. 6 Base address for sprite patterns

              .db $f0                   ; reg. 7 Overrscan Color    

              .db $00                   ; reg. 8 Horizontal Scroll

              .db $00                   ; reg. 9 Vertical Scroll

              .db $ff                   ; reg. 10 Raster line interrupt every 24 scanlines

VDPInitDataEnd:

;========================================================
; Text Configuration
;========================================================
    .asciitable
        map " " = $d5
        map "0" to "9" = $d6
        map "!" = $e0
        map "," = $e1
        map "." = $e2
        map "'" = $e3
        map "?" = $e4
        map "A" to "Z" = $e5
    .enda

TestMessage:
    ;50Ch"0123456789ABCDEF789012345 123456789ABCDEF789012345"
    .asc "Intiate work on Triangle  Puzzle!"
    .db $ff     ;Terminator byte

TestPalette:
    .db $00 $15 $2A $3F $00 $15 $2A $3F $3F $2A $15 $00 $3F $2A $15 $00
TestPaletteEnd:


;========================================================
; Extra Data
;========================================================
    .include "spriteDefines.asm"

FontTiles:
    ;Font Tile Data
    .include "assets\\tiles\\backgrounds\\font_tiles.inc" 
FontTilesEnd:


