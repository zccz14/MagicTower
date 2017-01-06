; module exports
public hBitmapHero, hBitmapTile, hIcon
public PreloadImages, PrepareDC
public hDCTile, hDCFloor, hDCWall, hDCBraver, hDCBackground, hDCNumbers
public hDCYellowDoor, hDCBlueDoor, hDCRedDoor
public hDCUpstair, hDCDownstair
public hDCKeyYellow, hDCKeyBlue, hDCKeyRed

public hDCEnemy01, hDCEnemy02, hDCEnemy03, hDCEnemy04
public hDCEnemy05, hDCEnemy06, hDCEnemy07, hDCEnemy08
; include
include <stdafx.inc>
include <background.inc>

.const
; filepath constant string
szIcon db 'images\\icon.ico', 0
szBitmapTile db 'images\\tile.bmp', 0
szBitmapHero db 'images\\hero.bmp', 0
szBitmapItem01 db 'images\\item01.bmp', 0
szBitmapMap db 'images\\map.bmp', 0
szBitmapEnemies db 'images\\enemies.bmp', 0

.data?
hIcon dd ?
hBitmapHero dd ?
hBitmapTile dd ?
hBitmapItem01 dd ?
hBitmapMap dd ?
hBitmapEnemies dd ?

hDCMap dd ?
hDCTile dd ?
hDCEnemies dd ?

hDCFloor dd ?
hDCWall dd ?
hDCBraver dd ?
hDCHero dd ?
hDCBackground dd ?
hDCNumbers dd 10 dup(?)
hDCYellowDoor dd ?
hDCBlueDoor dd ?
hDCRedDoor dd ?
hDCUpstair dd ?
hDCDownstair dd ?
hDCKeyYellow dd ?
hDCKeyBlue dd ?
hDCKeyRed dd ?

; enemies
hDCEnemy01 dd ?
hDCEnemy02 dd ?
hDCEnemy03 dd ?
hDCEnemy04 dd ?
hDCEnemy05 dd ?
hDCEnemy06 dd ?
hDCEnemy07 dd ?
hDCEnemy08 dd ?

.code
PreloadImages proc
    local @hDC: HDC
    invoke LoadImage, NULL, addr szIcon, IMAGE_ICON, 16, 16, LR_LOADFROMFILE
    mov hIcon, eax
    invoke LoadImage, NULL, addr szBitmapTile, IMAGE_BITMAP, 256, 1216, LR_LOADFROMFILE
    mov hBitmapTile, eax
    invoke LoadImage, NULL, addr szBitmapHero, IMAGE_BITMAP, 128, 132, LR_LOADFROMFILE
    mov hBitmapHero, eax
    invoke LoadImage, NULL, addr szBitmapItem01, IMAGE_BITMAP, 128, 128, LR_LOADFROMFILE
    mov hBitmapItem01, eax
    invoke LoadImage, NULL, addr szBitmapMap, IMAGE_BITMAP, 256, 128, LR_LOADFROMFILE
    mov hBitmapMap, eax
    invoke LoadImage, NULL, addr szBitmapEnemies, IMAGE_BITMAP, 128, 512, LR_LOADFROMFILE
    mov hBitmapEnemies, eax
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

    invoke CreateCompatibleDC, NULL
    mov hDCMap, eax
    invoke SelectObject, hDCMap, hBitmapMap

    invoke CreateCompatibleDC, NULL
    mov hDCEnemies, eax
    invoke SelectObject, hDCEnemies, hBitmapEnemies

    ; Create Block size DC and Select from Other DC
    SelectBlock macro hDCChild, hDCParent, x, y
        invoke CreateCompatibleDC, @hDC
        mov hDCChild, eax
        invoke CreateCompatibleBitmap, @hDC, BLOCK_SIZE, BLOCK_SIZE
        invoke SelectObject, hDCChild, eax
        invoke BitBlt, hDCChild, 0, 0, BLOCK_SIZE, BLOCK_SIZE, hDCParent, x * BLOCK_SIZE, y * BLOCK_SIZE, SRCCOPY
    endm
    SelectBlock hDCBraver, hDCHero, 0, 0

    lea esi, hDCNumbers
    SelectBlock [esi], hDCTile, 1, 23
    add esi, 4
    SelectBlock [esi], hDCTile, 2, 23
    add esi, 4
    SelectBlock [esi], hDCTile, 3, 23
    add esi, 4
    SelectBlock [esi], hDCTile, 4, 23
    add esi, 4
    SelectBlock [esi], hDCTile, 5, 23
    add esi, 4
    SelectBlock [esi], hDCTile, 1, 24
    add esi, 4
    SelectBlock [esi], hDCTile, 2, 24
    add esi, 4
    SelectBlock [esi], hDCTile, 3, 24
    add esi, 4
    SelectBlock [esi], hDCTile, 4, 24
    add esi, 4
    SelectBlock [esi], hDCTile, 5, 24

    SelectBlock hDCFloor, hDCMap, 0, 0
    SelectBlock hDCWall, hDCMap, 1, 0
    SelectBlock hDCYellowDoor, hDCMap, 0, 1
    SelectBlock hDCBlueDoor, hDCMap, 1, 1
    SelectBlock hDCRedDoor, hDCMap, 2, 1
    SelectBlock hDCDownstair, hDCMap, 3, 2
    SelectBlock hDCUpstair, hDCMap, 4, 2
    SelectBlock hDCKeyYellow, hDCMap, 5, 1
    SelectBlock hDCKeyBlue, hDCMap, 6, 1
    SelectBlock hDCKeyRed, hDCMap, 7, 1

    SelectBlock hDCEnemy01, hDCEnemies, 0, 0
    SelectBlock hDCEnemy02, hDCEnemies, 0, 1
    SelectBlock hDCEnemy03, hDCEnemies, 0, 4
    SelectBlock hDCEnemy04, hDCEnemies, 0, 8
    SelectBlock hDCEnemy05, hDCEnemies, 0, 12
    SelectBlock hDCEnemy06, hDCEnemies, 0, 13

    invoke DeleteObject, hDCMap

    ; combine background
    invoke CreateCompatibleDC, @hDC
    mov hDCBackground, eax
    invoke CreateCompatibleBitmap, @hDC, 20 * BLOCK_SIZE, 15 * BLOCK_SIZE
    invoke SelectObject, hDCBackground, eax
    invoke ProcSetBackground, hDCBackground, hDCTile
    ret
PrepareDC endp

end
