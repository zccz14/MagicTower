; The Braver Module
include <stdafx.inc>
public I
public BraverInit
.data
I Braver <1000, 10, 10, 0, <6, 11, 1>, 5, 1, 1>
.code
BraverInit proc
    mov I.HP, 1000
    mov I.ATK, 10
    mov I.DEF, 10
    mov I.MON, 0
    mov I.pos.x, 6
    mov I.pos.y, 11
    mov I.pos.z, 1
    mov I.yellow, 0
    mov I.blue, 0
    mov I.red, 0
    ret
BraverInit endp
end