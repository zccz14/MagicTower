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
MAP_TYPE_DOOR_YELLOW equ 2
MAP_TYPE_DOOR_BLUE equ 3
MAP_TYPE_DOOR_RED equ 4
MAP_TYPE_UPSTAIR equ 5
MAP_TYPE_DOWNSTAIR equ 6
MAP_TYPE_KEY_YELLOW equ 7
MAP_TYPE_KEY_BLUE equ 8
MAP_TYPE_KEY_RED equ 9

MAP_TYPE_ITEM_STONE_RED   equ 0200H
MAP_TYPE_ITEM_STONE_BLUE  equ 0201H
MAP_TYPE_ITEM_BOTTLE_RED  equ 0202H
MAP_TYPE_ITEM_BOTTLE_BLUE equ 0203H

MAP_TYPE_ENEMY_01 equ 101H
MAP_TYPE_ENEMY_02 equ 102H
MAP_TYPE_ENEMY_03 equ 103H
MAP_TYPE_ENEMY_04 equ 104H
MAP_TYPE_ENEMY_05 equ 105H
MAP_TYPE_ENEMY_06 equ 106H
MAP_TYPE_ENEMY_07 equ 107H
MAP_TYPE_ENEMY_08 equ 108H