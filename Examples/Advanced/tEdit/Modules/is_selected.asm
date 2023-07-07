; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm32\include64\masm64rt.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

is_selected proc Parent:QWORD,Edit:QWORD

    LOCAL cr    :CHARRANGE

    invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    cmp cr.cpMin, eax                   ; if equal, no selection
    jne OK

    invoke MsgboxI,Parent,"Please select the text you wish to modify.","No Text To Work On",MB_OK,10

    xor rax, rax                        ; return 0 if no selection
    ret

  OK:
    mov rax, 1                          ; return NON 0 on selection
    ret

is_selected endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
