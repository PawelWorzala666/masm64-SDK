; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 rich_edit proc hParent:QWORD,instance:QWORD

    LOCAL pEdit  :QWORD
    LOCAL hFont  :QWORD
    LOCAL styl   :QWORD

  ; ---------------------------
  ; create the richedit control
  ; ---------------------------
    mov styl, WS_VISIBLE or WS_CHILDWINDOW or WS_CLIPSIBLINGS or \
              ES_MULTILINE or WS_VSCROLL or WS_HSCROLL or ES_AUTOHSCROLL or \
              ES_AUTOVSCROLL or ES_NOHIDESEL or ES_DISABLENOSCROLL

    invoke CreateWindowEx,WS_EX_LEFT,"RichEdit20a", \         ; WS_EX_STATICEDGE
             0,styl,0,0,200,100,hParent,111,instance,0

    mov pEdit, rax
  ; ---------------------------

    rcall SendMessage,pEdit,EM_EXLIMITTEXT,0,1000000000
    rcall SendMessage,pEdit,EM_SETOPTIONS,ECOOP_XOR,ECO_SELECTIONBAR

    mov hFont, rvcall(font_handle,"consolas",18,500)   ; library procedure
    rcall SendMessage,pEdit,WM_SETFONT,hFont,TRUE

    mov ecx, 10
    mov edx, 5
    mov ax, dx
    rol eax, 16
    mov ax, cx
    invoke SendMessage,pEdit,EM_SETMARGINS,EC_LEFTMARGIN or EC_RIGHTMARGIN,eax

    rcall SendMessage,pEdit,EM_SETTEXTMODE,TM_PLAINTEXT or \
                             TM_MULTILEVELUNDO or TM_MULTICODEPAGE, 0

    invoke SetWindowLongPtr,pEdit,GWL_WNDPROC,ADDR EditProc     ; subclass the rich edit control
    mov lpEditProc, rax

    mov rax, pEdit

    ret

 rich_edit endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

EditProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

  ; ------------------
  ; rich edit subclass
  ; ------------------

    .switch uMsg
      .case WM_CHAR
        .switch wParam
          .case 9
            rcall Do_Tabs, hWin, 4
            xor rax, rax                                    ; the tab is thrown away and
            ret                                             ; replaced with spaces via Do_Tabs
        .endsw

      .case WM_LBUTTONDBLCLK
        call get_word                                       ; selects a word with no spaces
        ret                                                 ; exit without default handler
    .endsw                                                  ; to avoid default selection

    invoke CallWindowProc,lpEditProc,hWin,uMsg,wParam,lParam

    ret

EditProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Do_Tabs proc Edit:QWORD,spcs:QWORD

  ; -----------------------------
  ; Edit is the richedit 3 handle
  ; spcs is the tab spaces count
  ; -----------------------------

    LOCAL indx  :QWORD
    LOCAL diff  :QWORD
    LOCAL bal   :QWORD
    LOCAL cr    :CHARRANGE
    LOCAL hsp   :QWORD

    invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    .if cr.cpMin ~= eax                                     ; if test is selected
      invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,chr$(0)   ; overwrite it with keystroke
      invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr         ; get the new selection
    .endif

    .if spcs == 0                                           ; test tab size
      mov spcs, 4                                           ; set a default tab size if zero
    .endif

    mov indx, rv(get_current_line_index,Edit)               ; get the current line index

    mov rax, indx
    .if cr.cpMin == eax                                     ; if start of line (indx = cr.cpMin)
      mov hsp, space$(spcs)
      rcall SendMessage,Edit,EM_REPLACESEL,TRUE,hsp         ; write "spcs" space count
      mfree hsp
      ret
    .else
      mov rax, indx
      sub cr.cpMin, eax                                     ; sub indx from cr.cpMin

      mov eax, cr.cpMin
      mrm diff, rax                                         ; store it in "diff"

      xor rdx, rdx                                          ; clear EDX
      mov rax, diff                                         ; diff in accumulator
      div WORD PTR spcs                                     ; diff \ spcs
      mov rcx, rdx                                          ; store remainder
      mul WORD PTR spcs                                     ; result * spcs
      mov rax, spcs                                         ; sub remainder from "spcs" size
      sub rax, rcx                                          ; balance in EAX
      mov bal, rax

      mov hsp, space$(bal)
      rcall SendMessage,Edit,EM_REPLACESEL,TRUE,hsp         ; replace selection with "bal" space count
      mfree hsp
      ret
    .endif

