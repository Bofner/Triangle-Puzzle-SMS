;==============================================================
; Player Selector Structure
;==============================================================
/*
.struct selector
    currentNode db      ;ID of the node being hovered over ($00 - $0A, $FF is in Menu)
    nodeOne     db      ;ID of the first selected node ($00 - $0A, $FF is NULL)
    nodeTwo     db      ;ID of the second selected node ($00 - $0A, $FF is NULL)
    nodeThree   db      ;ID of the third selected node ($00 - $0A, $FF is NULL)

    sprNum      db
    hw          db
    y           db
    x           db 
    cc          db
    sprSize     db
.endst
*/

;Positions the Player Selector based on what node is currently selected
;Parameters: A = Current Node, HL = player.y
;Affects: A, HL, BC, DE
SetSelectPosition:
    push hl                     ;Save HL, we'll need it momentarily
        call PointToCurrentNode
        inc hl                          ;ld hl, currentNode.row
        inc hl                          ;ld hl, currentNode.selected
        inc hl                          ;ld hl, currentNode.y

    ;Now we need to load up our selector with the proper Y, X positions
        ld d, h                         ;ld de, currentNode.nodeY
        ld e, l                         ;
    pop hl                      ;ld hl, player.y
        ld a, (de)
        ld (hl), a              ;player.y = currentNode.y
        inc hl                  ;ld hl, player.x
        inc de                  ;ld de, currentNode.x
        ld a, (de)      
        ld (hl), a              ;player.x = currentNode.x

    ret

