;===================================================
;General VDP Functions
;===================================================

;Tells VDP where it should be writing/reading data from in VRAM
;Parameters: HL = address
;Affects: No registers
SetVDPAddress:
    push af                     ;For safe keeping
        ld a, l                 ;Little endian
        out (VDPCommand), a     
        ld a, h
        out (VDPCommand), a
    pop af
    ret

;================================================================================

;Copies data to the VRAM
;Parameters: HL = data address, BC = data length
;Affects: A, HL, BC
CopyToVDP:
    
-:  ld a, (hl)                  ;Get data byte from location @ HL
    out (VDPData), a
    inc hl                      ;Point to next data byte
    dec bc                      ;Decrease our counter
    ld a, b
    or c
    jr nz, -
    ret

;================================================================================

;Sets one or more VDP Registers (Each one contains a byte)
;Parameters: HL = data address, B = # of registers to update 
;            C = Which VDP regiseter $8(register#)
;Affects: A, B, C, HL
SetVDPRegisters:
-:  ld a,(hl)                            ; load one byte of data into A.
    out (VDPCommand),a                   ; output data to VDP command port.
    ld a,c                               ; load the command byte.
    out (VDPCommand),a                   ; output it to the VDP command port.
    inc hl                               ; inc. pointer to next byte of data.
    inc c                                ; inc. command byte to next register.
    djnz -                               ; jump back to '-' if b > 0.   
    ret

;================================================================================

;Updates a single VDP Register 
;Parameters: A = register data (one byte) C = Which VDP regiseter $8(register#)
;Affects: A, C,B
UpdateVDPRegister:

    out (VDPCommand), a                 ;Load data into CDP
    ld a, c
    out (VDPCommand), a                 ;Tell it which register to put it to
    ret

;================================================================================


;Disables the display
;Parameters: 
;Affects: A, B, C, HL
BlankScreen:
        ;Turn on screen (Maxim's explanation is too good not to use)
    ld a, %00100000
;           ||||||`- Zoomed sprites -> 16x16 pixels
;           |||||`-- Not doubled sprites -> 1 tile per sprite, 8x8
;           ||||`--- Mega Drive mode 5 enable
;           |||`---- 30 row/240 line mode
;           ||`----- 28 row/224 line mode
;           |`------ VBlank interrupts
;            `------- Enable display    
    ld c, $81
    call UpdateVDPRegister
    ret

;================================================================================

;Clears VRAM
;Parameters: 
;Affects: A, B, C, HL
ClearVRAM:  
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
    ret 

;================================================================================

;===================================================
;Reality Checkers
;===================================================

;Updates the frame counter and resets at 60 
;Parameters: None
;Affects: A, HL
UpdateFrameCount:
    ld hl, frameCount           ;Update frame count
    ld a, 60                    ;Check if we are at 60
    cp (hl)
    jr nz, +                    ;If we are, then reset
ResetFrameCount:
    ld (hl), -1
+:
    inc (hl)                    ;Otherwise, increase
    ret

;================================================================================

;Updates any sprite-OBJect. DE is our *pointer, and HL is used for
;   updating the properties of the sprite
;Parameters: DE = sprite.sprNum
;Affects: DE, A, BC
MultiUpdateSATBuff:
    ;==============================================
    ;Update Sprite X, Y and CC
    ;==============================================
    push hl                     ;Preserving HL
    ;Determine Sprite Number
        ld a, (sprUpdCnt)
        ld (de), a
    ;Setting OBJ size to 0 and getting back to HW
        inc de                  ;ld de, OBJ.hw
        inc de                  ;ld de, OBJ.y
        inc de                  ;ld de, OBJ.x
        inc de                  ;ld de, OBJ.cc
        inc de                  ;ld de, OBJ.sprSize
        xor a
        ld (de), a              ;OBJ.size = 0
        dec de                  ;ld de, OBJ.cc
        dec de                  ;ld de, OBJ.x
        dec de                  ;ld de, OBJ.y
        dec de                  ;ld de, OBJ.hw
            
    ;Height
        ;ld de, OBJ.wh
        ld a, (de)              ;A now has hw
        ld b, %11110000         ;HEIGHT mask
        and b
        rrca
        rrca
        rrca
        rrca                    ;Shift right 4 times so B isn't carrying a higher value
        ld b, a                 ;B now contains the height
        ld a, (de)              ;A now has hw

    ;Width
        ;ld de, OBJ.wh
        ld a, (de)
        ld c, %00001111         ;WIDTH Mask
        and c
        ld c, a                 ;C now has the width
        jr +
        
MUSBWidthReset:
    ;Width
        ;ld de, OBJ.wh
        ld a, (de)
        ld c, %00001111         ;WIDTH Mask
        and c
        ld c, a                 ;C now has the width

    ;Adjust the height offset
        ld hl, sprYOff
        ld a, (hl)
        add a, $08              ;Specifically for 8x8 sprites
        ld (hl), a

    ;Adjust the width offset
        inc hl                  ;ld hl, sprXOff
        ld (hl), $00

    ;Adjust the cc offset
        inc hl                  ;ld hl, sprCCOff
        ld a, (hl)
        add a, $01              ;Specifically for 8x8
        ld (hl), a
        jr +                    ;Skip the *pointer reset

MUSBLoop:
    ;Resetting our *pointer
        dec de                      ;ld de, OBJ.cc
        dec de                      ;ld de, OBJ.x
        dec de                      ;ld de, OBJ.y
        dec de                      ;ld de, OBJ.hw
        dec c                       ;Decrease our counter

    ;Adjust the width offset
        ld hl, sprXOff
        ld a, (hl)
        add a, $08              ;Specifically for 8x8 OR 8x16 sprites
        ld (hl), a

    ;Adjust the cc offset
        inc hl                  ;ld hl, sprCCOff
        ld a, (hl)
        add a, $01              ;Specifically for 8x8
        ld (hl), a
+:
    ;Y coords 
        ld hl, sprite0              ;HL points to the vertical poisiton sprite 0
        ld a, (sprUpdCnt)
        add a, l
        ld l, a                     ;HL now points to Y of the next sprite we are updating
        inc de                      ;ld de, OBJ.y
        ld a, (de)
        ld (hl), a                  ;OBJ.y updated to OBJ's top left sprite Y coord
        ld a, (sprYOff)
        add a, (hl)
        ld (hl), a                  ;OBJ.y has been adjusted to the proper location

    ;X coords
        ld a, offsetHP              ;A is the offset for HPos
        add a, l         
        ld l, a
        ld a, (sprUpdCnt)           ;Since CC and HPos are next to each other, we need this for true offset
        add a, l
        ld l, a                     ;HL Points to X of sprite we are updating
        inc de                      ;ld de, OBJ.x
        ld a, (de)
        ld (hl), a                  ;OBJ.x updated to OBJ's top left sprite Y coord
        ld a, (sprXOff)
        add a, (hl)
        ld (hl), a                  ;OBJ.x has been adjusted to the proper location
             
    
    ;Character code
        inc hl                      ;HL Points to CC of sprite we are updating
        inc de                      ;ld de, OBJ.cc
        ld a, (de)                  ;Load's CC into A
        ld (hl), a                  ;OBJ.cc updated to OBJ's top left sprite Y coord
        ld a, (sprCCOff)
        add a, (hl)
        ld (hl), a                  ;OBJ.cc has been adjusted to the proper location

        ld hl, sprUpdCnt            ;Update num of sprites that have been updated
        ld a, (hl)
        inc a
        ld (hl), a                  

    ;Update Sprite Size
        inc de                      ;ld de, OBJ.sprSize
        ld a, (de)
        inc a
        ld (de), a

    ;Check how many more we have to go
        ld a, $01                   ;IDK, zero indexing or something?
        cp c
        jp nz, MUSBLoop             ;If there are still more in our row, go back
    ;If we have finished a row
    ;Reset our *pointer
        dec de                      ;ld de, OBJ.cc
        dec de                      ;ld de, OBJ.x
        dec de                      ;ld de, OBJ.y
        dec de                      ;ld de, OBJ.hw
        djnz MUSBWidthReset         ;If our Height != 0, then we keep drawing

    ;==============================================
    ;End Sprites
    ;==============================================
MUSBEndSprites:
    ;Don't use any more sprites, and  Update spriteCount
/*
        ld bc, spriteCount
        ld a, (sprUpdCnt)
        ld (bc), a
        ld l, a
        inc bc
        ld a, (bc)
        ld h, a
        ld (hl), $d0
*/
    ;Reset our offsets
        xor a
        ld hl, sprYOff
        ld (hl), a
        inc hl                  ;ld hl, (sprXOff)
        ld (hl), a
        inc hl                  ;ld hl, (sprCCOff)
        ld (hl), a              

    pop hl                      ;Recovering HL

    ret

;================================================================================

EndSprites:
    ;Don't use any more sprites
        ld bc, spriteCount
        ld a, (sprUpdCnt)
        ld (bc), a
        ld l, a
        inc bc
        ld a, (bc)
        ld h, a
        ld (hl), $d0

        ret        

/*
;Updates the counter for the total number of sprite on screen at once, 
;and updates the endSprite terminator value
;Parameters: B = inc or dec (1 or 0)
;Affects: A, B, HL
UpdateSprCnt:
    ld hl, spriteCount
    ld a, (spriteCount)
    djnz +
    ;One sprite has been added
    inc a
    ld (hl), a
    ret
+:
    ;One sprite has been removed
    dec a
    ld (hl), a
    ret
*/
;================================================================================

;Updates the Sprite Attribute table with the SAT Buffer
;Parameters: None
;Affects: B, C, HL
UpdateSAT:
    ;This will always be the first thing to happen at after VBLANK
    ;   So we will use this opportunity to reset the spriteUpdateCount
    ld hl, sprUpdCnt
    ld (hl), 0

    ld hl, $3f00 | VRAMWrite            ;Telling the VDP where to write this data
    call SetVDPAddress                  ;

    ld b, 255                           ;SAT is 256 bytes
    ld c, VDPData                       ;We want to write data
    ld hl, SATBuff                      ;We are writing the contents of the SAT buffer
    otir                                ;Write contents of HL to C with B bytes
    ret

;================================================================================

;===================================================
;Background Functions
;===================================================

;Writes text to the screen in the dialogue box area (bottom)
;Parameters: DE = Message
;Affects: A, BC, HL, DE

TextToScreen:
    ;First, let's set the RAM address to the correct tile map
    ld b, 0                                 ;Reset counter
    ld c, $00                               ;Set offset
    ld hl, TextBox | VRAMWrite
    call SetVDPAddress
    ;Then we can put stuff to the screen
    ex de, hl               ;load data in HL (from DE)
-:  ld a,25             
    cp b                    ;Check if we are at the end of the line
    jr nz, Write            ;
  
    ;We are writing on a new line, adding BC ($0040)
    push hl
        ld b, 0             ;Reset Counter
        ld a, c
        add a, $40
        ld c, a
        ld hl, TextBox | VRAMWrite
        add hl, bc
        add hl, bc          ;We are double spacing the text
        call SetVDPAddress   
    pop hl
    
Write:
    ld a, (hl)              ;Read until we hit $ff
    cp $ff                  ;
    jr z,+                  ;
    out (VDPData), a        ;
    xor a                   ;
    out (VDPData), a        ;
    inc hl                  ;
    inc b                   ;Increase counter
    jr -                                    ;
+:  ret

;================================================================================
/*
;Checks if a sprite is colliding with a tagible BG tile
;Parameters: H = (spriteX), E = (spriteY)
;Returns: A = collision is true (1) or false (0)
;Affects: A, B, DE, HL
BGTileCollision:
    ;The formula is TILE = $3800 + OMEGAx + OMEGAy where
    ; OMEGAx = $02 * [($Spritex - H-scroll)/8]
    ; OMEGAy = $40 * [($Spritey - V-scroll)/8] (No remainders)

    ;-------------------------------
    ;Adjust for H-scroll
    ;-------------------------------
    ld a, h                     ;Set y value
    ld hl, scrollX              ;Adjust for the H-scroll
    ld l, (hl)                  ;
    sub l                       ;
    ld h, a                     ;
    ;-------------------------------
    ;Find Nametable X coordinate
    ;-------------------------------
    ld d, 8                     ;Each space in Nametable is 8 pixels wide
    call Div8Bit
    ld a, l                     ;Result of division goes to A    
    add a, a                    ;Multiply by 2 --> each Nametable X increases by $02 bytes
    ld hl, colXOffset
    ld (hl), a                  ;Keeping track of the Nametable X-offset
    ;-------------------------------
    ;Adjust for V-scroll
    ;-------------------------------
    ld a, e                     ;The y-coordinate of our sprite 
    ld hl, scrollY              ;Adjusted for V-scroll
    ld l, (hl)                  ;
    add a, l                    ;        
    ld h, a
    ;-------------------------------
    ;Find Nametable Y coordinate
    ;-------------------------------
    ;ld h, e                     
    ld d, 8                     ;Each space in Nametable is 8 pixels tall
    call Div8Bit
    ld a, $40                   ;Nametable y-offset increases by $40 for each square unit
    ld d, 0                     ;This way DE has our 8-bit spriteY coordinate
    ld e,  l                    ;converted to tile location in square units
    call Mult8Bit               ;Square units converted to Nametable Address offset, HL = Product
    ;-------------------------------
    ;Create the Nametable Offset
    ;-------------------------------
    ld de, $3801                ;We want to add OMEGA to $3800 (Nametable) but the collision flag is little endian, so $3800 + 1
    add hl, de                  ;Add OMEGAy to our equation
    ld d, 0
    ld ix, colXOffset           ;Recall the x-offset
    ld e, (ix + 0)              ;Loading DE with the x-offset
    add hl, de                  ;Add OMEGAx to our equation
    ;Fixing a collision detected when we enter "beyond" the name table
    ld a, $3f                   ;Value beyond the Nametable
    cp h                        ;Check if our Nametable offset is... too offset
    jr z, +                     ;If it is, we don't want to check for collision...
    call SetVDPAddress          ;We want to read from it now
    in a, (VDPData)             ;read data to register A
    and $80                     ;Checking bit 7 for the collision flag
    ret
+:
    ld a, $00                   ;So we just say there is no collision and return
    ret
*/
;================================================================================

;===================================================
;Mathematics
;===================================================
;An alteration on the division algorithm used by Sean Mclaughlin in
;   Learn TI-83 Plus Assembly In 28 Days
;Divides one 8 bit number by another 8 bit number
;Parameters: H = Dividend, D = Divisor D/H  
;Returns: L = Quotient, A = Remainder
;Affects: A, B, D, HL
Div8Bit:
    xor a               ;Clear out A register
    ld l,  a            ;   and L register
    ld b, 8
Div8Loop:
    add hl, hl          ;shift H one to the left
    rla                 ;Put the carry into bit 0 of register A
    jr c, Div8Sub       ;If the carry flag gets set, we subtract
    cp d                ;If A is greater than or equal to D, we subtract
    jr nc, Div8Sub
    djnz Div8Loop       ;Otherwise, we refresh
    ret
Div8Sub:
    sub d               ;Subtract D from A
    inc l               ;Add to our quotient
    djnz Div8Loop
    ret

;================================================================================

;Used the logic from Learn TI-83 Plus Assembly In 28 Days
;Multiplies one 8-bit number by another 8 bit number
;Parameters: A = multiplier, DE = Multiplicand
;Returns: HL = 16-bit product
;Affects: A, HL, DE, B
Mult8Bit:
    ld hl, 0                ;Zero our product to start
    ld b, 8                 ;B is our 8-bit counter
Mult8Loop:
    srl a                   ;Shift A multiplier to the right
    jr c, Mult8Add          ;If there's a carry, then we add
    sla e                   ;Shift E left and bit 7 to carry
    rl d                    ;Take the carry from E into D
    djnz Mult8Loop          ;If we have gone through 8 bits,
    ret                     ;Then we exit
Mult8Add:
    add hl, de              ;Add the multiplicand to the product
    sla e                   ;Shift E left and bit 7 to carry
    rl d                    ;Take the carry from E into D
    djnz Mult8Loop          ;If we have gone through the 8 bits,
    ret                     ;Then we exit

;================================================================================
/*
;-----> Generate a random number
; output a=answer 0<=a<=255
; all registers are preserved except: af
;From WIKITI, based off the pseudorandom number generator featured 
;in Ion by Joe Wingbermuehle
random:
        push    hl
        push    de
        ld      hl,(randSeed)
        ld      a,r
        ld      d,a
        ld      e,(hl)
        add     hl,de
        add     a,l
        xor     h
        ld      (randSeed),hl
        pop     de
        pop     hl
        ret
*/
;===================================================
;Debugging
;===================================================
;This sets the sprite color palette to be grayscale
;Parameters: None
;Affects: None
TestFunction:
    push hl
        push bc
            ld hl, $c010 | CRAMWrite
            call SetVDPAddress
            ; Next we send the VDP the palette data
            ld hl, TestPalette
            ld bc, TestPaletteEnd-TestPalette
            call CopyToVDP
        pop bc
    pop hl
    ret
