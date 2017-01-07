.386
.model flat, stdcall
option casemap: none

include windows.inc
include gdi32.inc
includelib gdi32.lib
include msimg32.inc
includelib msimg32.lib
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib
include masm32.inc
includelib masm32.lib
include debug.inc
includelib debug.lib
include <winmm.inc>
includelib <winmm.lib>
include <msvcrt.inc>
includelib <msvcrt.lib>

BLOCK_SIZE equ 20h
MAP_SIZE equ 0Dh

ICO_BIG equ 1000h
IDM_MAIN equ 2000h
IDM_NEWGAME equ 2001h
IDM_QUIT equ 2002h

TIMERID_IDLE_BGM equ 0000h
INTERVAL_IDLE_BGM equ 3000


Position struct
    x dword 0
    y dword 0
    z dword 1
Position ends

Braver struct
    HP dword 1000
    ATK dword 100
    DEF dword 100
    MON dword 0
    pos Position <>
    yellow dword 0
    blue word 0
    red word 0
Braver ends

Enemy struct
    name db 20 dup(?)
    HP dword ?
    ATK dword ?
    DEF dword ?
    MON dword ?
Enemy ends

mLet macro x, y
    mov eax, y
    mov x, eax
endm

FLOOR_CNT equ 11; 0 ~ 10
; Map::Type::
MAP_TYPE_PATH equ 0
MAP_TYPE_WALL equ 1

MAP_TYPE_UPSTAIR equ 5
MAP_TYPE_DOWNSTAIR equ 6

MAP_TYPE_SHOP_LEFT equ 000AH
MAP_TYPE_SHOP_CENTER equ 000BH
MAP_TYPE_SHOP_RIGHT equ 000CH

MAP_TYPE_ITEM equ 02H
MAP_TYPE_ITEM_STONE_RED   equ 0200H
MAP_TYPE_ITEM_STONE_BLUE  equ 0201H
MAP_TYPE_ITEM_BOTTLE_RED  equ 0202H
MAP_TYPE_ITEM_BOTTLE_BLUE equ 0203H
MAP_TYPE_ITEM_KEY_YELLOW  equ 0204H
MAP_TYPE_ITEM_KEY_BLUE    equ 0205H
MAP_TYPE_ITEM_KEY_RED     equ 0206H
MAP_TYPE_ITEM_SWORD_IRON  equ 0207H
MAP_TYPE_ITEM_SHIELD_IRON equ 0208H

MAP_TYPE_ENEMY equ 01H
MAP_TYPE_ENEMY_01 equ 0101H
MAP_TYPE_ENEMY_02 equ 0102H
MAP_TYPE_ENEMY_03 equ 0103H
MAP_TYPE_ENEMY_04 equ 0104H
MAP_TYPE_ENEMY_05 equ 0105H
MAP_TYPE_ENEMY_06 equ 0106H
MAP_TYPE_ENEMY_07 equ 0107H
MAP_TYPE_ENEMY_08 equ 0108H
MAP_TYPE_ENEMY_09 equ 0109H

MAP_TYPE_NPC equ 03H
MAP_TYPE_NPC_WISE equ 0300H
MAP_TYPE_NPC_MERCHANT equ 0301H
MAP_TYPE_NPC_THIEF equ 0302H

MAP_TYPE_DOOR equ 04H
MAP_TYPE_DOOR_YELLOW equ 0400H
MAP_TYPE_DOOR_BLUE   equ 0401H
MAP_TYPE_DOOR_RED    equ 0402H
MAP_TYPE_DOOR_AUTO   equ 0403H
MAP_TYPE_DOOR_IRON   equ 0404H