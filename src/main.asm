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
szCaptionMain db 'ħ��', 0
szText  db '��������������', 0
szButton db 'button',0
szButtonText db '����һ����ť',0
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
  mov @stWndClass.hInstance, eax ; ָ��Ҫע��Ĵ����������ĸ�ģ��
  invoke RtlZeroMemory, addr @stWndClass, sizeof @stWndClass 

  invoke LoadCursor, 0, IDC_ARROW
  mov @stWndClass.hCursor, eax ; ��LoadCursorΪ�������ֵ
  
  mov @stWndClass.cbSize, sizeof WNDCLASSEX ;ָ���ṹ�ĳ���
  mov @stWndClass.style, CS_HREDRAW or CS_VREDRAW ;���ڷ��
  mov @stWndClass.lpfnWndProc, offset _ProcWinMain ;���ڹ��̵�ַ
  mov @stWndClass.hbrBackground, COLOR_WINDOW + 1 ;�ͻ�������ɫ
  mov @stWndClass.lpszClassName, offset szClassName ;Ϊ��������
  invoke RegisterClassEx, addr @stWndClass
  ;hIcon------ͼ������ָ����ʾ�ڴ��ڱ��������Ͻǵ�ͼ�ꡣ
  ;cbclsextra��cbwndextra------Ԥ���Ŀռ䣬��������Զ������ݣ���ʹ�þ���0��
  ;lpszmenuname------���ڲ˵�
  ;hiconsm------Сͼ��
  
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