; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    include binpath.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

NOSTACKFRAME

intmul proc

  ; --------------------------
  ; rcx = number to be multiplied
  ; rdx = its multiplier
  ; --------------------------

    mov r11, rdx
    xor rdx, rdx
    mov rax, rcx
    mul r11

    ret

intmul endp

STACKFRAME

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    end
