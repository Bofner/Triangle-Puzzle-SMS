;===================================================
;Strips (One Indexed)
;===================================================
InitStrips:
/*  
                ロ              row 0
             1 /  \ 4           
              ロ - ロ           row 1
           2 /  \ /  \ 5
            ロ - ロ - ロ        row 2
         3 /  \ /  \ /  \ 6
          ロ - ロ - ロ - ロ     row 3

.struct strip
    stripNum    db      ;The ID for the strip
    nodeOne     db      ;Each strip has 2 nodes
    nodeTwo     db      ;
    selected    db      ;If both nodes are selected, edge is selected

    orientation db      ;Is the strip Left, Right or Hori (this will also act as an offset for CC)
                        ;Left = $00, Right = $09, Hori = $12
    initColor   db      ;Color of strip at the start of the puzzle
    finalColor  db      ;Color of strip at the win condition
    color       db      ;Is the strip Red, Green or Blue (Used as an offset) 
                        ;Red = $00, Green = $03, Blue = $06

    sprNum      db
    hw          db
    y           db
    x           db 
    cc          db
    sprSize     db
.endst 

*/

;==================================================================================
;OUTER STRIPS
;==================================================================================
;===================================================
;Strip 1
;===================================================
    ld hl, strips.1.stripNum
    ld (hl), 1
    inc hl                          ;ld hl, nodeOne
    ld (hl), 1
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 2
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), $09                    ;RIGHT
    inc hl                          ;ld hl, initColor
    ld (hl), RED                    ;RED
    inc hl                          ;ld hl, finalColor
    ld (hl), RED                    ;RED
    inc hl                          ;ld hl, color
    ld (hl), RED                    ;RED

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 59
    inc hl                          ;ld hl, x
    ld (hl), 60
    inc hl                          ;ld hl, cc
    ld (hl), RIGHT                  ;RIGHT
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 2
;===================================================
    inc hl                          ;ld hl, strips.2.stripNum
    ld (hl), 2
    inc hl                          ;ld hl, nodeOne
    ld (hl), 2
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 4
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), $09                    ;RIGHT
    inc hl                          ;ld hl, initColor
    ld (hl), RED                    ;RED
    inc hl                          ;ld hl, finalColor
    ld (hl), BLUE                   ;BLUE
    inc hl                          ;ld hl, color
    ld (hl), RED                    ;RED

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 91
    inc hl                          ;ld hl, x
    ld (hl), 44
    inc hl                          ;ld hl, cc
    ld (hl), RIGHT                  ;RIGHT
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 3
;===================================================
    inc hl                          ;ld hl, strips.3.stripNum
    ld (hl), 3
    inc hl                          ;ld hl, nodeOne
    ld (hl), 4
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 7
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), RIGHT                  ;RIGHT
    inc hl                          ;ld hl, initColor
    ld (hl), RED                      ;RED
    inc hl                          ;ld hl, finalColor
    ld (hl), GREEN                  ;GREEN
    inc hl                          ;ld hl, color
    ld (hl), RED                      ;RED
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 123
    inc hl                          ;ld hl, x
    ld (hl), 28
    inc hl                          ;ld hl, cc
    ld (hl), RIGHT                  ;RIGHT
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 4
;===================================================
    inc hl                          ;ld hl, strips.4.stripNum
    ld (hl), 4
    inc hl                          ;ld hl, nodeOne
    ld (hl), 1
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 3
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), LEFT                   ;LEFT
    inc hl                          ;ld hl, initColor
    ld (hl), RED                    ;RED
    inc hl                          ;ld hl, finalColor
    ld (hl), RED                    ;RED
    inc hl                          ;ld hl, color
    ld (hl), RED                    ;RED
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 59
    inc hl                          ;ld hl, x
    ld (hl), 76
    inc hl                          ;ld hl, cc
    ld (hl), LEFT                   ;LEFT
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 5
;===================================================
    inc hl                          ;ld hl, strips.5.stripNum
    ld (hl), 5
    inc hl                          ;ld hl, nodeOne
    ld (hl), 3
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 6
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), LEFT                   ;LEFT
    inc hl                          ;ld hl, initColor
    ld (hl), RED                    ;RED
    inc hl                          ;ld hl, finalColor
    ld (hl), GREEN                  ;GREEN
    inc hl                          ;ld hl, color
    ld (hl), RED                    ;RED
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 91
    inc hl                          ;ld hl, x
    ld (hl), 92
    inc hl                          ;ld hl, cc
    ld (hl), LEFT                   ;LEFT
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 6
;===================================================
    inc hl                          ;ld hl, strips.6.stripNum
    ld (hl), 6
    inc hl                          ;ld hl, nodeOne
    ld (hl), 6
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 10
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), LEFT                   ;LEFT
    inc hl                          ;ld hl, initColor
    ld (hl), RED                    ;RED
    inc hl                          ;ld hl, finalColor
    ld (hl), BLUE                   ;BLUE
    inc hl                          ;ld hl, color
    ld (hl), RED                    ;RED
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 123
    inc hl                          ;ld hl, x
    ld (hl), 108
    inc hl                          ;ld hl, cc
    ld (hl), LEFT                   ;LEFT
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;==================================================================================
;HORIZONTAL STRIPS
;==================================================================================
;===================================================
;Strip 7
;===================================================
    inc hl                          ;ld hl, strips.7.stripNum
    ld (hl), 7
    inc hl                          ;ld hl, nodeOne
    ld (hl), 2
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 3
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), HORI                   ;HORI
    inc hl                          ;ld hl, initColor
    ld (hl), GREEN                  ;GREEN
    inc hl                          ;ld hl, finalColor
    ld (hl), RED                    ;RED
    inc hl                          ;ld hl, color
    ld (hl), GREEN                  ;GREEN
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $12                    
    inc hl                          ;ld hl, y
    ld (hl), 82
    inc hl                          ;ld hl, x
    ld (hl), 64
    inc hl                          ;ld hl, cc
    ld (hl), HORI                   ;HORI
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 8
;===================================================
    inc hl                          ;ld hl, strips.8.stripNum
    ld (hl), 8
    inc hl                          ;ld hl, nodeOne
    ld (hl), 4
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 5
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), HORI                   ;HORI
    inc hl                          ;ld hl, initColor
    ld (hl), GREEN                  
    inc hl                          ;ld hl, finalColor
    ld (hl), BLUE                   
    inc hl                          ;ld hl, color
    ld (hl), GREEN                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $12                    
    inc hl                          ;ld hl, y
    ld (hl), 114
    inc hl                          ;ld hl, x
    ld (hl), 48
    inc hl                          ;ld hl, cc
    ld (hl), HORI                   ;HORI
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 9
;===================================================
    inc hl                          ;ld hl, strips.9.stripNum
    ld (hl), 9
    inc hl                          ;ld hl, nodeOne
    ld (hl), 5
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 6
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), HORI                   ;HORI
    inc hl                          ;ld hl, initColor
    ld (hl), GREEN                  
    inc hl                          ;ld hl, finalColor
    ld (hl), GREEN                   
    inc hl                          ;ld hl, color
    ld (hl), GREEN                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $12                    
    inc hl                          ;ld hl, y
    ld (hl), 114
    inc hl                          ;ld hl, x
    ld (hl), 80
    inc hl                          ;ld hl, cc
    ld (hl), HORI                   ;HORI
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 10
;===================================================
    inc hl                          ;ld hl, strips.10.stripNum
    ld (hl), 10
    inc hl                          ;ld hl, nodeOne
    ld (hl), 7
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 8
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), HORI                   ;HORI
    inc hl                          ;ld hl, initColor
    ld (hl), GREEN                  
    inc hl                          ;ld hl, finalColor
    ld (hl), GREEN                   
    inc hl                          ;ld hl, color
    ld (hl), GREEN                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $12                    
    inc hl                          ;ld hl, y
    ld (hl), 146
    inc hl                          ;ld hl, x
    ld (hl), 32
    inc hl                          ;ld hl, cc
    ld (hl), HORI                   ;HORI
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 11
;===================================================
    inc hl                          ;ld hl, strips.11.stripNum
    ld (hl), 11
    inc hl                          ;ld hl, nodeOne
    ld (hl), 8
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 9
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), HORI                   ;HORI
    inc hl                          ;ld hl, initColor
    ld (hl), GREEN                  
    inc hl                          ;ld hl, finalColor
    ld (hl), RED                   
    inc hl                          ;ld hl, color
    ld (hl), GREEN                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $12                    
    inc hl                          ;ld hl, y
    ld (hl), 146
    inc hl                          ;ld hl, x
    ld (hl), 64
    inc hl                          ;ld hl, cc
    ld (hl), HORI                   ;HORI
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 12
;===================================================
    inc hl                          ;ld hl, strips.12.stripNum
    ld (hl), 12
    inc hl                          ;ld hl, nodeOne
    ld (hl), 9
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 10
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), HORI                   ;HORI
    inc hl                          ;ld hl, initColor
    ld (hl), GREEN                  
    inc hl                          ;ld hl, finalColor
    ld (hl), BLUE                   
    inc hl                          ;ld hl, color
    ld (hl), GREEN                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $12                    
    inc hl                          ;ld hl, y
    ld (hl), 146
    inc hl                          ;ld hl, x
    ld (hl), 96
    inc hl                          ;ld hl, cc
    ld (hl), HORI                   ;HORI
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;==================================================================================
;INNER STRIPS
;==================================================================================
;===================================================
;Strip 13
;===================================================
    inc hl                          ;ld hl, strips.13.stripNum
    ld (hl), 13
    inc hl                          ;ld hl, nodeOne
    ld (hl), 2
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 5
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), LEFT                   
    inc hl                          ;ld hl, initColor
    ld (hl), BLUE                  
    inc hl                          ;ld hl, finalColor
    ld (hl), BLUE                    
    inc hl                          ;ld hl, color
    ld (hl), BLUE                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 90
    inc hl                          ;ld hl, x
    ld (hl), 61
    inc hl                          ;ld hl, cc
    ld (hl), LEFT                   
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 14
;===================================================
    inc hl                          ;ld hl, strips.14.stripNum
    ld (hl), 14
    inc hl                          ;ld hl, nodeOne
    ld (hl), 3
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 5
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), RIGHT                   
    inc hl                          ;ld hl, initColor
    ld (hl), BLUE                  
    inc hl                          ;ld hl, finalColor
    ld (hl), GREEN                    
    inc hl                          ;ld hl, color
    ld (hl), BLUE                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 90
    inc hl                          ;ld hl, x
    ld (hl), 75
    inc hl                          ;ld hl, cc
    ld (hl), RIGHT                   
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 15
;===================================================
    inc hl                          ;ld hl, strips.15.stripNum
    ld (hl), 15
    inc hl                          ;ld hl, nodeOne
    ld (hl), 4
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 8
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), LEFT                   
    inc hl                          ;ld hl, initColor
    ld (hl), BLUE                  
    inc hl                          ;ld hl, finalColor
    ld (hl), GREEN                    
    inc hl                          ;ld hl, color
    ld (hl), BLUE                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 122
    inc hl                          ;ld hl, x
    ld (hl), 45
    inc hl                          ;ld hl, cc
    ld (hl), LEFT                   
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 16
;===================================================
    inc hl                          ;ld hl, strips.16.stripNum
    ld (hl), 16
    inc hl                          ;ld hl, nodeOne
    ld (hl), 5
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 8
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), RIGHT                   
    inc hl                          ;ld hl, initColor
    ld (hl), BLUE                  
    inc hl                          ;ld hl, finalColor
    ld (hl), RED                    
    inc hl                          ;ld hl, color
    ld (hl), BLUE                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 122
    inc hl                          ;ld hl, x
    ld (hl), 59
    inc hl                          ;ld hl, cc
    ld (hl), RIGHT                   
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 17
;===================================================
    inc hl                          ;ld hl, strips.17.stripNum
    ld (hl), 17
    inc hl                          ;ld hl, nodeOne
    ld (hl), 5
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 9
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), LEFT                   
    inc hl                          ;ld hl, initColor
    ld (hl), BLUE                  
    inc hl                          ;ld hl, finalColor
    ld (hl), RED                    
    inc hl                          ;ld hl, color
    ld (hl), BLUE                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 122
    inc hl                          ;ld hl, x
    ld (hl), 77
    inc hl                          ;ld hl, cc
    ld (hl), LEFT                   
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip 18
;===================================================
    inc hl                          ;ld hl, strips.18.stripNum
    ld (hl), 18
    inc hl                          ;ld hl, nodeOne
    ld (hl), 6
    inc hl                          ;ld hl, nodeTwo
    ld (hl), 9
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), RIGHT                   
    inc hl                          ;ld hl, initColor
    ld (hl), BLUE                  
    inc hl                          ;ld hl, finalColor
    ld (hl), BLUE                    
    inc hl                          ;ld hl, color
    ld (hl), BLUE                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $31                    
    inc hl                          ;ld hl, y
    ld (hl), 122
    inc hl                          ;ld hl, x
    ld (hl), 91
    inc hl                          ;ld hl, cc
    ld (hl), RIGHT                   
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

