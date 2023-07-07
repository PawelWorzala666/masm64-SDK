; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 TBcreate proc parent:DWORD

  ; -----------------------------
  ; run to toolbar creation macro
  ; -----------------------------
    ToolbarInit tbbW, tbbH, parent

  ; -----------------------------------
  ; Add toolbar buttons and spaces here
  ; arg1 bmpID (zero based)
  ; arg2 cmdID (1st is 50)
  ; -----------------------------------
    TBbutton  0,  50
    TBbutton  1,  51
    TBbutton  2,  52
    TBspace
    TBbutton  3,  53
    TBbutton  4,  54
    TBbutton  5,  55
    TBspace
    TBbutton  6,  56
    TBbutton  7,  57
    TBspace
    TBbutton  8,  58
    TBbutton  9,  59
    TBspace
    TBbutton 10,  60
    TBbutton 11,  61
    TBspace
    TBbutton 12,  62
    TBbutton 13,  63

  ; -----------------------------------

    mov rax, tbhandl

    ret

 TBcreate endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 StatusBar proc hParent:QWORD

    LOCAL handl :QWORD
    LOCAL sbParts[4] :DWORD
    LOCAL r12reg :QWORD

    mov r12reg, r12

    mov handl, rv(CreateStatusWindow,WS_CHILD or WS_VISIBLE or SBS_SIZEGRIP,NULL,hParent,200)

  ; --------------------------------------------
  ; set the width of each part, -1 for last part
  ; --------------------------------------------

    lea r12, sbParts

    mov DWORD PTR [r12+0], 500
    mov DWORD PTR [r12+4], 700
    mov DWORD PTR [r12+8], 900
    mov DWORD PTR [r12+12],-1

    invoke SendMessage,handl,SB_SETPARTS,4,ADDR sbParts

    mov r12, r12reg
    mov rax, handl

    ret

 StatusBar endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 rebar proc instance:QWORD,hParent:QWORD,htrebar:QWORD

    LOCAL hrbar :QWORD

    fn CreateWindowEx,WS_EX_LEFT,"ReBarWindow32",NULL, \
                      WS_VISIBLE or WS_CHILD or \
                      WS_CLIPCHILDREN or WS_CLIPSIBLINGS or \
                      RBS_VARHEIGHT or CCS_NOPARENTALIGN or CCS_NODIVIDER, \
                      -2,0,sWid,htrebar,hParent,NULL,instance,NULL
    mov hrbar, rax

    rcall ShowWindow,hrbar,SW_SHOW
    rcall UpdateWindow,hrbar

    mov rax, hrbar

    ret

 rebar endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 addband proc instance:QWORD,hrbar:QWORD

    LOCAL tbhandl   :QWORD
    LOCAL rbbi      :REBARBANDINFO

    mov tbhandl, rv(TBcreate,hrbar)

    mov rbbi.cbSize,      sizeof REBARBANDINFO
    mov rbbi.fMask,       RBBIM_ID or RBBIM_STYLE or \
                          RBBIM_BACKGROUND or RBBIM_CHILDSIZE or RBBIM_CHILD
    mov rbbi.wID,         125
    mov rbbi.fStyle,      RBBS_FIXEDBMP
    mrm rbbi.hbmBack,     tbTile
    mov rbbi.cxMinChild,  0
    mrmd rbbi.cyMinChild, rbht
    mrm rbbi.hwndChild,   tbhandl

    invoke SendMessage,hrbar,RB_INSERTBAND,0,ADDR rbbi

    mov hToolTips, rv(SendMessage,tbhandl,TB_GETTOOLTIPS,0,0)

    invoke SendMessage,hToolTips,TTM_SETDELAYTIME,TTDT_INITIAL,0
    invoke SendMessage,hToolTips,TTM_SETDELAYTIME,TTDT_RESHOW,0

    mov rax, tbhandl

    ret

 addband endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい
