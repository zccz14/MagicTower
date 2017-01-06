extrn hBitmapHero: dword
extrn hBitmapTile: dword
extrn hIcon: dword
extrn hDCTile: HDC
extrn hDCFloor: HDC
extrn hDCWall: HDC
extrn hDCBraver: HDC
extrn hDCBackground: HDC
extrn hDCNumbers: ptr HDC
extrn hDCYellowDoor: HDC
extrn hDCBlueDoor: HDC
extrn hDCRedDoor: HDC
extrn hDCUpstair: HDC
extrn hDCDownstair: HDC

extrn hDCKeyYellow: HDC
extrn hDCKeyBlue: HDC
extrn hDCKeyRed: HDC

PreloadImages proto
PrepareDC proto hWnd: HWND