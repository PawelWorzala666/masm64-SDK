; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    include binpath.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

NOSTACKFRAME

szUpper proc

  ; rcx = address of string

    mov rax, rcx
    sub rax, 1

  @@:
    add rax, 1
    cmp BYTE PTR [rax], 0
    je @F
    cmp BYTE PTR [rax], "a"
    jb @B
    cmp BYTE PTR [rax], "z"
    ja @B
    sub BYTE PTR [rax], 32
    jmp @B
  @@:

    mov rax, rcx

    ret

szUpper endp

STACKFRAME

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    end
