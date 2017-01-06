public GetMap, GetMapDC
include <stdafx.inc>
include <images.inc>

.const
constMap dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
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
.data
hDCCached dd 0
CachedIndex dd 0FFFFFFFFH

.code
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
    add eax, offset constMap
    ret
GetOffsetByIndex endp

GetMap proc pMap, index
    mov ecx, 13 * 13
    assume esi: ptr dword
    assume edi: ptr dword
    invoke GetOffsetByIndex, index
    mov esi, eax
    mov edi, pMap
    .while ecx
        mLet [edi], [esi]
        dec ecx
    .endw
    ret
GetMap endp

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

end