Do_Tabs endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

get_word proc

  ; -------------------------------------------------------
  ; called from rich edit subclass message WM_LBUTTONDBLCLK
  ; -------------------------------------------------------

    LOCAL cr    :CHARRANGE
    LOCAL tbuf  :QWORD
    LOCAL buff[1024]:BYTE
    LOCAL lnum  :QWORD
    LOCAL llen  :QWORD
    LOCAL indx  :QWORD
    LOCAL ptbl  :QWORD
    LOCAL cpMin1:DWORD
    LOCAL cpMin2:DWORD
    LOCAL diff   :QWORD
    LOCAL numst :QWORD
    LOCAL numnd :QWORD
    LOCAL rr12  :QWORD

    rcall SendMessage,hEdit,EM_EXGETSEL,0,ptr$(cr)
    mov eax, cr.cpMin
    mov cpMin1, eax

    mov lnum, rv(SendMessage,hEdit,EM_EXLINEFROMCHAR,0,cr.cpMin)    ; zero-based index of the line
    mov indx, rv(SendMessage,hEdit,EM_LINEINDEX,lnum,0)             ; line index
    mov llen, rv(SendMessage,hEdit,EM_LINELENGTH,cr.cpMin,0)        ; line length

    mov rax, indx
    mov cr.cpMin, eax                                               ; load cr.cpMin with the line index
    mov cr.cpMax, eax
    mov rax, llen
    add cr.cpMax, eax                                               ; load cr.cpMax with cr.cpMin + llen

    rcall SendMessage,hEdit,EM_EXSETSEL,0,ptr$(cr)                  ; set selection to the line

    mov tbuf, ptr$(buff)
    invoke SendMessage,hEdit,EM_GETSELTEXT,0,tbuf                   ; get selected text

    mov eax, cr.cpMin
    mov cpMin2, eax                                                 ; store cr.cpMin

    xor rax, rax
    mov eax, cpMin1                                                 ; the line start char
    sub eax, cpMin2                                                 ; the double click location

    mov diff, rax                                                   ; diff is the difference

  ; -------------------------------------------
  ; "tbuf" contains line of text to determine
  ; the start and end of the required selection
  ;
  ; numst     start number
  ; numnd     end number
  ; -------------------------------------------

    mov rr12, r12                                                   ; save r12

    lea r10, chtbl                                                  ; load the table address
    mov r11, tbuf                                                   ; load string address
    add r11, diff                                                   ; add the difference
    mov r12, diff                                                   ; load diff into r12

  lpst:
    sub r11, 1
    sub r12, 1
    movzx rax, BYTE PTR [r11]                                       ; load each byte
    cmp BYTE PTR [r10+rax], 0                                       ; test its character class
    je nxt
    jmp lpst

  nxt:
    mov numst, r12                                                  ; store the start offset
    add numst, 1                                                    ; correct for last sub

  lp2:
    add r11, 1
    add r12, 1
    movzx rax, BYTE PTR [r11]                                       ; load each byte
    cmp BYTE PTR [r10+rax], 0                                       ; test its character class
    je past
    jmp lp2

  past:
    mov numnd, r12                                                  ; store the end offset

    mov rax, indx                                                   ; start with the line index offset
    add rax, numst                                                  ; add the start number to it
    mov cr.cpMin, eax                                               ; copy DWORD result into cr.cpMin

    mov rax, indx                                                   ; start with the line index offset
    add rax, numnd                                                  ; add the end offset to it
    mov cr.cpMax, eax                                               ; copy DWORD result into cr.cpMax

    rcall SendMessage,hEdit,EM_EXSETSEL,0,ptr$(cr)                  ; set selection to the word

    mov r12, rr12                                                   ; restore r12

    xor rax, rax                                                    ; return 0 so default handler
    ret                                                             ; does not reset selection

    align 16
    chtbl:
    ; ---------------------------------------------
    ; upper and lower case, numbers and "_" "." "$"
    ; ---------------------------------------------
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0
      db 1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
      db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
      db 1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1
      db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
      db 1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

