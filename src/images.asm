; module exports
public hBitmapHero, hBitmapTile, hIcon
public PreloadImages, PrepareDC
public hDCTile, hDCFloor, hDCWall, hDCBraver
; include
include <stdafx.inc>

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
    
    invoke CreateCompatibleDC, NULL
    mov hDCFloor, eax
    invoke BitBlt, hDCFloor, 0, 0, BLOCK_SIZE, BLOCK_SIZE, hDCTile, 0, 0, SRCCOPY
    
    invoke CreateCompatibleDC, NULL
    mov hDCWall, eax
    invoke BitBlt, hDCWall, 0, 0, BLOCK_SIZE, BLOCK_SIZE, hDCTile, 6 * BLOCK_SIZE, 0, SRCCOPY
    
    invoke CreateCompatibleDC, @hDC
    mov hDCBraver, eax
    invoke CreateCompatibleBitmap, @hDC, BLOCK_SIZE, BLOCK_SIZE
    invoke SelectObject, hDCBraver, eax
    invoke BitBlt, hDCBraver, 0, 0, BLOCK_SIZE, BLOCK_SIZE, hDCHero, 0, 0, SRCCOPY
    ; invoke TransparentBlt, hDCBraver, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, hDCHero, 0, 0, BLOCK_SIZE, BLOCK_SIZE, 0FFFFFFh
    
    ret
PrepareDC endp

end
