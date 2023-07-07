; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    ; -------------------------------------------
    ; Build this DLL with the provided MAKEIT.BAT
    ; -------------------------------------------

      .data?
        hInstance   dq ?
        hWnd        dq ?
        hMenu       dq ?
        hEdit       dq ?
        hStatus     dq ?
        hToolbar    dq ?
        hIcon       dq ?
        hImage      dq ?
        lpWndProc   dq ?                                            ; address of parent subclass proc

        hBrush      dq ?
        bBordr      dq ?
        eColor      dq ?
        lColor      dq ?

      .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

PluginEntryPoint proc instance:QWORD,reason:QWORD,unused:QWORD 

    .if reason == DLL_PROCESS_ATTACH
      mrm hInstance, instance                                       ; copy stack arg to global
      mov rax, TRUE                                                 ; return TRUE so DLL will start
    .endif

    ret

PluginEntryPoint endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

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

    rcall DrawPluginMenu

    invoke SetWindowLongPtr,hWnd,GWL_WNDPROC,ADDR WndProc           ; subclass the parent window
    mov lpWndProc, rax

    ret

piInterface endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

DrawPluginMenu proc

    LOCAL mStyle    :QWORD                                          ; menu style settings
    LOCAL hSelct    :QWORD                                          ; selection menu handle
    LOCAL eMenu     :QWORD                                          ; edit menu handle
    LOCAL hHelp     :QWORD                                          ; help menu handle
    LOCAL hText     :QWORD                                          ; text menu handle

    mov mStyle, MF_BYPOSITION or MF_STRING or MF_POPUP              ; menu styles

  ; -----------------------------------
  ; appended to existing resource menus
  ; do these first as they are known.
  ; -----------------------------------
    mov eMenu, rvcall(GetSubMenu,hMenu,1)                           ; get the EDIT menu handle
    rcall AppendMenu,eMenu,MF_SEPARATOR,eMenu,0
    rcall AppendMenu,eMenu,mStyle,2002,"Select All"

    mov hHelp, rvcall(GetSubMenu,hMenu,5)                           ; get the HELP menu handle
    rcall AppendMenu,hHelp,MF_SEPARATOR,hHelp,0
    rcall AppendMenu,hHelp,mStyle,2005,"About cplugin DLL"

  ; -------------------------------------------------------
  ; create and insert new headings and append items to them
  ; -------------------------------------------------------
    mov hText, rvcall(CreatePopupMenu)
    invoke InsertMenu,hMenu,5,mStyle,hText,"Text"                   ; the TEXT menu bar heading

    rcall AppendMenu,hText,mStyle,2010,"Insert Comment Line"
    rcall AppendMenu,hText,MF_SEPARATOR,hText,0
    rcall AppendMenu,hText,mStyle,2011,"Insert NOSTACKFRAME"
    rcall AppendMenu,hText,mStyle,2012,"Insert STACKFRAME"
    rcall AppendMenu,hText,MF_SEPARATOR,hText,0
    rcall AppendMenu,hText,mStyle,2013,"Insert MessageBox"
  ; -------------------------------------------------------
    mov hSelct, rvcall(CreatePopupMenu)
    invoke InsertMenu,hMenu,5,mStyle,hSelct,"Selection"             ; the SELECTION menu bar heading

    rcall AppendMenu,hSelct,mStyle,2000,"Selection To Lower Case"
    rcall AppendMenu,hSelct,mStyle,2001,"Selection To Upper Case"
    rcall AppendMenu,hSelct,MF_SEPARATOR,hSelct,0
    rcall AppendMenu,hSelct,mStyle,2003,"Left Trim Selection"
    rcall AppendMenu,hSelct,mStyle,2004,"Right Trim Selection"
  ; -------------------------------------------------------

    rcall DrawMenuBar,hWnd

    ret

DrawPluginMenu endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

