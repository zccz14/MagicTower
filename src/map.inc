MapInit proto
GetMap proto pMap: DWORD, index: DWORD
GetMapDC proto hWnd: HWND, index: DWORD
GetBlock proto index: DWORD, x: DWORD, y: DWORD
SetBlock proto x: DWORD, y: DWORD, z: DWORD, val: DWORD

extrn PosUp: ptr Position
extrn PosDown: ptr Position