include <stdafx.inc>
include <images.inc>
include <background.inc>
include <braver.inc>
include <timer.inc>
include <audio.inc>

.data
.data?
hInstance dd  ?
hWinMain dd  ?
hMenu dd ?
.const

szClassName db 'MainWindow', 0
szMenuNewGame db '新游戏(&N)', 0
szMenuQuit db '退出(&Q)', 0
szCaptionMain db '魔塔', 0
szHeroHealth db '生命', 0
szHeroAttack db '攻击力', 0
.code

GetBlockRect proc x, y, pstRect
  mov ebx, BLOCK_SIZE
  assume esi: ptr RECT
  mov esi, pstRect
  mov eax, x
  add eax, 6
  mul ebx
  mov [esi].left, eax; left = (x + 6) * BLOCK_SIZE
  add eax, BLOCK_SIZE
  mov [esi].right, eax; right = left + BLOCK_SIZE
  mov eax, y
  add eax, 1
  mul ebx
  mov [esi].top, eax; top = (y + 1) * BLOCK_SIZE
  add eax, BLOCK_SIZE
  mov [esi].bottom, eax; bottom = top + BLOCK_SIZE
  ret
GetBlockRect endp

ProcKeydown proc hWnd, uMsg, wParam, lParam
  local @stRect: RECT
;  local @lNewX
;  local @lNewY
  invoke GetBlockRect, I.pos.x, I.pos.y, addr @stRect
  invoke InvalidateRect, hWnd, addr @stRect, TRUE
;  mov @lNewX, I.pos.x
;  mov @lNewY, I.pos.y
  .if wParam == VK_UP
;    dec @lNewX
    .if I.pos.y > 0
      dec I.pos.y
    .endif
;    invoke UpdateWindow, hWinMain
  .elseif wParam == VK_DOWN
    .if I.pos.y < MAP_SIZE - 1
      inc I.pos.y
    .endif
;    invoke UpdateWindow, hWinMain
  .elseif wParam == VK_LEFT
    .if I.pos.x > 0
      dec I.pos.x
    .endif
;    invoke UpdateWindow, hWinMain
  .elseif wParam == VK_RIGHT
    .if I.pos.x < MAP_SIZE - 1
      inc I.pos.x
    .endif
;    invoke UpdateWindow, hWinMain
  .else
    ret
  .endif
  invoke PlayOnWalk
  invoke GetBlockRect, I.pos.x, I.pos.y, addr @stRect
  invoke InvalidateRect, hWnd, addr @stRect, TRUE
  invoke UpdateWindow, hWnd
  ret
ProcKeydown endp

