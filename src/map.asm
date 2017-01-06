public GetMapDC, GetBlock, SetBlock
public MapInit
include <stdafx.inc>
include <images.inc>

FLOOR_CNT equ 2
CACHE_INVALID equ 0FFFFFFFFH
.const
Floor0   dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
         dd 1, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
         dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1
         dd 1, 0, 0, 0, 2, 0, 1, 0, 0, 0, 1, 0, 1
         dd 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1
         dd 1, 1, 2, 1, 1, 0, 1, 1, 1, 2, 1, 0, 1
         dd 1, 0, 0, 0, 1, 0, 2, 0, 0, 0, 1, 0, 1
         dd 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1
         dd 1, 1, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1
         dd 1, 0, 0, 0, 1, 1, 2, 1, 1, 1, 2, 1, 1
         dd 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1
         dd 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1
         dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
Floor1   dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
         dd 1, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
         dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1
         dd 1, 0, 0, 0, 2, 0, 1, 0, 0, 0, 1, 0, 1
         dd 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1
         dd 1, 1, 2, 1, 1, 0, 1, 1, 1, 2, 1, 0, 1
         dd 1, 0, 0, 0, 1, 0, 2, 0, 0, 0, 1, 0, 1
         dd 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1
         dd 1, 1, 2, 1, 1, 0, 0, 0, 0, 3, 4, 0, 1
         dd 1, 0, 0, 0, 1, 1, 2, 1, 1, 1, 2, 1, 1
         dd 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1
         dd 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1
         dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

.data?
State dd FLOOR_CNT * 13 * 13 dup(?)

.data
hDCCached dd 0
CachedIndex dd CACHE_INVALID

.code
; public void Map::Init();
; Copy Map from the const
MapInit proc uses eax ecx esi edi
    mov ecx, FLOOR_CNT * 13 * 13
    mov esi, offset Floor0
    mov edi, offset State
    DumpMem offset State, 16
    .while ecx
        mov eax, [esi]
        mov [edi], eax
        add esi, 4
        add edi, 4
        dec ecx
    .endw
    DumpMem offset State, 16
    ret
MapInit endp

MapToHDC proc lCode
    mov eax, lCode
    .if eax == 0
        mov eax, hDCFloor
    .elseif eax == 1
        mov eax, hDCWall
    .elseif eax == 2
        mov eax, hDCYellowDoor
    .elseif eax == 3
        mov eax, hDCBlueDoor
    .elseif eax == 4
        mov eax, hDCRedDoor
    .elseif eax == 5
        mov eax, hDCUpstair
    .elseif eax == 6
        mov eax, hDCDownstair
    .endif
    ret
MapToHDC endp

GetOffsetByIndex proc uses ebx index
    mov ebx, 13 * 13 * 4
    mov eax, index
    mul ebx
    add eax, offset State
    ret
GetOffsetByIndex endp

GetMapDC proc hWnd, index
    local @hDC: HDC
    local @hDCRet: HDC
    mov eax, index
    .if eax == CachedIndex
        ; Cache Hit
        mov eax, hDCCached
        ret
    .endif
    ; Cache Miss
    PrintHex 0DEADBEAFH, 'Cache Miss'
    invoke DeleteObject, hDCCached

    invoke GetDC, hWnd
    mov @hDC, eax

    invoke CreateCompatibleDC, @hDC
    mov @hDCRet, eax
    invoke CreateCompatibleBitmap, @hDC, 13 * BLOCK_SIZE, 13 * BLOCK_SIZE
    invoke SelectObject, @hDCRet, eax

    invoke GetOffsetByIndex, index
    mov esi, eax
    mov edx, 0
    mov ch, 13
    .while ch
        mov ebx, 0
        mov cl, 13
        .while cl
            invoke MapToHDC, [esi]
            push ebx
            push edx
            push ecx
            invoke BitBlt, @hDCRet, ebx, edx, BLOCK_SIZE, BLOCK_SIZE, eax, 0, 0, SRCCOPY
            pop ecx
            pop edx
            pop ebx
            add ebx, BLOCK_SIZE
            add esi, 4
            dec cl
        .endw
        add edx, BLOCK_SIZE
        dec ch
    .endw
    mLet CachedIndex, index
    mLet hDCCached, @hDCRet
    ret
GetMapDC endp    

GetBlock proc uses ebx esi index, x, y
    invoke GetOffsetByIndex, index
    mov esi, eax
    mov eax, y
    mov ebx, 13
    mul ebx
    add eax, x
    shl eax, 2
    add esi, eax
    mov eax, [esi]
    ret
GetBlock endp

; void SetBlock(uint x, uint y, uint z, uint val);
SetBlock proc uses eax ebx esi x, y, z, val
    mov CachedIndex, CACHE_INVALID
    invoke GetOffsetByIndex, z
    mov esi, eax
    mov eax, y
    mov ebx, 13
    mul ebx
    add eax, x
    shl eax, 2
    add esi, eax
    mov eax, val
    mov [esi], eax
    ret
SetBlock endp

end