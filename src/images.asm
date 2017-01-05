; module exports
public hBitmapHero, hBitmapTile, hIcon
public PreloadImages, PrepareDC
public hDCTile, hDCFloor, hDCWall, hDCBraver, hDCBackground
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

PrepareDC proc hWnd
    local @hDC: HDC
    local @hBitmap: HBITMAP
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

    ; combine background
    invoke CreateCompatibleDC, @hDC
    mov hDCBackground, eax
    invoke CreateCompatibleBitmap, @hDC, 20 * BLOCK_SIZE, 15 * BLOCK_SIZE
    invoke SelectObject, hDCBackground, eax
    invoke ProcSetBackground, hDCBackground, hDCTile
    ret
PrepareDC endp

end
