
    IFNDEF MEMORYSTATUSEX
      MEMORYSTATUSEX STRUCT QWORD
        dwLength dd ?
        dwMemoryLoad dd ?
        ullTotalPhys dq ?
        ullAvailPhys dq ?
        ullTotalPageFile dq ?
        ullAvailPageFile dq ?
        ullTotalVirtual dq ?
        ullAvailVirtual dq ?
        ullAvailExtendedVirtual dq ?
      MEMORYSTATUSEX ENDS
    ENDIF

    SYSTEM_INFOx STRUCT QWORD
        UNION
        dwOemId dd ?
          STRUCT
            wProcessorArchitecture dw ?
            wReserved dw ?
          ENDS
        ENDS
      dwPageSize dd ?
      lpMinimumApplicationAddress dq ?
      lpMaximumApplicationAddress dq ?
      dwActiveProcessorMask dq ?
      dwNumberOfProcessors dd ?
      dwProcessorType dd ?
      dwAllocationGranularity dd ?
      wProcessorLevel dw ?
      wProcessorRevision dw ?
    SYSTEM_INFOx ENDS

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

    IFNDEF FINDTEXTEX
      FINDTEXTEX STRUCT QWORD
        chrg CHARRANGE <>
        lpstrText dq ?
        chrgText CHARRANGE <>
      FINDTEXTEX ENDS
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
                          TBSTYLE_TRANSPARENT or CCS_NODIVIDER, \
                          0,0,500,40, \
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


      space$ MACRO cnt
        LOCAL pmem                    ;; local is unique
        .data?
          pmem dq ?                   ;; unique variable for memory
        .code
        mov rax, cnt                  ;; copy cnt to rax
        add rax, 1                    ;; add 1 for terminator
        mov pmem, alloc(rax)          ;; allocate memory
        rcall char_fill,pmem,cnt,32   ;; fill memory with spaces
        mov rax, pmem                 ;; copy memory address to rax
        EXITM <rax>                   ;; return buffer address
      ENDM


    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBitmap   dq ?
      tbTile    dq ?
      hRebar    dq ?
      hToolBar  dq ?
      hStatus   dq ?
      hEdit     dq ?
      hMenu     dq ?

      pBuffer   db 260 dup (?)      ; allocate a buffer for the app path
      pPath     dq ?                ; app path pointer

    ; ---------------------
    ; search dialog handles
    ; ---------------------
      BtnUp     dq ?
      BtnDn     dq ?
      BtnQt     dq ?
      Chk1      dq ?
      Chk2      dq ?
      FndEd     dq ?
      RepEd     dq ?
      fImage    dq ?
      lpFndEdProc   dq ?            ; search dlg edit subclass
      lpFndEdProc1  dq ?            ; replace dlg 1st edit control subclass
      lpRepEdProc   dq ?            ; replace dlg 2nd edit control subclass

      lpEditProc    dq ?            ; main rich edit subclass

      RepBtn        dq ?            ; replace text dialog only

      hMMF      dq ?
      pMMF      dq ?
      PM_PATH   dq ?

      hBrush    dq ?
      bBordr    dq ?
      eColor    dq ?
      lColor    dq ?

    .data
      classname db "masm_edit_64_class",0
      caption   db "Untitled",0

    ; -------------------
    ; search option flags
    ; -------------------
      wwflag    dq 0                ; whole word flag
      csflag    dq 1                ; case sensitive flag
      sdflag    dq 1                ; search direction flag
      ssrch     dq 0                ; flag for single dialog

    ; --------------------
    ; replace option flags
    ; --------------------
      wwRep     dq 0                ; whole word flag
      csRep     dq 1                ; case sensitive flag
      sdRep     dq 0                ; search direction flag