;===================================================
;Strip BUFFER
;===================================================
    inc hl                          ;ld hl, strips.19.stripNum
    ld (hl), 19
    inc hl                          ;ld hl, nodeOne
    ld (hl), 0
    inc hl                          ;ld hl, nodeTwo
    ld (hl), $FF
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, orientation
    ld (hl), HORI                   
    inc hl                          ;ld hl, initColor
    ld (hl), BLUE                  
    inc hl                          ;ld hl, finalColor
    ld (hl), BLUE                    
    inc hl                          ;ld hl, color
    ld (hl), BLUE                  
    ld a, (hl)                      ;Store as colorOffset

    inc hl                          ;ld hl, sprNum
    inc hl                          ;ld hl, hw
    ld (hl), $00                    
    inc hl                          ;ld hl, y
    ld (hl), 0
    inc hl                          ;ld hl, x
    ld (hl), 0
    inc hl                          ;ld hl, cc
    ld (hl), RIGHT                   
    add a, (hl)
    ld (hl), a                      ;Plus colorOffset
    inc hl                          ;ld hl, sprSize

    ret


;==================================================================================
;SELECTED STRIPS
;==================================================================================
;===================================================
;Selected Strip 1
;===================================================
    ld hl, selectedStripOne
    ld (hl), 0                                  ;No strip
