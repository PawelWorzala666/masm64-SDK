; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include binpath.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

 cpDiv proc source:QWORD,divider:QWORD

    LOCAL var:QWORD

    fild source         ; load source
    fild divider        ; load divider
    fdiv                ; divide source by divider
    fistp var           ; store result in variable
    mov rax, var

    ret

 cpDiv endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    end
