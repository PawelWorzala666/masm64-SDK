; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm32\include64\masm64rt.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

set_lcase proc Edit:QWORD

    LOCAL cr   :CHARRANGE
    LOCAL ln   :QWORD
    LOCAL pMem :QWORD

    rcall SendMessage,Edit,EM_EXGETSEL,0,ptr$(cr)
    mov eax, cr.cpMax
    sub eax, cr.cpMin
    mov ln, rax

    mov pMem, alloc(ln)
    rcall SendMessage,Edit,EM_GETSELTEXT,0,pMem
    rcall szLower,pMem
    rcall SendMessage,Edit,EM_REPLACESEL,TRUE,pMem
    mfree pMem

    rcall SendMessage,Edit,EM_EXSETSEL,0,ptr$(cr)

    ret

set_lcase endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