;===================================================
;Selected Strip 2
;===================================================
    ld hl, selectedStripTwo
    ld (hl), 0                                  ;No strip
;===================================================
;Selected Strip 1
;===================================================
    ld hl, selectedStripThree
    ld (hl), 0                                  ;No strip

;===================================================
;Nodes (One Indexed)
;===================================================
/*
.struct node
    nodeNum     db      ;The ID of the node ($00 - $0A)
    nodeRow     db      ;The row the node lies on
    selected    db      ;Selected = $FF, Unselected = $00
    nodeX       db
    nodeY       db
    nodeCC      db
.endst
*/
InitNodes:
;==================================================================================
;ZERO ROW
;==================================================================================
;===================================================
;Node 1
;===================================================
    ld hl, nodes.1.nodeNum
    ld (hl), 1
    inc hl                          ;ld hl, nodeRow
    ld (hl), 0
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 47                     ;
    inc hl                          ;ld hl, nodeX
    ld (hl), 64                     ;
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;==================================================================================
;ONE ROW
;==================================================================================
;===================================================
;Node 2
;===================================================
    inc hl                          ;ld hl, nodes.2.nodeNum
    ld (hl), 2
    inc hl                          ;ld hl, nodeRow
    ld (hl), 1
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 79                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 48                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;===================================================
;Node 3
;===================================================
    inc hl                          ;ld hl, nodes.3.nodeNum
    ld (hl), 3
    inc hl                          ;ld hl, nodeRow
    ld (hl), 1
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 79                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 80                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;==================================================================================
;TWO ROW
;==================================================================================
;===================================================
;Node 4
;===================================================
    inc hl                          ;ld hl, nodes.4.nodeNum
    ld (hl), 4
    inc hl                          ;ld hl, nodeRow
    ld (hl), 2
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 111                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 32                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;===================================================
;Node 5
;===================================================
    inc hl                          ;ld hl, nodes.5.nodeNum
    ld (hl), 5
    inc hl                          ;ld hl, nodeRow
    ld (hl), 2
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 111                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 64                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;===================================================
;Node 6
;===================================================
    inc hl                          ;ld hl, nodes.6.nodeNum
    ld (hl), 6
    inc hl                          ;ld hl, nodeRow
    ld (hl), 2
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 111                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 96                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;==================================================================================
;THREE ROW
;==================================================================================
;===================================================
;Node 7
;===================================================
    inc hl                          ;ld hl, nodes.7.nodeNum
    ld (hl), 7
    inc hl                          ;ld hl, nodeRow
    ld (hl), 3
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 143                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 16                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;===================================================
;Node 8
;===================================================
    inc hl                          ;ld hl, nodes.8.nodeNum
    ld (hl), 8
    inc hl                          ;ld hl, nodeRow
    ld (hl), 3
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 143                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 48                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;===================================================
;Node 9
;===================================================
    inc hl                          ;ld hl, nodes.9.nodeNum
    ld (hl), 9
    inc hl                          ;ld hl, nodeRow
    ld (hl), 3
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 143                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 80                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

;===================================================
;Node 10
;===================================================
    inc hl                          ;ld hl, nodes.10.nodeNum
    ld (hl), 10
    inc hl                          ;ld hl, nodeRow
    ld (hl), 3
    inc hl                          ;ld hl, selected
    ld (hl), $00                    ;UNSELECTED
    inc hl                          ;ld hl, nodeY
    ld (hl), 143                     
    inc hl                          ;ld hl, nodeX
    ld (hl), 112                      
    inc hl                          ;ld hl, nodeCC
    ld (hl), UNSELECTED

    ret