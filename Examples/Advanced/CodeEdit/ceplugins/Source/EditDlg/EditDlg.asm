; 姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣

    include \masm64\include64\masm64rt.inc

; 姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣

  ; -------------------------------------------
  ; Build this DLL with the provided MAKEIT.BAT
  ; -------------------------------------------

  ; --------------------------------------------------
  ; equates to control the text and background colours
  ; --------------------------------------------------
    txt_colour equ <00F0F0F0h>
    bak_colour equ <00202020h>

    include include.inc

    .data?
      hInstance   dq ?
      hWnd        dq ?
      hMenu       dq ?
      hEdit       dq ?
      hStatus     dq ?
      hToolbar    dq ?
      hIcon       dq ?
      hImage      dq ?

      lEdit       dq ?
      hFont       dq ?

      lpWndProc   dq ?                                            ; address of parent subclass proc

      hBrush      dq ?
      bBordr      dq ?
      eColor      dq ?
      lColor      dq ?

    .code

; 姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣

PluginEntryPoint proc instance:QWORD,reason:QWORD,unused:QWORD 

    .if reason == DLL_PROCESS_ATTACH
      mrm hInstance, instance                                       ; copy stack arg to global
      mov rax, TRUE                                                 ; return TRUE so DLL will start
    .endif

    ret

PluginEntryPoint endp

; 姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣姣

piInterface proc hWin:QWORD,Menu:QWORD,Edit:QWORD,tbar:QWORD,sbar:QWORD

  ; ------------------------------------
  ; load arguments into GLOBAL variables
  ; ------------------------------------
    mrm hWnd,     hWin
    mrm hMenu,    Menu
    mrm hEdit,    Edit
    mrm hToolbar, tbar
    mrm hStatus,  sbar

  ; --------------------
  ; dialog brush colours
  ; --------------------
    mov hBrush, rvcall(CreateSolidBrush,00222222h)      ; create the dialog background brush
    mov bBordr, rvcall(CreateSolidBrush,00222222h)      ; create the button border colour
    mov eColor, rvcall(CreateSolidBrush,00111111h)      ; create the Edit window back colour
    mov lColor, rvcall(CreateSolidBrush,00333333h)      ; create the list and combo back colour

  ; -------------------------------------------------------------
  ; set the icon loaded size here to match the original icon size
  ; -------------------------------------------------------------
    mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)

    invoke DialogBoxParam,hInstance,1000,0,ADDR DlgMain,hIcon

    ret

piInterface endp

; 中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中

DlgMain proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL cr:CHARRANGE
    LOCAL selln :QWORD
    LOCAL pMem  :QWORD
    LOCAL styl  :QWORD

    .switch uMsg
      .case WM_INITDIALOG
        rcall SendMessage,hWin,WM_SETICON,1,hIcon                   ; set the icon for the dialog

      ; ------------------
      ; rich edit settings
      ; ------------------
        rcall LoadLibrary,"riched20.dll"
        mov lEdit, rvcall(rich_edit,hWin,hInstance)





        invoke MoveWindow,lEdit,0,40,1100,380,TRUE

        rcall set_edit_colours,lEdit,txt_colour,bak_colour



      ; ------------------

      .case WM_SETFOCUS
        invoke SetFocus,lEdit

      .case WM_COMMAND
        .switch wParam
          .case 1004
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1005
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1006
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1007
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1008
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1009
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1010
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1011
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1012
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1013
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK
          .case 1014
            invoke MessageBox,hWin,str$(rax),"Title",MB_OK

          .case 1001                                            ; get selected text from CodeEdit
            rcall SendMessage,hEdit,EM_EXGETSEL,0,ptr$(cr)
            mov eax, cr.cpMax
            sub eax, cr.cpMin
            mov selln, rax
            mov pMem, alloc(selln)
            rcall SendMessage,hEdit,EM_GETSELTEXT,0,pMem
            rcall SetWindowText,lEdit,pMem
            mfree pMem

          .case 1003                                            ; set selected text to CodeEdit
            rcall select_all,lEdit
            mov selln, rvcall(GetWindowTextLength,lEdit)        ; get text length
            mov pMem, alloc(selln)                              ; allocate memory for it
            rcall SendMessage,lEdit,EM_GETSELTEXT,0,pMem        ; load selected text into memory
            rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,pMem     ; replace the selection in CodeEdit
            mfree pMem                                          ; free the memory

          .case 1002
            jmp exit_dialog             ; The OK button

        .endsw

      .case WM_CTLCOLORDLG
        mov rax, hBrush
        ret

      .case WM_CTLCOLORBTN                                      ; button border
        mov rax, bBordr
        ret

      .case WM_CTLCOLORSTATIC                                   ; static controls
        rcall SetBkColor,wParam,00222222h
        rcall SetTextColor,wParam,00FFFFFFh
        mov rax, hBrush
        ret

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0         ; exit from system menu
    .endsw

    xor rax, rax
    ret

DlgMain endp

; 中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中

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

; 中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中

set_edit_colours proc edit:QWORD,tcol:QWORD,bcol:QWORD

    invoke SendMessage,edit,EM_SETBKGNDCOLOR,0,bcol
    invoke set_text_colour,edit,tcol

    ret

set_edit_colours endp

; 中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中

 select_all proc edit:QWORD

    LOCAL cr    :CHARRANGE

    invoke GetWindowTextLength,edit

    mov cr.cpMin, 0                     ; start at offset 0
    mov cr.cpMax, eax                   ; finish at window text length

    invoke SendMessage,edit,EM_EXSETSEL,0,ADDR cr

    ret

 select_all endp

; 中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中

rich_edit proc hParent:QWORD,instance:QWORD

    LOCAL styl   :QWORD

  ; ---------------------------
  ; create the richedit control
  ; ---------------------------
    mov styl, WS_VISIBLE or WS_CHILDWINDOW or WS_CLIPSIBLINGS or \
              ES_MULTILINE or WS_VSCROLL or WS_HSCROLL or ES_AUTOHSCROLL or \
              ES_AUTOVSCROLL or ES_NOHIDESEL or ES_DISABLENOSCROLL

    invoke CreateWindowEx,WS_EX_LEFT,"RichEdit20a", \         ; WS_EX_STATICEDGE
           0,styl,0,0,200,100,hParent,111,instance,0

    mov lEdit, rax
  ; ---------------------------

    invoke SendMessage,lEdit,EM_EXLIMITTEXT,0,1000000000
    invoke SendMessage,lEdit,EM_SETOPTIONS,ECOOP_XOR,ECO_SELECTIONBAR

    mov hFont, rvcall(font_handle,"consolas",18,500)   ; library procedure
    rcall SendMessage,lEdit,WM_SETFONT,hFont,TRUE

    mov ecx, 10
    mov edx, 5
    mov ax, dx
    rol eax, 16
    mov ax, cx
    invoke SendMessage,lEdit,EM_SETMARGINS,EC_LEFTMARGIN or EC_RIGHTMARGIN,eax

    invoke SendMessage,lEdit,EM_SETTEXTMODE,TM_PLAINTEXT or \
                             TM_MULTILEVELUNDO or TM_MULTICODEPAGE, 0
    mov rax, lEdit

    ret

rich_edit endp

; 中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中中

    end
