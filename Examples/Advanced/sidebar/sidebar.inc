
    IFNDEF CHARFORMAT2
      CHARFORMAT2 STRUCT QWORD
        cbSize dd ?
        dwMask dd ?
        dwEffects dd ?
        yHeight dd ?
        yOffset dd ?
        crTextColor dd ?
        bCharSet db ?
        bPitchAndFamily db ?
        szFaceName db LF_FACESIZE dup (?)
        wWeight dw ?
        sSpacing dw ?
        crBackColor dd ?
        lcid dd ?
        dwReserved dd ?
        sStyle dw ?
        wKerning dw ?
        bUnderlineType db ?
        bAnimation db ?
        bRevAuthor db ?
      CHARFORMAT2 ENDS
    ENDIF

      IfRepeatKey MACRO vk_key
        invoke GetAsyncKeyState,vk_key
        and eax, 00000000000000001000000000000000b
        rol eax, 17
        cmp eax, 1
      ENDM

    ; ---------------------------
    ; macros for creating toolbar
    ; ---------------------------

      TBbutton MACRO bID, cID
        mov tbb.iBitmap,   bID  ;; button  ID number
        mov tbb.idCommand, cID  ;; command ID number
        mov tbb.fsStyle,   TBSTYLE_BUTTON
        invoke SendMessage,tbhandl,TB_ADDBUTTONS,1,ADDR tbb
      ENDM

    ; ------------------------------

      TBspace MACRO
        mov tbb.iBitmap,   0
        mov tbb.idCommand, 0
        mov tbb.fsStyle,   TBSTYLE_SEP
        invoke SendMessage,tbhandl,TB_ADDBUTTONS,1,ADDR tbb
      ENDM

    ; ------------------------------

      mLOCAL equ <LOCAL>

      ToolbarInit MACRO Wd, Ht, parent

        mLOCAL tbhandl   :QWORD
        mLOCAL bSize     :DWORD
        mLOCAL tbab      :TBADDBITMAP
        mLOCAL tbb       :TBBUTTON

        fn CreateWindowEx,0,"ToolbarWindow32", \
                          ADDR caption, \
                          WS_CHILD or WS_VISIBLE or TBSTYLE_FLAT or \
                          TBSTYLE_TRANSPARENT or CCS_NODIVIDER or TBSTYLE_WRAPABLE or CCS_VERT, \
                          0,0,50,2048, \
                          parent,NULL, \
                          hInstance,NULL
        mov tbhandl, rax

      ; ------------------------------------------------------------------
      ; set vertical and horizontal padding for buttons (units are pixels)
      ; ------------------------------------------------------------------
        mov ax, vpad            ; vertical padding
        rol eax, 16
        mov ax, hpad            ; horizontal padding
        invoke SendMessage,tbhandl,TB_SETPADDING,0,eax

        invoke SendMessage,tbhandl,TB_BUTTONSTRUCTSIZE,sizeof TBBUTTON,0
    
      ; ---------------------------------------
      ; Put width & height of bitmap into DWORD
      ; ---------------------------------------
        mov  ecx,Wd  ;; loword = bitmap Width
        mov  eax,Ht  ;; hiword = bitmap Height
        shl  eax,16
        mov  ax, cx

        mov bSize, eax

        invoke SendMessage,tbhandl,TB_SETBITMAPSIZE,0,bSize
        invoke SendMessage,tbhandl,TB_SETBUTTONSIZE,0,bSize

      ; --------------------------------------------------------
      ; set left side indent for first button (units are pixels)
      ; --------------------------------------------------------
        invoke SendMessage,tbhandl,TB_SETINDENT,lind,0
        
        mov tbab.hInst, 0

        mov rax, hBitmap
        mov tbab.nID, eax

        invoke SendMessage,tbhandl,TB_ADDBITMAP,12,ADDR tbab

        mov tbb.fsState,   TBSTATE_ENABLED
        mov tbb.dwData,    0
        mov tbb.iString,   0

      ENDM