_ProcWinMain proc uses ebx edi esi hWnd, uMsg, wParam, lParam
  local @stPs: PAINTSTRUCT
  local @stRect: RECT
  local @hDc
  local @hBMP
  local @hHeroDc
  local @hTileDc
  local @hBackDc
  local @hBitmapBack
  mov eax, uMsg
  ; PrintHex eax
  .if eax == WM_PAINT
    invoke BeginPaint, hWnd, addr @stPs
    mov @hDc, eax
    
    invoke CreateCompatibleDC, @hDc
    mov @hTileDc, eax ; tile DC
    invoke SelectObject, @hTileDc, hBitmapTile
    invoke CreateCompatibleDC, @hDc
    mov @hBackDc, eax ; background DC
    invoke CreateCompatibleBitmap, @hDc, 20 * BLOCK_SIZE, 15 * BLOCK_SIZE
    mov @hBitmapBack, eax ; background Bitmap
    invoke SelectObject, @hBackDc, @hBitmapBack
    invoke ProcSetBackground, @hBackDc, @hTileDc

    invoke BitBlt, @hDc, 0, 0, 20 * BLOCK_SIZE, 15 * BLOCK_SIZE, @hBackDc, 0, 0, SRCCOPY
    invoke DeleteObject, @hBitmapBack
    invoke DeleteDC, @hBackDc
    invoke DeleteDC, @hTileDc
    
    invoke CreateCompatibleDC, @hDc
    mov @hHeroDc, eax
    invoke SelectObject, @hHeroDc, hBitmapHero
    
    invoke TransparentBlt, @hDc, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, @hHeroDc, 0, 0, BLOCK_SIZE, BLOCK_SIZE, 0FFFFFFh
    mov eax, I.pos.x
    add eax, 6
    mov bx, BLOCK_SIZE
    mul bx
    push eax
    mov eax, I.pos.y
    add eax, 1
    mul bx
    pop ebx
    invoke TransparentBlt, @hDc, ebx, eax, BLOCK_SIZE, BLOCK_SIZE, @hHeroDc, 0, 0, BLOCK_SIZE, BLOCK_SIZE, 0FFFFFFh

    invoke DeleteDC, @hHeroDc


    ;invoke DrawText, @hDc, addr szText, -1, addr @stRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
    invoke EndPaint, hWnd, addr @stPs
  .elseif eax == WM_KEYDOWN
    invoke ProcKeydown, hWnd, uMsg, wParam, lParam
  .elseif eax == WM_CREATE
    ; do nothing
  .elseif eax == WM_CLOSE
    invoke DestroyWindow, hWinMain
    invoke PostQuitMessage, NULL
  .elseif eax == WM_COMMAND
    .if wParam == IDM_NEWGAME
      invoke MessageBox, hWinMain, addr szHeroHealth, addr szHeroAttack, MB_OK
    .elseif wParam == IDM_QUIT
      invoke PostQuitMessage, 0
    .endif
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
  mov @stWndClass.hInstance, eax
  invoke RtlZeroMemory, addr @stWndClass, sizeof @stWndClass 
  mov @stWndClass.hIcon, eax
  mov @stWndClass.hIconSm, eax

  invoke LoadCursor, 0, IDC_ARROW
  mov @stWndClass.hCursor, eax ; 用LoadCursor为光标句柄赋值
  
  mov @stWndClass.cbSize, sizeof WNDCLASSEX
  mov @stWndClass.style, CS_HREDRAW or CS_VREDRAW
  mov @stWndClass.lpfnWndProc, offset _ProcWinMain
  mov @stWndClass.hbrBackground, COLOR_WINDOW + 1
  mov @stWndClass.lpszClassName, offset szClassName

  invoke CreateMenu
  mov hMenu, eax
  invoke AppendMenu, hMenu, 0, IDM_NEWGAME, offset szMenuNewGame
  invoke AppendMenu, hMenu, 0, IDM_QUIT, offset szMenuQuit

  invoke LoadMenu, hInstance, IDM_MAIN
  mov @hMenu, eax

  invoke RegisterClassEx, addr @stWndClass
  ; create a client edged window
  ; whose class is 'szClassName',
  ; and caption is 'szCaptionMain'
  ;  
  invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szClassName, addr szCaptionMain, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_EX_COMPOSITED, 0, 0, 20 * BLOCK_SIZE + 10, 15 * BLOCK_SIZE + 50, NULL, hMenu, hInstance, NULL
  mov hWinMain, eax ; mark hWinMain as the main window
  invoke UpdateWindow, hWinMain ; send WM_PRINT to hWinMain
  invoke SendMessage, hWinMain, WM_SETICON, ICON_BIG, hIcon
  invoke ShowWindow, hWinMain, SW_SHOWNORMAL ; show window in a normal way
  invoke SetTimer, hWinMain, TIMERID_IDLE_BGM, INTERVAL_IDLE_BGM, lpfnTimerIdleBGM
  ; main loop
  .while 1
    invoke GetMessage, addr @stMsg, NULL, 0, 0
    .break .if eax == 0 ; WM_QUIT => eax == 0
    invoke TranslateMessage, addr @stMsg
    invoke DispatchMessage, addr @stMsg
  .endw
  ret
_WinMain endp


__main proc
  invoke PreloadImages
  invoke _WinMain
  invoke ExitProcess, 0
__main endp
end __main