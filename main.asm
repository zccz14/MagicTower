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

.data?
hInstance dd  ?
hWinMain dd  ?
.const
szClassName db 'MainWindow', 0
szCaptionMain db '魔塔', 0
szText  db '苟利国家生死以', 0
szButton db 'button',0
szButtonText db '这是一个按钮',0
.code

_ProcWinMain proc uses ebx edi esi hWnd, uMsg, wParam, lParam
  local @stPs: PAINTSTRUCT
  local @stRect: RECT
  local @hDc
  mov eax, uMsg
  .if eax == WM_PAINT
    invoke BeginPaint, hWnd, addr @stPs
    mov @hDc, eax
    invoke GetClientRect, hWnd, addr @stRect
    invoke DrawText, @hDc, addr szText, -1, addr @stRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
    invoke EndPaint, hWnd, addr @stPs
  .elseif eax == WM_CREATE
    ; create a button
    invoke CreateWindowEx, NULL, offset szButton, offset szButtonText, WS_CHILD or WS_VISIBLE, 10, 10, 80, 22, hWnd, 1, hInstance, NULL
  .elseif eax == WM_CLOSE
    invoke DestroyWindow, hWinMain
    invoke PostQuitMessage, NULL
  .else
    ; default
    invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    ret
  .endif
  xor eax, eax
  ret
_ProcWinMain endp

_WinMain proc
  local @stWndClass: WNDCLASSEX
  local @stMsg: MSG
  invoke GetModuleHandle, NULL
  mov hInstance, eax
  mov @stWndClass.hInstance, eax ; 指定要注册的窗口类属于哪个模块
  invoke RtlZeroMemory, addr @stWndClass, sizeof @stWndClass 

  invoke LoadCursor, 0, IDC_ARROW
  mov @stWndClass.hCursor, eax ; 用LoadCursor为光标句柄赋值
  
  mov @stWndClass.cbSize, sizeof WNDCLASSEX ;指定结构的长度
  mov @stWndClass.style, CS_HREDRAW or CS_VREDRAW ;窗口风格
  mov @stWndClass.lpfnWndProc, offset _ProcWinMain ;窗口过程地址
  mov @stWndClass.hbrBackground, COLOR_WINDOW + 1 ;客户区背景色
  mov @stWndClass.lpszClassName, offset szClassName ;为此类命名
  invoke RegisterClassEx, addr @stWndClass
  ;hIcon------图标句柄，指定显示在窗口标题栏左上角的图标。
  ;cbclsextra和cbwndextra------预留的空间，用来存放自定义数据，不使用就是0。
  ;lpszmenuname------窗口菜单
  ;hiconsm------小图标
  
  ; create a window
  invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szClassName, addr szCaptionMain, WS_OVERLAPPEDWINDOW, 100, 100, 600, 400, NULL, NULL, hInstance, NULL
  mov hWinMain, eax ; mark hWinMain as the main window
  invoke ShowWindow, hWinMain, SW_SHOWNORMAL ; show window in a normal way
  invoke UpdateWindow, hWinMain ; send WM_PRINT to hWinMain
  .while TRUE
    invoke GetMessage, addr @stMsg, NULL, 0, 0
    .break .if eax == 0 ; WM_QUIT => eax == 0
    invoke TranslateMessage, addr @stMsg
    invoke DispatchMessage, addr @stMsg
  .endw
  ret
_WinMain endp


__main proc
  invoke _WinMain
  invoke ExitProcess, 0
__main endp
end __main