get_word endp

; �捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌�

get_current_line_index proc Edit:DWORD

  ; -------------------------------------------------
  ; the add and remove 1 space is to stop a loud DING
  ; when reaching the start or end of the line
  ; -------------------------------------------------

    USING r12, r13

    LOCAL begin :QWORD
    LOCAL cr    :CHARRANGE
    LOCAL urv   :QWORD

    SaveRegs

    invoke SendMessage,Edit,EM_EXGETSEL,0,ptr$(cr)           ; get original selection

    mov r12d, cr.cpMin                                      ; save CHARRANGE values
    mov r13d, cr.cpMax

    invoke SendMessage,Edit,WM_CHAR,32,0                    ; insert 1 space
    invoke SendMessage,Edit,WM_KEYDOWN,VK_HOME,0            ; send HOME key

    invoke SendMessage,Edit,EM_EXGETSEL,0,ptr$(cr)           ; get current select after HOME key

    mov eax, cr.cpMin
    mrm begin, rax                                          ; save it as the line beginning

    invoke SendMessage,Edit,WM_KEYDOWN,VK_END,0             ; send END key
    invoke SendMessage,Edit,WM_KEYDOWN,VK_BACK,0            ; delete the inserted space
    invoke SendMessage,Edit,EM_UNDO,0,0                     ; undo the last 2 keystrokes
    invoke SendMessage,Edit,EM_UNDO,0,0

    mov cr.cpMin, r12d                                      ; restore CHARRANGE values
    mov cr.cpMax, r13d

    invoke SendMessage,Edit,EM_EXSETSEL,0,ptr$(cr)           ; restore previous selection

    RestoreRegs

    mov rax, begin                                          ; return the line index

    ret

get_current_line_index endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 set_text_colour proc Edit:DWORD,txtcolour:DWORD

    .data?
      align 16
      cfm2 CHARFORMAT2 <?>
    .code

    mov cfm2.cbSize,            SIZEOF CHARFORMAT2
    mov cfm2.dwMask,            CFM_COLOR
    mov cfm2.dwEffects,         0
    mov cfm2.yHeight,           0
    mov cfm2.yOffset,           0
    mrmd cfm2.crTextColor,      txtcolour
    mov cfm2.bCharSet,          0
    mov cfm2.bPitchAndFamily,   0
    mov cfm2.szFaceName,        0
    mov cfm2.wWeight,           0
    mov cfm2.sSpacing,          0
    mov cfm2.crBackColor,       0
    mov cfm2.lcid,              0
    mov cfm2.dwReserved,        0
    mov cfm2.sStyle,            0
    mov cfm2.wKerning,          0
    mov cfm2.bUnderlineType,    0
    mov cfm2.bAnimation,        0
    mov cfm2.bRevAuthor,        0

    invoke PostMessage,Edit,EM_SETCHARFORMAT,SCF_ALL,ptr$(cfm2)

    ret

 set_text_colour endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 set_edit_colours proc

    rcall SendMessage,hEdit,EM_SETBKGNDCOLOR,0,bak_colour
    rcall set_text_colour,hEdit,txt_colour

    ret

 set_edit_colours endp

; �捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌�

NOSTACKFRAME

blank_count proc ptxt:QWORD

    sub rcx, 1
    xor rax, rax                                                ; zero counter
  ailbl:
    add rcx, 1
    cmp BYTE PTR [rcx], 32                                      ; test for space
    jne ainxt                                                   ; exit on non space
    add rax, 1                                                  ; increment counter on space
    jmp ailbl
  ainxt:

    ret

blank_count endp

STACKFRAME

; �捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌捌�

