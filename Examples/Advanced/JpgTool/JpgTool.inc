
      IfRepeatKey MACRO vk_key
        invoke GetAsyncKeyState,vk_key
        and eax, 00000000000000001000000000000000b
        rol eax, 17
        cmp eax, 1
      ENDM

    ; -------------------------------------------------------------
    ; equates for controlling the toolbar button size and placement
    ; -------------------------------------------------------------
      rbht     equ <42>               ; rebar height in pixels
      tbbW     equ <32>               ; toolbar button width in pixels
      tbbH     equ <32>               ; toolbar button height in pixels
      vpad     equ <12>               ; vertical button padding in pixels
      hpad     equ <20>               ; horizontal button padding in pixels
      lind     equ <10>               ; left side initial indent in pixels

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
                          TBSTYLE_TRANSPARENT or TBSTYLE_TOOLTIPS or CCS_NODIVIDER, \
                          0,0,500,40, \
                          parent,NULL, \
                          hInstance,NULL
        mov tbhandl, rax

        mov hToolTips, rv(SendMessage,tbhandl,TB_GETTOOLTIPS,0,0)

        invoke SendMessage,hToolTips,TTM_SETDELAYTIME,TTDT_INITIAL,0
        invoke SendMessage,hToolTips,TTM_SETDELAYTIME,TTDT_RESHOW,0

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

        mov rax, tbBmp
        mov tbab.nID, eax

        invoke SendMessage,tbhandl,TB_ADDBITMAP,12,ADDR tbab

        mov tbb.fsState,   TBSTATE_ENABLED
        mov tbb.dwData,    0
        mov tbb.iString,   0

      ENDM

      KeyDown    equ <rcall keydown,>
      KeyUp      equ <rcall keyup,>


    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBitmap   dq ?
      tbBmp     dq ?                ; this variable is used in the toolbar macro code
      tbTile    dq ?
      hRebar    dq ?
      hToolBar  dq ?
      hStatus   dq ?
      hFont1    dq ?
      hFont2    dq ?

    ; ----------------------
    ; About dialog variables
    ; ----------------------
      lbl1      dq ?
      lbl2      dq ?
      lbl3      dq ?
      lbl4      dq ?
      lbl5      dq ?
      lbl6      dq ?
      aButn1    dq ?
    ; ----------------------

      hImgBox   dq ?                ; static control image handle

      jEdit1    dq ?                ; edit handles for JPG dialog
      jEdit2    dq ?

      lpjEdit1Proc dq ?             ; JPG dialog subclass procedure
      lpjEdit2Proc dq ?             ; JPG dialog subclass procedure

      hText1    dq ?                ; edit handles
      hText2    dq ?
      lpText1Proc dq ?
      lpText2Proc dq ?

      hlbl1     dq ?                ; static controls
      hlbl2     dq ?

      titlebuff db 260 dup (?)      ; buffer to store titlebar text
      hToolTips dq ?

      defwid    dq ?

      wRct      RECT <?>
      pt        POINT <?>

      rleft     dd ?
      rtop      dd ?
      rright    dd ?
      rbottom   dd ?

      capflag   dq ?

    .data
      jscale    dq 100
      jqlity    dq 100
      oFlag     dq 0                ; GLOBAL file open flag

      oWid      dq 1920
      oHgt      dq 1080

      ptitle    dq titlebuff        ; titlebar pointer
      classname db "jpg_tool_class",0
      caption db "JPG Tool",0

    .code

    STACKFRAME 256,256,1024

    include fileio.asm
    include tbsbcode.asm
    include dlgcode.asm             ; included source code must be in the code section

