; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    include binpath.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

font_handle proc facename:QWORD,fHgt:QWORD,fWgt:QWORD

    invoke CreateFont,fHgt,0,0,0,fWgt,0,0,0,DEFAULT_CHARSET, \
                      OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS, \
                      PROOF_QUALITY,DEFAULT_PITCH,facename
    ret

font_handle endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    end
