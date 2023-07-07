
  ; --------------------------------------
    include \masm64\include64\masm64rt.inc
  ; --------------------------------------

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

    ; //////////////////////////////////////////////////////////////////////////////////////////////

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
        mLOCAL tbstyle   :QWORD

        fn CreateWindowEx,0,"ToolbarWindow32", \
                          ADDR caption, \
                          TBSTYLE_FLAT or TBSTYLE_TRANSPARENT or TBSTYLE_TOOLTIPS or \
                          WS_CHILD or WS_VISIBLE or TBSTYLE_FLAT or TBSTYLE_TRANSPARENT or CCS_NODIVIDER, \
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

    ; //////////////////////////////////////////////////////////////////////////////////////////////

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCopy     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBitmap   dq ?
      tbTile    dq ?
      hRebar    dq ?
      hToolBar  dq ?
      hStatus   dq ?
      hEdit     dq ?
      hFont     dq ?
      dFont     dq ?
      hToolTips dq ?
      btFlag    dq ?


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
      lpFndEdProc   dq ?        ; search dlg edit subclass
      lpFndEdProc1  dq ?        ; replace dlg 1st edit control subclass
      lpRepEdProc   dq ?        ; replace dlg 2nd edit control subclass

      RepBtn    dq ?            ; replace text dialog only
      BaseDir   db 260 dup (?)  ; buffer for application path
      NameBuff  db 260 dup (?)  ; buffer for persistent title bar text
      PassFile  db 260 dup (?)  ; file name to pass to threads

      ldThread dq ?             ; thread handles
      svThread dq ?
      tID1     dq ?             ; thread IDs
      tID2     dq ?

      PM_LOADDONE dq ?          ; private messages for thread suspend signalling
      PM_SAVEDONE dq ?

    ; //////////////////////////////////////////////////////////////////////////////////////////////

    .data
      pBase     dq BaseDir      ; pointer to application path
      ptitle    dq NameBuff     ; pointer to name buffer
      pFile     dq PassFile     ; pointer to file name passed to threads
      classname db "masm64_tEdit_class",0
      caption   db "Untitled",0

    ; -------------------
    ; search option flags
    ; -------------------
      wwflag    dq 0            ; whole word flag
      csflag    dq 1            ; case sensitive flag
      sdflag    dq 1            ; search direction flag
      ssrch     dq 0            ; flag for single dialog

    ; --------------------
    ; replace option flags
    ; --------------------
      wwRep     dq 0            ; whole word flag
      csRep     dq 1            ; case sensitive flag
      sdRep     dq 0            ; search direction flag

    ; //////////////////////////////////////////////////////////////////////////////////////////////

    .code                       ; included source files must be in the code section

    include fileio.asm
    include search.asm
    include richedit.asm
    include about.asm
    include toolbar.asm
    include algorithms.asm
