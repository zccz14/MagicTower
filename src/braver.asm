; The Braver Module
include <stdafx.inc>
public I
public BraverInit
.data
I Braver <>
.code
BraverInit proc
    mov I.HP, 1000
    mov I.ATK, 100
    mov I.DEF, 100
    mov I.MON, 0
    mov I.pos.x, 6
    mov I.pos.y, 11
    mov I.pos.z, 1
    mov I.yellow, 0
    mov I.blue, 0
    mov I.red, 1
    ret
BraverInit endp
end