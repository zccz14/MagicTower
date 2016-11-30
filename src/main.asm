.386
.model flat, stdcall
option casemap: none

include stdafx.inc

.data?
hInstance dd  ?
hWinMain dd  ?
hBitmapHero dd ?
hBitmapTile dd ?
.const
szBitmapTile db 'images\\tile.bmp', 0
szBitmapHero db 'images\\hero.bmp', 0
szClassName db 'MainWindow', 0
szCaptionMain db '魔塔', 0
szBackgoundMap dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0105H, 0105H, 0105H, 0105H, 0105H, 0105H, 0105H, 0105H, 0105H, 0105H, 0105H, 0105H, 0105H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0005H, 0105H, 0105H, 0105H, 0205H, 0005H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0301H, 0205H
               dd 0006H, 0106H, 0106H, 0106H, 0206H, 0006H, 0106H, 0106H, 0106H, 0106H, 0106H, 0106H, 0106H, 0106H, 0106H, 0106H, 0106H, 0106H, 0106H, 0206H
.code

PreloadBitmaps proc
    invoke LoadImage, NULL, addr szBitmapTile, IMAGE_BITMAP, 256, 1216, LR_LOADFROMFILE
    mov hBitmapTile, eax
    invoke LoadImage, NULL, addr szBitmapHero, IMAGE_BITMAP, 32, 32, LR_LOADFROMFILE
    mov hBitmapHero, eax
PreloadBitmaps endp

ProcSetBackground proc

ProcSetBackground endp

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
    PrintHex eax
    invoke BeginPaint, hWnd, addr @stPs
    mov @hDc, eax
    
    invoke CreateCompatibleDC, @hDc
    mov @hTileDc, eax ; tile DC
    invoke SelectObject, @hTileDc, hBitmapTile
    invoke BitBlt, @hDc, 0, 0, 256, 256, @hTileDc, 0, 5 * BLOCK_SIZE, SRCCOPY
    invoke CreateCompatibleDC, @hDc
    mov @hBackDc, eax ; background DC
    invoke CreateCompatibleBitmap, @hDc, 20 * BLOCK_SIZE, 15 * BLOCK_SIZE
    mov @hBitmapBack, eax ; background Bitmap
    invoke SelectObject, @hBackDc, @hBitmapBack
    mov esi, offset szBackgoundMap
    mov ecx, 0
    .while ecx < 15 * BLOCK_SIZE
      mov edx, 0
      .while edx < 20 * BLOCK_SIZE
        push ecx
        push edx
        mov eax, [esi]
        mov bh, ah
        mov bl, BLOCK_SIZE
        mul bl  ; ax = [esi]l * bl
        push eax
        mov al, bh
        mul bl  ; ax = [esi]h * bl
        mov ebx, eax
        pop eax
        invoke BitBlt, @hBackDc, edx, ecx, BLOCK_SIZE, BLOCK_SIZE, @hTileDc, ebx, eax, SRCCOPY
        pop edx
        pop ecx
        add esi, 4
        add edx, BLOCK_SIZE
      .endw
      add ecx, BLOCK_SIZE
    .endw

    invoke BitBlt, @hDc, 0, 0, 20 * BLOCK_SIZE, 15 * BLOCK_SIZE, @hBackDc, 0, 0, SRCCOPY
    
    invoke CreateCompatibleDC, @hDc
    mov @hHeroDc, eax
    invoke SelectObject, @hHeroDc, hBitmapHero
    
    invoke TransparentBlt, @hDc, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, @hHeroDc, 0, 0, BLOCK_SIZE, BLOCK_SIZE, 0FFFFFFh

    ;invoke GetClientRect, hWnd, addr @stRect
    ;invoke DrawText, @hDc, addr szText, -1, addr @stRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
    invoke EndPaint, hWnd, addr @stPs
  .elseif eax == WM_CREATE
    ; do nothing
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

  invoke RegisterClassEx, addr @stWndClass
  ; create a client edged window
  ; whose class is 'szClassName',
  ; and caption is 'szCaptionMain'
  ;  
  invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szClassName, addr szCaptionMain, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU, 0, 0, 20 * BLOCK_SIZE + 10, 15 * BLOCK_SIZE + 50, NULL, @hMenu, hInstance, NULL
  mov hWinMain, eax ; mark hWinMain as the main window
  invoke UpdateWindow, hWinMain ; send WM_PRINT to hWinMain
  invoke LoadIcon, hInstance, ICO_BIG
  invoke SendMessage, hWinMain, WM_SETICON, ICON_BIG, eax
  invoke ShowWindow, hWinMain, SW_SHOWNORMAL ; show window in a normal way
  ;invoke SetLayeredWindowAttributes, hWinMain, window_background_brush, 255, LWA_COLORKEY
  ; main loop
  .while 1
    PrintLine
    invoke GetMessage, addr @stMsg, NULL, 0, 0
    .break .if eax == 0 ; WM_QUIT => eax == 0
    invoke TranslateMessage, addr @stMsg
    invoke DispatchMessage, addr @stMsg
  .endw
  ret
_WinMain endp


__main proc
  call PreloadBitmaps
  invoke _WinMain
  invoke ExitProcess, 0
__main endp
end __main