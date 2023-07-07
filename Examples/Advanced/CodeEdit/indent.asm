; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 add_indent proc

    LOCAL cr    :CHARRANGE
    LOCAL cpMin :QWORD
    LOCAL cpMax :QWORD
    LOCAL tlen  :QWORD
    LOCAL pbuf  :QWORD
    LOCAL buff[260]:BYTE
    LOCAL pMem  :QWORD
    LOCAL hMem  :QWORD
    LOCAL rval  :QWORD

    mov pbuf, ptr$(buff)

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr

    mov edx, cr.cpMin
    mov cpMin, rdx

    mov ecx, cr.cpMax
    mov cpMax, rcx

    sub rcx, rdx
    mov tlen, rcx

    mov rax, tlen
    add rax, 1024
    mov hMem, alloc(rax)

    mov rax, tlen
    add rax, rax
    mov pMem, alloc(rax)

    invoke SendMessage,hEdit,EM_GETSELTEXT,0,hMem

    mov r11, hMem
    mov r10, pMem
    mov BYTE PTR [r10], 32
    add r10, 1
    sub r11, 1
  @@:
    add r11, 1
    mov al, BYTE PTR [r11]
    mov BYTE PTR [r10], al
    add r10, 1
    cmp al, 13
    jne nxt1
    mov BYTE PTR [r10], 32
    add r10, 1
  nxt1:
    cmp al, 0
    jne @B
    mov BYTE PTR [r10-2], 0

    mov tlen, len(pMem)
    mov cr.cpMax, eax
    mov rax, cpMin
    mov cr.cpMin, eax

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr
    invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,pMem

    mov eax, cr.cpMin
    mov edx, eax
    add rdx, len(pMem)
    mov cr.cpMax, edx

    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr

    mfree hMem
    mfree pMem

    ret

 add_indent endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 sub_indent proc

    LOCAL cr    :CHARRANGE
    LOCAL cpMin :QWORD
    LOCAL cpMax :QWORD
    LOCAL tlen  :QWORD
    LOCAL pbuf  :QWORD
    LOCAL buff[260]:BYTE
    LOCAL pMem  :QWORD
    LOCAL hMem  :QWORD
    LOCAL rval  :QWORD
    LOCAL mPtr  :QWORD

    mov pbuf, ptr$(buff)

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr

    mov edx, cr.cpMin
    mov cpMin, rdx

    mov ecx, cr.cpMax
    mov cpMax, rcx

    sub rcx, rdx
    mov tlen, rcx

    mov rax, tlen
    add rax, 1024
    mov hMem, alloc(rax)

    invoke SendMessage,hEdit,EM_GETSELTEXT,0,hMem

    mov r11, hMem

    cmp BYTE PTR [r11], 32
    jne @F
    add r11, 1
  @@:
    mov mPtr, r11

    invoke szRep,mPtr,mPtr,chr$(13,32),chr$(13)

    mov tlen, len(mPtr)
    mov cr.cpMax, eax
    mov rax, cpMin
    mov cr.cpMin, eax

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr
    invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,mPtr

    mov eax, cr.cpMin
    mov edx, eax
    add rdx, len(mPtr)
    mov cr.cpMax, edx

    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr

    mfree hMem
    mfree pMem

    ret

 sub_indent endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

