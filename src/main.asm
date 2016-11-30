.386
.model flat, stdcall
option casemap: none

include windows.inc
include gdi32.inc
includelib gdi32.lib
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib
include masm32.inc
includelib masm32.lib
include debug.inc
includelib debug.lib

ICO_BIG equ 1000h
IDM_MAIN equ 2000h
IDB_TEST equ 3000h
IDB_BG equ 3001h

.data?
hInstance dd  ?
hWinMain dd  ?
.const
szClassName db 'MainWindow', 0
szCaptionMain db '魔塔', 0
szText  db '苟利国家生死以 岂因祸福避趋之', 0
szButton db 'button',0
szButtonText db 'Button',0
.code

_ProcWinMain proc uses ebx edi esi hWnd, uMsg, wParam, lParam
  local @stPs: PAINTSTRUCT
  local @stRect: RECT
  local @hDc
  local @hBMP
  local @hBMPDc
  mov eax, uMsg
  ; PrintHex eax
  .if eax == WM_PAINT
    invoke BeginPaint, hWnd, addr @stPs
    mov @hDc, eax

    invoke LoadBitmap, hInstance, IDB_BG
    mov @hBMP, eax
    invoke CreateCompatibleDC, @hDc
    mov @hBMPDc, eax
    invoke SelectObject, @hBMPDc, @hBMP
    PrintHex eax
    invoke BitBlt, @hDc, 0, 0, 580, 435, @hBMPDc, 0, 0, SRCCOPY
    invoke DeleteDC, @hBMPDc

    invoke LoadBitmap, hInstance, IDB_TEST
    mov @hBMP, eax

    invoke CreateCompatibleDC, @hDc
    mov @hBMPDc, eax
    invoke SelectObject, @hBMPDc, @hBMP
    
    invoke BitBlt, @hDc, 0, 0, 64, 64, @hBMPDc, 0, 0, SRCCOPY
    invoke BitBlt, @hDc, 75, 150, 64, 64, @hBMPDc, 0, 0, SRCCOPY
    invoke BitBlt, @hDc, 64, 64, 64, 64, @hBMPDc, 0, 0, SRCCOPY
    invoke DeleteDC, @hBMPDc
    ;invoke GetClientRect, hWnd, addr @stRect
    ;invoke DrawText, @hDc, addr szText, -1, addr @stRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
    invoke EndPaint, hWnd, addr @stPs
  .elseif eax == WM_CREATE
    ; create a button
    invoke CreateWindowEx, NULL, offset szButton, offset szButtonText, WS_CHILD or WS_VISIBLE, 10, 10, 80, 22, hWnd, 1, hInstance, NULL
  .elseif eax == WM_CLOSE
    invoke DestroyWindow, hWinMain
    invoke PostQuitMessage, NULL
  .else
    ; default process
    invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    ret
  .endif
  xor eax, eax
  ret
_ProcWinMain endp

_WinMain proc
  local @stWndClass: WNDCLASSEX
  local @stMsg: MSG
  local @hMenu: HMENU
  local @hIcon: HICON
  invoke GetModuleHandle, NULL
  mov hInstance, eax
  mov @stWndClass.hInstance, eax ; 指定要注册的窗口类属于哪个模块
  invoke RtlZeroMemory, addr @stWndClass, sizeof @stWndClass 
  
  invoke LoadIcon, hInstance, ICO_BIG
  mov @stWndClass.hIcon, eax
  mov @stWndClass.hIconSm, eax

  invoke LoadCursor, 0, IDC_ARROW
  mov @stWndClass.hCursor, eax ; 用LoadCursor为光标句柄赋值
  
  mov @stWndClass.cbSize, sizeof WNDCLASSEX
  mov @stWndClass.style, CS_HREDRAW or CS_VREDRAW
  mov @stWndClass.lpfnWndProc, offset _ProcWinMain
  mov @stWndClass.hbrBackground, COLOR_WINDOW + 1
  mov @stWndClass.lpszClassName, offset szClassName

  invoke LoadMenu, hInstance, IDM_MAIN
  mov @hMenu, eax
  PrintHex eax
  invoke LoadBitmap, hInstance, IDB_TEST
  PrintHex eax
  invoke LoadBitmap, hInstance, IDB_BG
  PrintHex eax

  invoke RegisterClassEx, addr @stWndClass
  ; create a window
  invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szClassName, addr szCaptionMain, WS_OVERLAPPEDWINDOW, 100, 100, 600, 400, NULL, @hMenu, hInstance, NULL
  mov hWinMain, eax ; mark hWinMain as the main window
  invoke UpdateWindow, hWinMain ; send WM_PRINT to hWinMain
  invoke LoadIcon, hInstance, ICO_BIG
  invoke SendMessage, hWinMain, WM_SETICON, ICON_BIG, eax
  invoke ShowWindow, hWinMain, SW_SHOWNORMAL ; show window in a normal way

  .while TRUE
    PrintLine
    invoke GetMessage, addr @stMsg, NULL, 0, 0
    .break .if eax == 0 ; WM_QUIT => eax == 0
    invoke TranslateMessage, addr @stMsg
    invoke DispatchMessage, addr @stMsg
  .endw
  ret
_WinMain endp


__main proc
  PrintLine
  invoke _WinMain
  invoke ExitProcess, 0
__main endp
end __main