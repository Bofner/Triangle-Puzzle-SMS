;==============================================================
; Swap Colors Inactive 
;==============================================================
SetInactiveSwapColors:
;Inactive Swap Edges
    ;halt                                                        ;Smoother transition
    ld hl, $0C40 | VRAMWrite
    call SetVDPAddress
    ld hl, InactiveSwapColorsTiles
    ld bc, InactiveSwapColorsTilesEnd-InactiveSwapColorsTiles
    call CopyToVDP

    ret


SetActiveSwapColors:
;Active Swap Edges
    ;halt                                                        ;Smoother transition
    ld hl, $0F20 | VRAMWrite
    call SetVDPAddress
    ld hl, ActiveSwapColorsTiles
    ld bc, ActiveSwapColorsTilesEnd-ActiveSwapColorsTiles
    call CopyToVDP

    ret


ChangeSwapTiles:
    ld de, $0000                                ;Our offset for moving down a row
    ld b, $04                                   ;Number of rows to draw
    ld hl, InactiveSwapColorsMap                ;Location of tile map data

-:                                              ;LOOP start
    push bc                                     ;Save Counter
        push hl                                 ;Save map address
            ld hl, (SwapColorsVRAM)
            add hl, de
            call SetVDPAddress                  ;Draw to correct spot in VRAM
;DE + $40 for the next row to be drawn
            ld hl, $0040                
            add hl, de
            ld d, h
            ld e, l
        pop hl                                  ;ld hl, InactiveSwapColorsMap
        ld bc, 22
        call CopyToVDP
    pop bc
    djnz -                                      ;LOOP end

    ret


SetInactiveSwapColorsMap:
    ld de, $0000                                ;Our offset for moving down a row
    ld b, $04                                   ;Number of rows to draw
    ld hl, InactiveSwapColorsMap                ;Location of tile map data

-:                                              ;LOOP start
    push bc                                     ;Save Counter
        push hl                                 ;Save map address
            ld hl, (SwapColorsVRAM)
            add hl, de
            call SetVDPAddress                  ;Draw to correct spot in VRAM
;DE + $40 for the next row to be drawn
            ld hl, $0040                
            add hl, de
            ld d, h
            ld e, l
        pop hl                                  ;ld hl, InactiveSwapColorsMap
        ld bc, 22
        call CopyToVDP
    pop bc
    djnz -                                      ;LOOP end

    ld hl, menu.swapable
    xor a
    ld (hl), a                                                  ;Menu indicates that we cannot swap!


    ret

SetActiveSwapColorsMap:
    ld de, $0000                                ;Our offset for moving down a row
    ld b, $04                                   ;Number of rows to draw
    ld hl, ActiveSwapColorsMap                  ;Location of tile map data

-:                                              ;LOOP start
    push bc                                     ;Save Counter
        push hl                                 ;Save map address
            ld hl, (SwapColorsVRAM)
            add hl, de
            call SetVDPAddress                  ;Draw to correct spot in VRAM
;DE + $40 for the next row to be drawn
            ld hl, $0040                
            add hl, de
            ld d, h
            ld e, l
        pop hl                                  ;ld hl, InactiveSwapColorsMap
        ld bc, 22
        call CopyToVDP
    pop bc
    djnz -                                      ;LOOP end

    ld hl, menu.swapable
    ld a, $FF
    ld (hl), a                                                  ;Menu indicates that we can swap!


    ret





