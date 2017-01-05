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
Braver ends

mLet macro x, y
    mov eax, y
    mov x, eax
endm