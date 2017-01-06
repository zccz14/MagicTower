include <stdafx.inc>
include <images.inc>
include <background.inc>
include <braver.inc>
include <timer.inc>
include <audio.inc>
include <map.inc>

.data
szText db 100 dup(?), 0
.data?
hInstance dd  ?
hWinMain dd  ?
hMenu dd ?
.const
szIntegerFormat db '%d', 0
szClassName db 'MainWindow', 0
szMenuNewGame db '新游戏(&N)', 0
szMenuQuit db '退出(&Q)', 0
szCaptionMain db '魔塔', 0
szHeroHealth db '生命：%d', 0
szHeroAttack db '攻击力：%d', 0
szHeroDEF db '防御力：%d', 0
szHeroMoney db '金币：%d', 0
szKeyYellow db '黄钥匙：%d', 0
szKeyBlue db '蓝钥匙：%d', 0
szKeyRed db '红钥匙：%d', 0

stRectFloor RECT <2 * BLOCK_SIZE, BLOCK_SIZE, 4 * BLOCK_SIZE, 2 * BLOCK_SIZE>
stRectHP RECT <1 * BLOCK_SIZE, 3 * BLOCK_SIZE, 4 * BLOCK_SIZE, 4 * BLOCK_SIZE>
stRectATK RECT <1 * BLOCK_SIZE, 4 * BLOCK_SIZE, 4 * BLOCK_SIZE, 5 * BLOCK_SIZE>
stRectDEF RECT <1 * BLOCK_SIZE, 5 * BLOCK_SIZE, 4 * BLOCK_SIZE, 6 * BLOCK_SIZE>
stRectMoney RECT <1 * BLOCK_SIZE, 6 * BLOCK_SIZE, 4 * BLOCK_SIZE, 7 * BLOCK_SIZE>
stRectYellow RECT <1 * BLOCK_SIZE, 7 * BLOCK_SIZE, 4 * BLOCK_SIZE, 8 * BLOCK_SIZE>
stRectBlue RECT <1 * BLOCK_SIZE, 8 * BLOCK_SIZE, 4 * BLOCK_SIZE, 9 * BLOCK_SIZE>
stRectRed RECT <1 * BLOCK_SIZE, 9 * BLOCK_SIZE, 4 * BLOCK_SIZE, 10 * BLOCK_SIZE>

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

; @returns {Boolean} 1 for accessible, 0 for wait
Touch proc hWnd, x, y
  local @stRect: RECT
  local @bRet: BOOL
  invoke GetBlockRect, x, y, addr @stRect
  .if x > MAP_SIZE - 1 || y > MAP_SIZE - 1
    inc I.pos.z
    dec I.HP
    invoke InvalidateRect, hWnd, addr stRectFloor, TRUE
    invoke InvalidateRect, hWnd, addr stRectHP, TRUE
    invoke UpdateWindow, hWnd
    mov eax, 0
    ret
  .endif
  invoke GetBlock, I.pos.z, x, y
  .if eax == 0
    mov @bRet, TRUE
  .elseif eax == 2
    ; touch yellow door
    .if I.yellow > 0
      invoke SetBlock, x, y, I.pos.z, 0; open the door
      dec I.yellow
      invoke InvalidateRect, hWnd, addr @stRect, TRUE
      invoke InvalidateRect, hWnd, addr stRectYellow, TRUE
      invoke UpdateWindow, hWnd
      invoke PlayOnDoor
    .endif
    mov @bRet, FALSE
  .elseif eax == 3
    ; touch blue door
    .if I.blue > 0
      invoke SetBlock, x, y, I.pos.z, 0; open the door
      dec I.blue
      invoke InvalidateRect, hWnd, addr @stRect, TRUE
      invoke InvalidateRect, hWnd, addr stRectBlue, TRUE
      invoke UpdateWindow, hWnd
      invoke PlayOnDoor
    .endif
    mov @bRet, FALSE
  .elseif eax == 4
    ; touch red door
    .if I.red > 0
      invoke SetBlock, x, y, I.pos.z, 0; open the door
      dec I.red
      invoke InvalidateRect, hWnd, addr @stRect, TRUE
      invoke InvalidateRect, hWnd, addr stRectRed, TRUE
      invoke UpdateWindow, hWnd
      invoke PlayOnDoor
    .endif
    mov @bRet, FALSE
  .else
    mov @bRet, FALSE
  .endif
  mov eax, @bRet
  ret
Touch endp

