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
         dd 1, 0, 0, 0, 2, 0, 1, 0, 7, 0, 1, 0, 1
         dd 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1
         dd 1, 1, 2, 1, 1, 0, 1, 1, 1, 2, 1, 0, 1
         dd 1, 7, 0, 0, 1, 0, 2, 0, 0, 0, 1, 0, 1
         dd 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1
         dd 1, 1, 2, 1, 1, 0, 0, 8, 9, 3, 4, 0, 1
         dd 1, 0, 0, 0, 1, 1, 2, 1, 1, 1, 2, 1, 1
         dd 1, 0, 0, 7, 1, 7, 0, 0, 1, 0, 0, 0, 1
         dd 1, 0, 0, 7, 1, 0, 0, 0, 1, 0, 0, 0, 1
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
    PrintText 'Map Initialization'
    mov ecx, FLOOR_CNT * 13 * 13
    mov esi, offset Floor0
    mov edi, offset State
    .while ecx
        mov eax, [esi]
        mov [edi], eax
        add esi, 4
        add edi, 4
        dec ecx
    .endw
    ret
MapInit endp

MapToHDC proc lCode
    mov eax, lCode
    .if eax == MAP_TYPE_PATH
        mov eax, hDCFloor
    .elseif eax == MAP_TYPE_WALL
        mov eax, hDCWall
    .elseif eax == MAP_TYPE_DOOR_YELLOW
        mov eax, hDCYellowDoor
    .elseif eax == MAP_TYPE_DOOR_BLUE
        mov eax, hDCBlueDoor
    .elseif eax == MAP_TYPE_DOOR_RED
        mov eax, hDCRedDoor
    .elseif eax == MAP_TYPE_UPSTAIR
        mov eax, hDCUpstair
    .elseif eax == MAP_TYPE_DOWNSTAIR
        mov eax, hDCDownstair
    .elseif eax == MAP_TYPE_KEY_YELLOW
        mov eax, hDCKeyYellow
    .elseif eax == MAP_TYPE_KEY_BLUE
        mov eax, hDCKeyBlue
    .elseif eax == MAP_TYPE_KEY_RED
        mov eax, hDCKeyRed
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