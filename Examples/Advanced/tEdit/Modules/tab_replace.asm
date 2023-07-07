; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm32\include64\masm64rt.inc

    externdef get_current_line_index:PROC

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

tab_replace proc Edit:QWORD,tabs:QWORD

  ; ---------------------------------------------------------
  ; mixed registers are due to CHARRANGE having DWORD members
  ; ---------------------------------------------------------

    LOCAL indx     :QWORD
    LOCAL diff     :QWORD
    LOCAL bal      :QWORD
    LOCAL cr       :CHARRANGE
    LOCAL hsp      :QWORD
    LOCAL psp      :QWORD
    LOCAL spbuf[16]:BYTE

    mov psp, ptr$(spbuf)

    invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    .if cr.cpMin ~= eax                                     ; if test is selected
      invoke SendMessage,Edit,EM_REPLACESEL,TRUE,chr$(0)    ; overwrite it with keystroke
      invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr         ; get the new selection
    .endif

    .if tabs == 0                                           ; test tab size
      mov tabs, 4                                           ; set a default tab size if zero
    .endif

    mov indx, rv(get_current_line_index,Edit)               ; get the current line index

    mov rax, indx
    .if cr.cpMin == eax                                     ; if start of line (indx = cr.cpMin)
      mov hsp, space$(psp,tabs)
      fn SendMessage,Edit,EM_REPLACESEL,TRUE,hsp            ; write "tabs" space count
      ret
    .else
      mov rax, indx
      sub cr.cpMin, eax                                     ; sub indx from cr.cpMin

      mov eax, cr.cpMin
      mov diff, rax                                         ; store it in "diff"

      xor edx, edx                                          ; clear EDX
      mov rax, diff                                         ; diff in accumulator
      div WORD PTR tabs                                     ; diff \ tabs
      mov ecx, edx                                          ; store remainder
      mul WORD PTR tabs                                     ; result * tabs
      mov rax, tabs                                         ; sub remainder from "tabs" size
      sub eax, ecx                                          ; balance in EAX
      mov bal, rax

      mov hsp, space$(psp,bal)
      fn SendMessage,Edit,EM_REPLACESEL,TRUE,hsp            ; replace selection with "bal" space count

      ret
    .endif

tab_replace endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
