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

BLOCK_SIZE equ 20h
MAP_SIZE equ 0Dh

ICO_BIG equ 1000h
IDM_MAIN equ 2000h
IDM_NEWGAME equ 2001h
IDM_QUIT equ 2002h

Position struct
    x dd ?
    y dd ?
    z dd ?
Position ends

Braver struct
    HP dd 1000
    ATK dd 100
    DEF dd 100
    MON dd 0
    pos Position <>
    POSY dd 0
Braver ends