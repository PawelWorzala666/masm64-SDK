; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include binpath.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

 cpMul proc source:QWORD,multiplier:QWORD

    LOCAL var:QWORD

    fild source         ; load source
    fild multiplier     ; load multiplier
    fmul                ; multiply source by multiplier
    fistp var           ; store result in variable
    mov rax, var

    ret

 cpMul endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    end
