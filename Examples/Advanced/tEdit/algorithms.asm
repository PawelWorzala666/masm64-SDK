; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

right_indent proc

    LOCAL cr    :CHARRANGE
    LOCAL tl    :QWORD
    LOCAL pMem  :QWORD
    LOCAL mOut  :QWORD
    LOCAL lcnt  :QWORD
    LOCAL ccnt  :QWORD

    USING r12,r13,r14,r15

    SaveRegs

    rcall SendMessage,hEdit,EM_EXGETSEL,0,ptr$(cr)
    mov eax,  cr.cpMax
    mov r14d, cr.cpMin
    mov r15d, cr.cpMax

    sub eax, cr.cpMin
    mov tl, rax
    add tl, 4096                ; 4k padding

    mov pMem, alloc(tl)

    mov ccnt, rvcall(SendMessage,hEdit,EM_GETSELTEXT,0,pMem)

  ; -----------------------------
  ; get ascii 13 line count
  ; -----------------------------
    xor r10, r10                ; zero the counter
    mov r11, pMem               ; load memory address

    sub r11, 1                  ; set r11 for following loop
  @@:
    add r11, 1                  ; add r11, 1
    cmp BYTE PTR [r11], 0       ; test if byte is zero
    je @F                       ; exit loop on zero
    cmp BYTE PTR [r11], 13      ; test if byte is ASCII 13
    jne @B                      ; loop back if not
    add r10, 1                  ; add 1 to counter
    jmp @B                      ; loop back for next character

  @@:                           ; r10 = line count
    mov lcnt, r10

  ; -----------------------------

    mov r12, tl
    add r12, r10                ; add line count to text length

    add r12, 4096               ; 4k padding

    mov mOut, alloc(r12)        ; allocate output buffer

  ; -----------------------------

    mov r13, pMem
    mov r12, mOut

    mov BYTE PTR [r12], 32      ; write the first space
    add r12, 1

  blp:
    movzx rax, BYTE PTR [r13]
    add r13, 1
    test rax, rax
    jz outlbl                   ; exit loop on 0
    cmp rax, 13
    je lbl1
    mov BYTE PTR [r12], al
    add r12, 1
    jmp blp

  lbl1:
    mov BYTE PTR [r12], 13
    add r12, 1
    mov BYTE PTR [r12], 32      ; write a space after each ascii 13
    add r12, 1
    jmp blp

  outlbl:
    sub r12, 1                  ; trim off the last 13
    mov BYTE PTR [r12], 0

    rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,mOut

    mov cr.cpMin, r14d
    mov cr.cpMax, r15d
    mov rax, lcnt
    add cr.cpMax, eax

    rcall PostMessage,hEdit,EM_EXSETSEL,0,ptr$(cr)      ; re-select modified text

    RestoreRegs

    mfree pMem
    mfree mOut

    ret

right_indent endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

left_indent proc

    LOCAL pMem  :QWORD
    LOCAL Mem2  :QWORD
    LOCAL mOut  :QWORD
    LOCAL ccnt  :QWORD
    LOCAL tlen  :QWORD
    LOCAL mLen  :QWORD
    LOCAL cr    :CHARRANGE
    USING r12,r13,r14,r15

    SaveRegs

    rcall SendMessage,hEdit,EM_EXGETSEL,0,ptr$(cr)

    mov eax, cr.cpMax
    sub eax, cr.cpMin
    mov tlen, rax                                       ; store original length in tlen

    add tlen, 4096

    mov pMem, alloc(tlen)
    mov r14, pMem

    mov ccnt, rvcall(SendMessage,hEdit,EM_GETSELTEXT,0,pMem)

    mov Mem2, alloc(tlen)
    mov r15, Mem2

    .if BYTE PTR [r14] ~= 32
      sub r14, 1
    .endif

  lpst:
    add r14, 1
    movzx r11, BYTE PTR [r14]
    cmp r11, 0
    je bye
    cmp r11, 13
    je nxt
  backin:
    mov BYTE PTR [r15], r11b
    add r15, 1
    jmp lpst

  nxt:
    mov BYTE PTR [r14], 13                              ; write CR
    cmp BYTE PTR [r14+1], 32                            ; test for trailing space
    jne backin
    add r14, 1
    jmp backin

  bye:
    mov BYTE PTR [r15], 0                               ; terminate output buffer
    rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,Mem2

    mov mLen, len(Mem2)

    mov eax, cr.cpMin
    add rax, mLen
    mov cr.cpMax, eax

    rcall SendMessage,hEdit,EM_EXSETSEL,0,ptr$(cr)      ; re-select modified text

    mfree pMem
    mfree Mem2

    RestoreRegs

    ret

left_indent endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

indent_select proc

    LOCAL cr    :CHARRANGE

    .if rv(GetFocus) ~= hEdit           ; blocks left / right if DLG has focus
      xor rax, rax                      ; return 0 if no selection
      ret
    .endif

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    cmp cr.cpMin, eax                   ; if equal, no selection
    jne OK
    xor rax, rax                        ; return 0 if no selection
    ret
  OK:
    mov rax, 1                          ; return NON 0 on selection
    ret

indent_select endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

is_text_selected proc

    LOCAL cr    :CHARRANGE

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    cmp cr.cpMin, eax                   ; if equal, no selection
    jne OK
    xor rax, rax                        ; return 0 if no selection
    ret
  OK:
    mov rax, 1                          ; return NON 0 on selection
    ret

is_text_selected endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい
