public lpfnTimerIdleBGM
include <stdafx.inc>
include <audio.inc>

.code
lpfnTimerIdleBGM proc hWnd, uMsg, idEvent, dwTime
    invoke PlayIdleBGM
    ret
lpfnTimerIdleBGM endp
end