autoindent proc

    USING r14, r15

    LOCAL .r14  :QWORD
    LOCAL .r15  :QWORD
    LOCAL indx  :QWORD
    LOCAL llen  :QWORD
    LOCAL bcnt  :QWORD
    LOCAL ptrs  :QWORD
    LOCAL colm  :QWORD
    LOCAL cr    :CHARRANGE
    LOCAL cpMin :DWORD
    LOCAL cpMax :DWORD
    LOCAL pbuf  :QWORD
    LOCAL buff[1024]:BYTE

    SaveRegs

    invoke SendMessage,hEdit,EM_HIDESELECTION,TRUE,0

    mov pbuf, ptr$(buff)                                    ; text buffer pointer

    mov indx, rvcall(get_current_line_index_ex)             ; index of current line

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr          ; get the current selection
    mrmd cpMin, cr.cpMin                                    ; save both values
    mrmd cpMax, cr.cpMax

    mov llen, rv(SendMessage,hEdit,EM_LINELENGTH,-1,0)      ; get the line length

    mov rax, indx
    mov cr.cpMin, eax                                       ; load the CHARRANGE with the line start
    add rax, llen
    mov cr.cpMax, eax                                       ; load CHARRANGE with the line end

    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr          ; set the current selection to the CHARRANGE values
    invoke SendMessage,hEdit,EM_GETSELTEXT,0,pbuf           ; load selected text into buffer

    mrmd cr.cpMin, cpMin                                    ; restore original selection location
    mrmd cr.cpMax, cpMax
    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr

    mov bcnt, rv(blank_count_ex,pbuf)                       ; get blank count at start of buffer
    test rax, rax
    jz bye

  ; ----------------------

    mov r15, bcnt                                           ; test if bcnt and llen are equal
    cmp r15, llen
    jne lbl0                                                ; if not jump forward

    mov rax, indx                                           ; load CHARRANGE with start and end of blanks
    mov cr.cpMin, eax
    add rax, llen
    mov cr.cpMax, eax

    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr          ; remove blanks from line with only blanks
    invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,0

    jmp bye

  ; ----------------------

  lbl0:
    mov rax, bcnt
    cmp cr.cpMin, eax
    jbe bye

    mov colm, rv(get_current_column)                        ; get column position to calculate if
    mov rax, colm                                           ; cursor is in leading blanks
    cmp rax, bcnt                                           ; compare column to blank count
    jb bye                                                  ; bypass inserted spaces if below

    mov r15, bcnt
  @@:
    invoke PostMessage,hEdit,WM_CHAR,32,0
    sub r15, 1
    jnz @B

  bye:
    RestoreRegs

    invoke SendMessage,hEdit,EM_HIDESELECTION,FALSE,0

    ret

autoindent endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

get_current_line_index_ex proc

    USING r14, r15

    LOCAL cr    :CHARRANGE
    LOCAL begin :DWORD

    SaveRegs

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr           ; get original selection
    mov r14d, cr.cpMin
    mov r15d, cr.cpMax                                       ; preserve original selection

    invoke SendMessage,hEdit,WM_CHAR,32,0                    ; insert 1 space
    invoke SendMessage,hEdit,WM_KEYDOWN,VK_HOME,0            ; send HOME key

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr           ; get current select after HOME key
    mrmd begin, cr.cpMin                                     ; save it as the line beginning

    invoke SendMessage,hEdit,WM_KEYDOWN,VK_END,0             ; send END key
    invoke SendMessage,hEdit,WM_KEYDOWN,VK_BACK,0            ; delete the inserted space
    invoke SendMessage,hEdit,EM_UNDO,0,0                     ; undo the last 2 keystrokes
    invoke SendMessage,hEdit,EM_UNDO,0,0

    mov cr.cpMin, r14d
    mov cr.cpMax, r15d
    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr           ; restore previous selection

    mov eax, begin                                           ; return the line index

    RestoreRegs

    ret

get_current_line_index_ex endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 NOSTACKFRAME

blank_count_ex proc

    xor rax, rax        ; zero counter
    mov rdx, rcx        ; text pointer in rdx
    sub rdx, 1
  @@:
    add rdx, 1
    cmp BYTE PTR [rdx], 32
    jne @F
    add rax, 1
    jmp @B
  @@:
    ret

blank_count_ex endp

 STACKFRAME

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

get_current_column proc

    LOCAL cr    :CHARRANGE

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr          ; get original selection
    mov rax, rv(SendMessage,hEdit,EM_LINEINDEX,-1,0)        ; subtract line index from char position
    sub cr.cpMin, eax                                       ; to get the current column
    mov eax, cr.cpMin
    ret

get_current_column endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい
