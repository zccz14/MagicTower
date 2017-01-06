public PlayIdleBGM, PlayOnWalk, PlayOnDoor, PlayOnItem
include <stdafx.inc>

.const
szIdleBGM db 'audio\\bgm_idle.wav', 0
szOnWalk db 'audio\\walk.wav', 0
szOnItem db 'audio\\item.wav', 0
szOnDoor db 'audio\\door.wav', 0

.code
PlayIdleBGM proc
    invoke PlaySound, addr szIdleBGM, 0, SND_ASYNC or SND_NODEFAULT or SND_FILENAME or SND_LOOP or SND_NOSTOP
    ret
PlayIdleBGM endp
PlayOnWalk proc
    invoke PlaySound, addr szOnWalk, 0, SND_ASYNC or SND_NODEFAULT or SND_FILENAME or SND_NOSTOP
    ret
PlayOnWalk endp

PlayOnDoor proc
    invoke PlaySound, addr szOnDoor, 0, SND_ASYNC or SND_NODEFAULT or SND_FILENAME
    ret
PlayOnDoor endp

PlayOnItem proc
    invoke PlaySound, addr szOnItem, 0, SND_ASYNC or SND_NODEFAULT or SND_FILENAME
    ret
PlayOnItem endp

end
