public PlayIdleBGM
include <stdafx.inc>

.const
szIdleMusic db 'audio\\bgm_idle.wav', 0

.code
PlayIdleBGM proc hWnd, uMsg, idEvent, dwTime
    invoke PlaySound, addr szIdleMusic, 0, SND_ASYNC or SND_NODEFAULT or SND_FILENAME or SND_LOOP or SND_NOSTOP
    ret
PlayIdleBGM endp
end