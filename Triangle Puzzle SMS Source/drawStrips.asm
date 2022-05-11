DrawStrips:   
;===================================================
;Outer Strips
;===================================================
    ld de, strips.1.sprNum
    call MultiUpdateSATBuff

    ld de, strips.2.sprNum
    call MultiUpdateSATBuff

    ld de, strips.3.sprNum
    call MultiUpdateSATBuff

    ld de, strips.4.sprNum
    call MultiUpdateSATBuff

    ld de, strips.5.sprNum
    call MultiUpdateSATBuff

    ld de, strips.6.sprNum
    call MultiUpdateSATBuff

;===================================================
;Horizontal Strips
;===================================================

    ld de, strips.7.sprNum
    call MultiUpdateSATBuff

    ld de, strips.8.sprNum
    call MultiUpdateSATBuff

    ld de, strips.9.sprNum
    call MultiUpdateSATBuff

    ld de, strips.10.sprNum
    call MultiUpdateSATBuff

    ld de, strips.11.sprNum
    call MultiUpdateSATBuff

    ld de, strips.12.sprNum
    call MultiUpdateSATBuff

;===================================================
;Inner Strips
;===================================================
    ld de, strips.13.sprNum
    call MultiUpdateSATBuff

    ld de, strips.14.sprNum
    call MultiUpdateSATBuff

    ld de, strips.15.sprNum
    call MultiUpdateSATBuff

    ld de, strips.16.sprNum
    call MultiUpdateSATBuff

    ld de, strips.17.sprNum
    call MultiUpdateSATBuff

    ld de, strips.18.sprNum
    call MultiUpdateSATBuff

    ret