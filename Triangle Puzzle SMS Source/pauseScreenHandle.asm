;========================================================
; Pause Screen
;========================================================
AtSolutionScreen:

;Dim the screen
    call FadeToBlack

;Set up next screen for starting with 0 sprites
    ld hl, spriteCount
    ld (hl), $00
    ld hl, sprUpdCnt
    ld (hl), $00
    
;Don't want any sprites on screen
    call EndSprites

    halt                                    ;Wait for VBlank
;Write to VRAM 
    call UpdateSAT

;Load Answers Screen
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ld hl, AnswerTiles
    ld bc, AnswerTilesEnd-AnswerTiles
    call CopyToVDP

;Update Background
    ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, AnswerMap
    ld bc, AnswerMapEnd-AnswerMap
    call CopyToVDP

    call FadeIn

SolutionsLoop:

    halt

;Check if we are at puzzle screen
    ld a, (sceneID)
    cp $02
    jr nz, ++
;Return to Puzzle
    halt
;Darken Screen
    call FadeToBlack
;Update sprites
    call UpdateSAT
;Unselect all nodes
    call UnselectAllNodes
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
;Update Background
    ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, TrianglePuzzleMap
    ld bc, TrianglePuzzleMapEnd-TrianglePuzzleMap
    call CopyToVDP
;No Nodes available to select
    call ChangeSwapTiles
;Return to puzzle screen
    call FadeIn

;Leave Pause screen
    jp TrianglePuzzleMainLoop

;Still on Pause Screen
++:
    jp SolutionsLoop               ;Let's keep it going