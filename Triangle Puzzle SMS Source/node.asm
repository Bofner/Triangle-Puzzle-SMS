;==============================================================
; Node structure
;==============================================================
/*
.struct node
    nodeNum     db      ;The ID of the node ($00 - $0A)
    nodeRow     db      ;The row the node lies on
    selected    db      ;Selected = $FF, Unselected = $00
    nodeY       db
    nodeX       db
    nodeCC      db
.endst
*/

;==============================================================
; Node Specific Functions 
;==============================================================
;HL Points to Node that player current has selected
;Parameters: A = currentNode.nodeNum
;Affects: A, HL, BC
;Returns: HL points to currentNode.nodeNum
PointToCurrentNode:
    ;First we have to point to the correct node
        ;ld a, currentNode.nodeNum
        ld bc, nodePointer              ;HL points to node.1.pointer
        sub 1                           ;Nodes aren't zero indexed, so they have a +1 offset
        ld d, 0
        ld e, nodeSize
        push bc
            call Mult8Bit                   ;Multiplies AxDE
        pop bc
        add hl, bc                      ;HL points to currentNode.nodeNum

    ret


;Parameters: A = currentNode.nodeNum
;Returns: A = (node.selected)
CheckNodeSelectedStatus:
    call PointToCurrentNode            ;HL Points to node.nodeNum
    inc hl                             ;ld hl, currentNode.nodeRow
    inc hl                             ;ld hl, currentNode.selected
    ld a, (hl)

    ret


;==================================================
; Node Selection work
;==================================================
UnselectNode:
;Set Node to be Unselected
    ;ld hl, currentNode.selected
    ld (hl), $00
;Update Global for total number of nodes selected
    ld de, numSelectedNodes
    ld a, (de)
    dec a
    ld (de), a
;Update Node's color
    ld hl, $0000
    ld bc, (player.currentNode)
    ld b, 0                                             ;Only need 8-bits
    call UpdateUnselectedNodeColor

    ret


SelectNode:
;Check to see if we have 3 nodes selected already
    ld a, (numSelectedNodes)
    ld c, 3
    cp c
    jr z, +
;Set Node to be Selected
    ;ld hl, currentNode.selected
    ld (hl), $FF
;Update Global for total number of nodes selected
    ld de, numSelectedNodes
    ld a, (de)
    inc a
    ld (de), a
;Update Node's color
    ld hl, $0000
    ld bc, (player.currentNode)
    ld b, 0                                             ;Only need 8-bits
    call UpdateSelectedNodeColor
    
+:
    ret


;==================================================
; Update Node Visuals
;==================================================
;Parameters: HL = $0000, BC = currentNode.nodeNum
;We've got a whole address dedicated to node addresses. We can increment through this list
;by doing: VRAMReadyNodeADDRESSES + (2*(nodeNum - 1))
UpdateSelectedNodeColor:
    push hl                                             ;Save HL and BC
    push bc
;Update Node's top color
        call GetNodeVRAMLocation                            ;HL Points to VRAM location of top half of currentNode
;Change the BG tiles
        call SetVDPAddress
        ld hl, SelectedTop
        ld bc, $04
        call CopyToVDP
    pop bc
    pop hl                                              ;Recall HL and BC

;Update Node's bottom color
    call GetNodeVRAMLocation                            ;HL Points to VRAM location of top half of currentNode
;Now point us to the bottom half of the node
    ld bc, nodeBottom
    ld b, 0                                             ;Only need 8-bits
    add hl, bc                                          ;(VRAMReadyNodeADDRESSES + (2*(nodeNum - 1)) + nodeBottom offset)
;The following essentially does ld hl, (hl)
;Change the BG tiles
    call SetVDPAddress
    ld hl, SelectedBottom
    ld bc, $04
    call CopyToVDP

;All Joypad 1 inputs have been checked
    jp UpdateStripSelectedness


;Parameters: HL = $0000, BC = currentNode.nodeNum
UpdateUnselectedNodeColor:
    push hl                                             ;Save HL and BC
    push bc
;Update Node's top color
        call GetNodeVRAMLocation                            ;HL Points to VRAM location of top half of currentNode
;Change BG Tiles
        call SetVDPAddress
        ld hl, UnselectedTop
        ld bc, $04
        call CopyToVDP
    pop bc
    pop hl                                              ;Recall HL and BC

;Update Node's bottom color
    call GetNodeVRAMLocation                            ;HL Points to VRAM location of top half of currentNode
;Now point us to the bottom half of the node
    ld bc, nodeBottom
    ld b, 0                                             ;Only need 8-bits
    add hl, bc                                          ;(VRAMReadyNodeADDRESSES + (2*(nodeNum - 1)) + nodeBottom offset)
;Change BG Tiles    
    call SetVDPAddress
    ld hl, UnselectedBottom
    ld bc, $04
    call CopyToVDP

;All Joypad 1 inputs have been checked
    jp UpdateStripSelectedness


;Parameters: BC = currentNode.nodeNum, HL = $0000
GetNodeVRAMLocation:
;Update Node's top color
    dec bc                                              ;nodeNum - 1
    add hl, bc
    add hl, hl                                          ;2*(nodeNum - 1)
    ld b, h
    ld c, l                                             ;BC contains 2*(nodeNum - 1)
    ld hl, VRAMReadyNodeAddressess                      ;HL has the VRAM address of Node 1
    add hl, bc                                          ;(VRAMReadyNodeADDRESSES + (2*(nodeNum - 1)))
;The following essentially does ld hl, (hl)
    ld d, (hl)
    inc hl
    ld e, (hl)
    ld h, e                                             ;Little Endian
    ld l, d                                             ;HL points to VRAM location of correct node

    ret
