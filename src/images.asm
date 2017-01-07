; module exports
public hBitmapHero, hBitmapTile, hIcon
public PreloadImages, PrepareDC
public hDCTile, hDCFloor, hDCWall, hDCBraver, hDCBackground, hDCNumbers
public hDCDoorYellow, hDCDoorBlue, hDCDoorRed, hDCDoorAuto, hDCDoorIron
public hDCUpstair, hDCDownstair
public hDCNPCWise, hDCNPCMerchant, hDCNPCThief
public hDCShopLeft, hDCShopRight, hDCShopCenter
public hDCKeyYellow, hDCKeyBlue, hDCKeyRed

; public items
public hDCBottleRed, hDCBottleBlue, hDCStoneRed, hDCStoneBlue

public hDCSwordIron, hDCShieldIron

public hDCEnemy01, hDCEnemy02, hDCEnemy03, hDCEnemy04
public hDCEnemy05, hDCEnemy06, hDCEnemy07, hDCEnemy08, hDCEnemy09
; include
include <stdafx.inc>
include <background.inc>

.const
; filepath constant string
szIcon db 'images\\icon.ico', 0
szBitmapTile db 'images\\tile.bmp', 0
szBitmapHero db 'images\\hero.bmp', 0
szBitmapItem db 'images\\item.bmp', 0
szBitmapMap db 'images\\map.bmp', 0
szBitmapEnemies db 'images\\enemies.bmp', 0
szBitmapNPC db 'images\\npc.bmp', 0
szBitmapEquip db 'images\\equip.bmp', 0

.data?
hIcon dd ?
hBitmapHero dd ?
hBitmapTile dd ?
hBitmapItem dd ?
hBitmapMap dd ?
hBitmapEnemies dd ?
hBitmapNPC dd ?
hBitmapEquip dd ?

hDCMap dd ?
hDCTile dd ?
hDCEnemies dd ?
hDCItem dd ?
hDCNPC dd ?
hDCEquip dd ?

hDCFloor dd ?
hDCWall dd ?
hDCBraver dd ?
hDCHero dd ?
hDCBackground dd ?
hDCNumbers dd 10 dup(?)

hDCDoorYellow dd ?
hDCDoorBlue dd ?
hDCDoorRed dd ?
hDCDoorAuto dd ?
hDCDoorIron dd ?

hDCUpstair dd ?
hDCDownstair dd ?
hDCKeyYellow dd ?
hDCKeyBlue dd ?
hDCKeyRed dd ?
; shop
hDCShopLeft dd ?
hDCShopRight dd ?
hDCShopCenter dd ?
; npc
hDCNPCMerchant dd ?
hDCNPCWise dd ?
hDCNPCThief dd ?
; items
hDCBottleRed dd ?
hDCBottleBlue dd ?
hDCStoneRed dd ?
hDCStoneBlue dd ?
; sword and shield
hDCSwordIron dd ?
hDCSwordSliver dd ?
hDCSwordKnight dd ?
hDCSwordHoly dd ?
hDCSwordSacred dd ?

hDCShieldIron dd ?
hDCShieldSliver dd ?
hDCShieldKnight dd ?
hDCShieldHoly dd ?
hDCShieldSacred dd ?


; enemies
hDCEnemy01 dd ?
hDCEnemy02 dd ?
hDCEnemy03 dd ?
hDCEnemy04 dd ?
hDCEnemy05 dd ?
hDCEnemy06 dd ?
hDCEnemy07 dd ?
hDCEnemy08 dd ?
hDCEnemy09 dd ?

