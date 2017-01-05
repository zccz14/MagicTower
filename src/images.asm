; module exports
public hBitmapHero, hBitmapTile, hIcon
public PreloadImages, PrepareDC
public hDCTile, hDCFloor, hDCWall, hDCBraver, hDCBackground, hDCNumbers
; include
include <stdafx.inc>
include <background.inc>

.const
; filepath constant string
szIcon db 'images\\icon.ico', 0
szBitmapTile db 'images\\tile.bmp', 0
szBitmapHero db 'images\\hero.bmp', 0

.data?
hBitmapHero dd ?
hBitmapTile dd ?
hIcon dd ?
hDCTile dd ?
hDCFloor dd ?
hDCWall dd ?
hDCBraver dd ?
hDCHero dd ?
hDCBackground dd ?
hDCNumbers dd 10 dup(?)

.code
PreloadImages proc
    local @hDC: HDC
    invoke LoadImage, NULL, addr szBitmapTile, IMAGE_BITMAP, 256, 1216, LR_LOADFROMFILE
    mov hBitmapTile, eax
    invoke LoadImage, NULL, addr szBitmapHero, IMAGE_BITMAP, 128, 132, LR_LOADFROMFILE
    mov hBitmapHero, eax
    invoke LoadImage, NULL, addr szIcon, IMAGE_ICON, 16, 16, LR_LOADFROMFILE
    mov hIcon, eax
    ret
PreloadImages endp

BlockToPixel proc uses ebx block
    mov ebx, BLOCK_SIZE
    mov eax, block
    mul ebx
    ret
BlockToPixel endp

PrepareDC proc hWnd
    local @hDC: HDC
    local @hBitmap: HBITMAP
    local @x
    local @y
    invoke GetDC, hWnd
    mov @hDC, eax
    ; Create DC
    invoke CreateCompatibleDC, NULL
    mov hDCTile, eax
    invoke SelectObject, hDCTile, hBitmapTile

    invoke CreateCompatibleDC, NULL
    mov hDCHero, eax
    invoke SelectObject, hDCHero, hBitmapHero
    
    invoke CreateCompatibleDC, @hDC
    mov hDCFloor, eax
    invoke CreateCompatibleBitmap, @hDC, BLOCK_SIZE, BLOCK_SIZE
    invoke SelectObject, hDCFloor, eax
    invoke BitBlt, hDCFloor, 0, 0, BLOCK_SIZE, BLOCK_SIZE, hDCTile, 0, 0, SRCCOPY
    
    invoke CreateCompatibleDC, @hDC
    mov hDCWall, eax
    invoke CreateCompatibleBitmap, @hDC, BLOCK_SIZE, BLOCK_SIZE
    invoke SelectObject, hDCWall, eax
    invoke BitBlt, hDCWall, 0, 0, BLOCK_SIZE, BLOCK_SIZE, hDCTile, 6 * BLOCK_SIZE, 0, SRCCOPY
    
    invoke CreateCompatibleDC, @hDC
    mov hDCBraver, eax
    invoke CreateCompatibleBitmap, @hDC, BLOCK_SIZE, BLOCK_SIZE
    invoke SelectObject, hDCBraver, eax
    invoke BitBlt, hDCBraver, 0, 0, BLOCK_SIZE, BLOCK_SIZE, hDCHero, 0, 0, SRCCOPY

    CreateHDC macro hpDC, x, y
        invoke CreateCompatibleDC, @hDC
        mov [hpDC], eax
        invoke CreateCompatibleBitmap, @hDC, BLOCK_SIZE, BLOCK_SIZE
        invoke SelectObject, [hpDC], eax
        invoke BitBlt, [hpDC], 0, 0, BLOCK_SIZE, BLOCK_SIZE, hDCTile, x * BLOCK_SIZE, y * BLOCK_SIZE, SRCCOPY
    endm
    lea esi, hDCNumbers
    CreateHDC esi, 1, 23
    add esi, 4
    CreateHDC esi, 2, 23
    add esi, 4
    CreateHDC esi, 3, 23
    add esi, 4
    CreateHDC esi, 4, 23
    add esi, 4
    CreateHDC esi, 5, 23
    add esi, 4
    CreateHDC esi, 1, 24
    add esi, 4
    CreateHDC esi, 2, 24
    add esi, 4
    CreateHDC esi, 3, 24
    add esi, 4
    CreateHDC esi, 4, 24
    add esi, 4
    CreateHDC esi, 5, 24
    ; CreateHDCNumbers 1, 2, 23
    ; CreateHDCNumbers 2, 3, 23
    ; CreateHDCNumbers 3, 4, 23
    ; CreateHDCNumbers 4, 5, 23
    ; CreateHDCNumbers 5, 1, 24
    ; CreateHDCNumbers 6, 2, 24
    ; CreateHDCNumbers 7, 3, 24
    ; CreateHDCNumbers 8, 4, 24
    ; CreateHDCNumbers 9, 5, 24

    ; combine background
    invoke CreateCompatibleDC, @hDC
    mov hDCBackground, eax
    invoke CreateCompatibleBitmap, @hDC, 20 * BLOCK_SIZE, 15 * BLOCK_SIZE
    invoke SelectObject, hDCBackground, eax
    invoke ProcSetBackground, hDCBackground, hDCTile
    ret
PrepareDC endp

end
