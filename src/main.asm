
include stdafx.inc

.data
HeroPosX dd 0
HeroPosY dd 0
HeroHealth dd 1000
HeroAttack dd 100
HeroDefence dd 100
HeroMoney dd 0
.data?
hInstance dd  ?
hWinMain dd  ?
hBitmapHero dd ?
hBitmapTile dd ?
hIcon dd ?
hMenu dd ?
.const
szIcon db 'images\\icon.ico', 0
szBitmapTile db 'images\\tile.bmp', 0
szBitmapHero db 'images\\hero.bmp', 0
szClassName db 'MainWindow', 0
szMenuNewGame db '新游戏(&N)', 0
szMenuQuit db '退出(&Q)', 0
szCaptionMain db '魔塔', 0
szHeroHealth db '生命', 0
szHeroAttack db '攻击力', 0
.code

PreloadImages proc
    invoke LoadImage, NULL, addr szBitmapTile, IMAGE_BITMAP, 256, 1216, LR_LOADFROMFILE
    mov hBitmapTile, eax
    invoke LoadImage, NULL, addr szBitmapHero, IMAGE_BITMAP, 128, 132, LR_LOADFROMFILE
    mov hBitmapHero, eax
    invoke LoadImage, NULL, addr szIcon, IMAGE_ICON, 16, 16, LR_LOADFROMFILE
    mov hIcon, eax
    ret
PreloadImages endp


ProcKeydown proc hWnd, uMsg, wParam, lParam
  local @stRect: RECT
  .if wParam == VK_UP
    .if HeroPosY > 0
      dec HeroPosY
    .endif
    invoke UpdateWindow, hWinMain
  .elseif wParam == VK_DOWN
    .if HeroPosY < MAP_SIZE - 1
      inc HeroPosY
    .endif
    invoke UpdateWindow, hWinMain
  .elseif wParam == VK_LEFT
    .if HeroPosX > 0
      dec HeroPosX
    .endif
    invoke UpdateWindow, hWinMain
  .elseif wParam == VK_RIGHT
    .if HeroPosX < MAP_SIZE - 1
      inc HeroPosX
    .endif
    invoke UpdateWindow, hWinMain
  .else
    ret
  .endif
  invoke GetClientRect, hWnd, addr @stRect
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
    mov eax, HeroPosX
    add eax, 6
    mov bx, BLOCK_SIZE
    mul bx
    push eax
    mov eax, HeroPosY
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
  invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szClassName, addr szCaptionMain, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU, 0, 0, 20 * BLOCK_SIZE + 10, 15 * BLOCK_SIZE + 50, NULL, hMenu, hInstance, NULL
  mov hWinMain, eax ; mark hWinMain as the main window
  invoke UpdateWindow, hWinMain ; send WM_PRINT to hWinMain
  invoke SendMessage, hWinMain, WM_SETICON, ICON_BIG, hIcon
  invoke ShowWindow, hWinMain, SW_SHOWNORMAL ; show window in a normal way
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
  call PreloadImages
  invoke _WinMain
  invoke ExitProcess, 0
__main endp
end __main