.code
PreloadImages proc
    local @hDC: HDC
    invoke LoadImage, NULL, addr szIcon, IMAGE_ICON, 16, 16, LR_LOADFROMFILE
    mov hIcon, eax
    invoke LoadImage, NULL, addr szBitmapTile, IMAGE_BITMAP, 256, 1216, LR_LOADFROMFILE
    mov hBitmapTile, eax
    invoke LoadImage, NULL, addr szBitmapHero, IMAGE_BITMAP, 128, 132, LR_LOADFROMFILE
    mov hBitmapHero, eax
    invoke LoadImage, NULL, addr szBitmapItem, IMAGE_BITMAP, 128, 32, LR_LOADFROMFILE
    mov hBitmapItem, eax
    invoke LoadImage, NULL, addr szBitmapMap, IMAGE_BITMAP, 256, 128, LR_LOADFROMFILE
    mov hBitmapMap, eax
    invoke LoadImage, NULL, addr szBitmapEnemies, IMAGE_BITMAP, 128, 640, LR_LOADFROMFILE
    mov hBitmapEnemies, eax
    invoke LoadImage, NULL, addr szBitmapNPC, IMAGE_BITMAP, 128, 128, LR_LOADFROMFILE
    mov hBitmapNPC, eax
    invoke LoadImage, NULL, addr szBitmapEquip, IMAGE_BITMAP, 128, 128, LR_LOADFROMFILE
    mov hBitmapEquip, eax
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
    mov hDCItem, eax
    invoke SelectObject, hDCItem, hBitmapItem

    invoke CreateCompatibleDC, NULL
    mov hDCMap, eax
    invoke SelectObject, hDCMap, hBitmapMap

    invoke CreateCompatibleDC, NULL
    mov hDCEnemies, eax
    invoke SelectObject, hDCEnemies, hBitmapEnemies

    invoke CreateCompatibleDC, NULL
    mov hDCNPC, eax
    invoke SelectObject, hDCNPC, hBitmapNPC

    invoke CreateCompatibleDC, NULL
    mov hDCEquip, eax
    invoke SelectObject, hDCEquip, hBitmapEquip

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

    SelectBlock hDCDoorYellow, hDCMap, 0, 1
    SelectBlock hDCDoorBlue, hDCMap, 1, 1
    SelectBlock hDCDoorRed, hDCMap, 2, 1
    SelectBlock hDCDoorAuto, hDCMap, 3, 1
    SelectBlock hDCDoorIron, hDCMap, 4, 1
    
    SelectBlock hDCDownstair, hDCMap, 3, 2
    SelectBlock hDCUpstair, hDCMap, 4, 2
    SelectBlock hDCKeyYellow, hDCMap, 5, 1
    SelectBlock hDCKeyBlue, hDCMap, 6, 1
    SelectBlock hDCKeyRed, hDCMap, 7, 1
    
    SelectBlock hDCNPCWise, hDCNPC, 0, 0
    SelectBlock hDCNPCMerchant, hDCNPC, 0, 1
    SelectBlock hDCNPCThief, hDCNPC, 0, 2

    SelectBlock hDCSwordIron, hDCEquip, 0, 0
    SelectBlock hDCShieldIron, hDCEquip, 0, 2

    SelectBlock hDCShopLeft, hDCMap, 4, 0
    SelectBlock hDCShopCenter, hDCMap, 5, 0
    SelectBlock hDCShopRight, hDCMap, 6, 0

    SelectBlock hDCStoneRed, hDCItem, 0, 0
    SelectBlock hDCStoneBlue, hDCItem, 1, 0
    SelectBlock hDCBottleRed, hDCItem, 2, 0
    SelectBlock hDCBottleBlue, hDCItem, 3, 0

    SelectBlock hDCEnemy01, hDCEnemies, 0, 0
    SelectBlock hDCEnemy02, hDCEnemies, 0, 1
    SelectBlock hDCEnemy03, hDCEnemies, 0, 4
    SelectBlock hDCEnemy04, hDCEnemies, 0, 8
    SelectBlock hDCEnemy05, hDCEnemies, 0, 12
    SelectBlock hDCEnemy06, hDCEnemies, 0, 13
    SelectBlock hDCEnemy07, hDCEnemies, 0, 16
    SelectBlock hDCEnemy08, hDCEnemies, 0, 14
    SelectBlock hDCEnemy09, hDCEnemies, 0, 17

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