; ----------------------------------------------------------------------
; Message processing for the menu items by subclassing the parent window
; ----------------------------------------------------------------------

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case 2000
            call lower_case
          .case 2001
            call upper_case
          .case 2002
            rcall select_all,hEdit
          .case 2003
            call left_trim
          .case 2004
            call right_trim
          .case 2005
          ; ---------------------
          ; create a modal dialog
          ; ---------------------
            invoke DialogBoxParam,hInstance,1000,0,ADDR DlgMain,hIcon

          .case 2010
            .data
              txtline db "; **************************************************************************************************",13,10,0
              ptline dq txtline
            .code
            rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,ptline

          .case 2011
            .data
              nsfm db "NOSTACKFRAME",13,10,0
              pnsm dq nsfm
            .code
            rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,pnsm

          .case 2012
            .data
              stfm db "STACKFRAME",13,10,0
              pstm dq stfm
            .code
            rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,pstm

          .case 2013
            .data
              bsgb db "    rcall MessageBox,hWnd,str$(rax),",34,"Title",34,",MB_OK",13,10,0
              pmbx dq bsgb
            .code
            rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,pmbx

          .case 2020

        .endsw

      .case WM_DESTROY
        rcall ExitProcess                                           ; clean exit from DLL

    .endsw

    invoke CallWindowProc,lpWndProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 lower_case proc

    LOCAL cr    :CHARRANGE
    LOCAL ptxt  :QWORD
    LOCAL tlen  :QWORD
    LOCAL pMem  :QWORD

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr                  ; get the character range

    mov eax, cr.cpMax
    sub eax, cr.cpMin
    mov tlen, rax                                                   ; selection length

    mov pMem, alloc(tlen)

    invoke SendMessage,hEdit,EM_GETSELTEXT,0,pMem                   ; current line written to tbuf

    invoke szLower,pMem

    mov pMem, rax

    invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,pMem                ; set the character range

    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr                  ; get the character range

    mfree pMem

    ret

 lower_case endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 upper_case proc

    LOCAL cr    :CHARRANGE
    LOCAL ptxt  :QWORD
    LOCAL tlen  :QWORD
    LOCAL pMem  :QWORD

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr                  ; get the character range

    mov eax, cr.cpMax
    sub eax, cr.cpMin
    mov tlen, rax                                                   ; selection length

    mov pMem, alloc(tlen)

    invoke SendMessage,hEdit,EM_GETSELTEXT,0,pMem                   ; current line written to tbuf

    invoke szUpper,pMem

    mov pMem, rax

    invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,pMem                ; set the character range

    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr                  ; get the character range

    mfree pMem

    ret

 upper_case endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 select_all proc edit:QWORD

    LOCAL cr    :CHARRANGE

    invoke GetWindowTextLength,edit

    mov cr.cpMin, 0                                                 ; start at offset 0
    mov cr.cpMax, eax                                               ; finish at window text length

    invoke SendMessage,edit,EM_EXSETSEL,0,ADDR cr

    ret

 select_all endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 left_trim proc

    LOCAL cr    :CHARRANGE
    LOCAL hMem  :QWORD
    LOCAL tlen  :QWORD

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    cmp cr.cpMin, eax
    jne @F
    invoke MessageBox,hWnd,"Please select the block of text you wish to left trim","No Selection",MB_OK
    ret
  @@:

    mov eax, cr.cpMax                                               ; load cr.cpMax
    sub eax, cr.cpMin                                               ; sub cr.cpMin to get selection length
    mov hMem, alloc(rax)                                            ; allocate selected length

    invoke SendMessage,hEdit,EM_GETSELTEXT,0,hMem                   ; load selection into memory

    rcall block_ltrim_Ex, hMem                                      ; left trim selection
    mov tlen, rax

    mov eax, cr.cpMin                                               ; get the selection start
    add rax, tlen                                                   ; add new length to it
    mov cr.cpMax, eax                                               ; reset cr.cpMax to new length

    invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,hMem                ; replace the selection
    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr                  ; set new selection

    mfree hMem                                                      ; release allocated memory

    ret

 left_trim endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 NOSTACKFRAME

 block_ltrim_Ex proc

  ; ----------------------------------------------
  ; source address is in "rcx"
  ; trim leading tabs and spaces on multiple lines
  ; of source and overwrite it with the results.
  ; ----------------------------------------------

    mov rax, rcx                                                    ; source in rax
    mov r10, rcx                                                    ; same address as target
    sub r10, 1

  trimleft:
    add r10, 1
    cmp BYTE PTR [r10], 32                                          ; loop back on space
    je trimleft
    cmp BYTE PTR [r10], 9                                           ; loop back on tab
    je trimleft
    sub r10, 1

  store:
    add r10, 1
    movzx rdx, BYTE PTR [r10]                                       ; copy byte
    mov [rax], dl
    add rax, 1
    test dl, dl                                                     ; test for written terminator
    jz bl_out                                                       ; exit on terminator
    sub dl, 13                                                      ; test for ascii 10
    jnz store
    jmp trimleft

  bl_out:
    sub rax, rcx                                                    ; sub rcx from rax
    sub rax, 1                                                      ; exclude additional trailing zero

    ret

 block_ltrim_Ex endp

 STACKFRAME

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 right_trim proc

    LOCAL cr    :CHARRANGE
    LOCAL hMem  :QWORD
    LOCAL tlen  :QWORD

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr

    mov eax, cr.cpMax
    cmp cr.cpMin, eax
    jne @F
    invoke MessageBox,hWnd,"Please select the block of text you wish to right trim","No Selection",MB_OK
    ret
  @@:

    mov eax, cr.cpMax                                               ; load cr.cpMax
    sub eax, cr.cpMin                                               ; sub cr.cpMin to get selection length
    mov hMem, alloc(rax)                                            ; allocate selected length

    invoke SendMessage,hEdit,EM_GETSELTEXT,0,hMem                   ; load selection into memory

    rcall block_rtrim, hMem                                         ; right trim selection
    mov tlen, len(hMem)                                             ; get the post modified text length

    mov eax, cr.cpMin                                               ; get the selection start
    add rax, tlen                                                   ; add new length to it
    mov cr.cpMax, eax                                               ; reset cr.cpMax to new length

    invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,hMem                ; replace the selection
    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr                  ; set new selection

    mfree hMem                                                      ; release allocated memory

    ret

 right_trim endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

DlgMain proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_INITDIALOG
        rcall SendMessage,hWin,WM_SETICON,1,hIcon                   ; set the icon for the dialog
        mov hImage, rvcall(GetDlgItem,hWin,1002)                    ; static control container
        rcall SendMessage,hImage,STM_SETIMAGE,IMAGE_ICON,hIcon      ; set icon to static control
        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 1001
            jmp exit_dialog             ; The OK button
        .endsw

      .case WM_CTLCOLORDLG
        mov rax, hBrush
        ret

      .case WM_CTLCOLORBTN                                          ; button border
        mov rax, bBordr
        ret

      .case WM_CTLCOLORSTATIC                                       ; static controls
        rcall SetBkColor,wParam,00222222h
        rcall SetTextColor,wParam,00FFFFFFh
        mov rax, hBrush
        ret

 ;       .case WM_CTLCOLOREDIT                                         ; edit controls if needed
 ;         rcall SetBkColor,wParam,00111111h
 ;         rcall SetTextColor,wParam,00FFFFFFh
 ;         mov rax, eColor
 ;         ret

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0                                      ; exit from system menu
    .endsw

    xor rax, rax
    ret

DlgMain endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
