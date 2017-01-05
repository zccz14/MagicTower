public PlayIdleBGM, PlayOnWalk
include <stdafx.inc>

.const
szIdleBGM db 'audio\\bgm_idle.wav', 0
szOnWalk db 'audio\\walk.wav', 0

.code
PlayIdleBGM proc
    invoke PlaySound, addr szIdleBGM, 0, SND_ASYNC or SND_NODEFAULT or SND_FILENAME or SND_LOOP or SND_NOSTOP
    ret
PlayIdleBGM endp
PlayOnWalk proc
    invoke PlaySound, addr szOnWalk, 0, SND_ASYNC or SND_NODEFAULT or SND_FILENAME
    ret
PlayOnWalk endp
end
