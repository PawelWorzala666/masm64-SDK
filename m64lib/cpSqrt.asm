; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include binpath.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

 cpSqrt proc source:QWORD

    LOCAL var:QWORD

    fild source         ; load source integer
    fsqrt
    fistp var           ; store result in variable
    mov rax, var

    ret

 cpSqrt endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    end
