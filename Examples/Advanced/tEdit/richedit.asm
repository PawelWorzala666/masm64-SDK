; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 rich_edit proc hParent:QWORD,instance:QWORD

    LOCAL pEdit  :QWORD
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

    mov ecx, 10
    mov edx, 5
    mov ax, dx
    rol eax, 16
    mov ax, cx
    invoke SendMessage,pEdit,EM_SETMARGINS,EC_LEFTMARGIN or EC_RIGHTMARGIN,eax

    rcall SendMessage,pEdit,EM_SETTEXTMODE,TM_PLAINTEXT or \
                             TM_MULTILEVELUNDO or TM_MULTICODEPAGE, 0
    mov rax, pEdit

    ret

 rich_edit endp

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

    invoke PostMessage,Edit,EM_SETCHARFORMAT,SCF_ALL,ADDR cfm2

    ret

 set_text_colour endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 set_edit_colours proc

    rcall SendMessage,hEdit,EM_SETBKGNDCOLOR,0,bak_colour
    rcall set_text_colour,hEdit,txt_colour

    ret

 set_edit_colours endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 select_all proc edit:QWORD

    LOCAL cr    :CHARRANGE

    invoke GetWindowTextLength,edit

    mov cr.cpMin, 0                     ; start at offset 0
    mov cr.cpMax, eax                   ; finish at window text length

    invoke SendMessage,edit,EM_EXSETSEL,0,ADDR cr

    ret

 select_all endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

is_selected proc

    LOCAL cr    :CHARRANGE

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    cmp cr.cpMin, eax                   ; if equal, no selection
    jne OK

    invoke MsgboxI,hWnd,"Please select the text you wish to modify.","No Text To Work On",MB_OK,10

    xor rax, rax                        ; return 0 if no selection
    ret

  OK:
    mov rax, 1                          ; return NON 0 on selection
    ret

is_selected endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

set_lcase proc

    LOCAL cr   :CHARRANGE
    LOCAL ln   :QWORD
    LOCAL pMem :QWORD

    rcall SendMessage,hEdit,EM_EXGETSEL,0,ptr$(cr)
    mov eax, cr.cpMax
    sub eax, cr.cpMin
    mov ln, rax

    mov pMem, alloc(ln)
    rcall SendMessage,hEdit,EM_GETSELTEXT,0,pMem
    rcall szLower,pMem
    rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,pMem
    mfree pMem

    rcall SendMessage,hEdit,EM_EXSETSEL,0,ptr$(cr)

    ret

set_lcase endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

set_ucase proc

    LOCAL cr   :CHARRANGE
    LOCAL ln   :QWORD
    LOCAL pMem :QWORD

    rcall SendMessage,hEdit,EM_EXGETSEL,0,ptr$(cr)
    mov eax, cr.cpMax
    sub eax, cr.cpMin
    mov ln, rax

    mov pMem, alloc(ln)
    rcall SendMessage,hEdit,EM_GETSELTEXT,0,pMem
    rcall szUpper,pMem
    rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,pMem
    mfree pMem

    rcall SendMessage,hEdit,EM_EXSETSEL,0,ptr$(cr)

    ret

set_ucase endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

get_current_line_index proc Edit:QWORD

  ; -------------------------------------------------
  ; the add and remove 1 space is to stop a loud DING
  ; when reaching the start or end of the line
  ; -------------------------------------------------
    LOCAL begin   :QWORD
    LOCAL cr      :CHARRANGE
    LOCAL urv     :QWORD
    LOCAL cpMin   :DWORD
    LOCAL cpMax   :DWORD

    invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr           ; get original selection

    mov eax, cr.cpMin
    mov cpMin, eax
    mov eax, cr.cpMax
    mov cpMax, eax

    invoke SendMessage,Edit,WM_CHAR,32,0                    ; insert 1 space
    invoke SendMessage,Edit,WM_KEYDOWN,VK_HOME,0            ; send HOME key

    invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr           ; get current select after HOME key

    mov eax, cr.cpMin
    mov begin, rax                                          ; save it as the line beginning

    invoke SendMessage,Edit,WM_KEYDOWN,VK_END,0             ; send END key
    invoke SendMessage,Edit,WM_KEYDOWN,VK_BACK,0            ; delete the inserted space
    invoke SendMessage,Edit,EM_UNDO,0,0                     ; undo the last 2 keystrokes
    invoke SendMessage,Edit,EM_UNDO,0,0

    mov eax, cpMin
    mov cr.cpMin, eax
    mov eax, cpMax
    mov cr.cpMax, eax

    invoke SendMessage,Edit,EM_EXSETSEL,0,ADDR cr           ; restore previous selection

    mov rax, begin                                          ; return the line index

    ret

get_current_line_index endp

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

    .if rv(is_text_selected) == 1                           ; exit if text selected
      ret
    .endif

    mov psp, ptr$(spbuf)

    invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    .if cr.cpMin ~= eax                                     ; if test is selected
      invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,chr$(0)   ; overwrite it with keystroke
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

