; ��������������������������������������������������������������������������������������������������

    include binpath.inc

    .code

; ��������������������������������������������������������������������������������������������������

 RunUrl proc URLpath:QWORD

    LOCAL pbuf  :QWORD
    LOCAL buff[512]:BYTE

    mov pbuf, ptr$(buff)
    mcat pbuf,"explorer.exe ",URLpath
    rcall execute,pbuf

    ret

 RunUrl endp

; ��������������������������������������������������������������������������������������������������

    end
