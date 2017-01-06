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
includelib winmm.lib
include <msvcrt.inc>
includelib msvcrt.lib

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

mLet macro x, y
    mov eax, y
    mov x, eax
endm

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