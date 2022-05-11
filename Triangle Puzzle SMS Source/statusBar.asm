;==============================================================
; Status Bar
;==============================================================
;NOTE This struct will be used with an interrupt, and will utilize 8x16 sprites!
/*
.struct statusBarStruct
    score       db
    moves       db
    triPoints   db              ;Points to add on to the score for complete triangles
*/

UpdateMovesGraphic:

    ret