ProcKeydown proc hWnd, uMsg, wParam, lParam
  local @stRect: RECT
  local @lNewX
  local @lNewY
  mLet @lNewX, I.pos.x
  mLet @lNewY, I.pos.y
  .if wParam == VK_UP
    dec @lNewY
  .elseif wParam == VK_DOWN
    inc @lNewY
  .elseif wParam == VK_LEFT
    dec @lNewX
  .elseif wParam == VK_RIGHT
    inc @lNewX
  .else
    ret
  .endif
  invoke Touch, hWnd, @lNewX, @lNewY
  .if eax == 0
    ret
  .else
    invoke PlayOnWalk
    invoke GetBlockRect, @lNewX, @lNewY, addr @stRect
    invoke InvalidateRect, hWnd, addr @stRect, TRUE
    invoke GetBlockRect, I.pos.x, I.pos.y, addr @stRect
    invoke InvalidateRect, hWnd, addr @stRect, TRUE
    mLet I.pos.x, @lNewX
    mLet I.pos.y, @lNewY
    invoke UpdateWindow, hWnd
  .endif
  ret
ProcKeydown endp

_ProcWinMain proc uses ebx edi esi hWnd, uMsg, wParam, lParam
  local @stPs: PAINTSTRUCT
  local @stRect: RECT
  local @hDc
  local @hDCTemp
  mov eax, uMsg
  ; PrintHex eax
  .if eax == WM_PAINT
    invoke BeginPaint, hWnd, addr @stPs
    mov @hDc, eax
    ; draw background
    invoke BitBlt, @hDc, 0, 0, 20 * BLOCK_SIZE, 15 * BLOCK_SIZE, hDCBackground, 0, 0, SRCCOPY
    ; avatar
    invoke TransparentBlt, @hDc, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, hDCBraver, 0, 0, BLOCK_SIZE, BLOCK_SIZE, 0FFFFFFh
    ; Floor Number
    assume esi: ptr HDC
    lea esi, hDCNumbers
    mov ebx, 100
    mov edx, 0
    mov eax, I.pos.z
    div ebx
    mov eax, edx
    mov edx, 0
    mov ebx, 10
    div ebx
    shl eax, 2
    shl edx, 2
    push edx
    mov ebx, eax
    invoke TransparentBlt, @hDc, 2 * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, [esi + ebx], 0, 0, BLOCK_SIZE, BLOCK_SIZE, 0FFFFFFh
    pop ebx
    invoke TransparentBlt, @hDc, 3 * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, [esi + ebx], 0, 0, BLOCK_SIZE, BLOCK_SIZE, 0FFFFFFh
    assume esi: nothing

    invoke GetMapDC, hWnd, I.pos.z
    invoke TransparentBlt, @hDc, 6 * BLOCK_SIZE, BLOCK_SIZE, 13 * BLOCK_SIZE, 13 * BLOCK_SIZE, eax, 0, 0, 13 * BLOCK_SIZE, 13 * BLOCK_SIZE, 0FFFFFFh

    invoke crt_sprintf, addr szText, addr szHeroHealth, I.HP
    invoke DrawText, @hDc, addr szText, -1, addr stRectHP, DT_SINGLELINE or DT_CENTER or DT_VCENTER
    invoke crt_sprintf, addr szText, addr szHeroAttack, I.ATK
    invoke DrawText, @hDc, addr szText, -1, addr stRectATK, DT_SINGLELINE or DT_CENTER or DT_VCENTER    
    invoke crt_sprintf, addr szText, addr szHeroDEF, I.DEF
    invoke DrawText, @hDc, addr szText, -1, addr stRectDEF, DT_SINGLELINE or DT_CENTER or DT_VCENTER    
    invoke crt_sprintf, addr szText, addr szHeroMoney, I.MON
    invoke DrawText, @hDc, addr szText, -1, addr stRectMoney, DT_SINGLELINE or DT_CENTER or DT_VCENTER    
    invoke crt_sprintf, addr szText, addr szKeyYellow, I.yellow
    invoke DrawText, @hDc, addr szText, -1, addr stRectYellow, DT_SINGLELINE or DT_CENTER or DT_VCENTER
    invoke crt_sprintf, addr szText, addr szKeyBlue, I.blue
    invoke DrawText, @hDc, addr szText, -1, addr stRectBlue, DT_SINGLELINE or DT_CENTER or DT_VCENTER
    invoke crt_sprintf, addr szText, addr szKeyRed, I.red
    invoke DrawText, @hDc, addr szText, -1, addr stRectRed, DT_SINGLELINE or DT_CENTER or DT_VCENTER

    ; draw braver by position
    mov eax, I.pos.x
    add eax, 6
    mov bx, BLOCK_SIZE
    mul bx
    push eax
    mov eax, I.pos.y
    add eax, 1
    mul bx
    pop ebx
    invoke TransparentBlt, @hDc, ebx, eax, BLOCK_SIZE, BLOCK_SIZE, hDCBraver, 0, 0, BLOCK_SIZE, BLOCK_SIZE, 0FFFFFFh

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
  invoke PrepareDC, hWinMain
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
  PrintLine
  invoke MapInit
  invoke PreloadImages
  invoke _WinMain
  invoke ExitProcess, 0
__main endp
end __main