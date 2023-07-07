; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

    include \masm64\include64\masm64rt.inc

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

  ; -------------------------------------------
  ; Build this DLL with the provided MAKEIT.BAT
  ; -------------------------------------------

    .data?
      hInstance     dq ?
      hIcon         dq ?
      hWnd          dq ?
      hMenu         dq ?
      hEdit         dq ?
      hStatus       dq ?
      hToolbar      dq ?
      hList         dq ?
      hButn1        dq ?
      lpListProc    dq ?   ; address of default subclass procedure

      hBrush        dq ?
      bBordr        dq ?
      eColor        dq ?
      lColor        dq ?

    .data
      lpth db ".",0
      ppth dq lpth

    .code

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

PluginEntryPoint proc instance:QWORD,reason:QWORD,unused:QWORD 

    .if reason == DLL_PROCESS_ATTACH
      mrm hInstance, instance                                       ; copy stack arg to global
      mov rax, TRUE                                                 ; return TRUE so DLL will start
    .endif

    ret

PluginEntryPoint endp

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

piInterface proc hWin:QWORD,Menu:QWORD,Edit:QWORD,tbar:QWORD,sbar:QWORD

  ; ------------------------------------
  ; load arguments into GLOBAL variables
  ; ------------------------------------
    mrm hWnd,     hWin
    mrm hMenu,    Menu
    mrm hEdit,    Edit
    mrm hToolbar, tbar
    mrm hStatus,  sbar

    mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)

  ; --------------------
  ; dialog brush colours
  ; --------------------
    mov hBrush, rvcall(CreateSolidBrush,00222222h)      ; create the dialog background brush
    mov bBordr, rvcall(CreateSolidBrush,00222222h)      ; create the button border colour
    mov eColor, rvcall(CreateSolidBrush,00111111h)      ; create the Edit window back colour
    mov lColor, rvcall(CreateSolidBrush,00111111h)      ; create the list and combo back colour

    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon

    ret

piInterface endp

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL csel  :QWORD
    LOCAL pbuf  :QWORD
    LOCAL buff[260]:BYTE

    .switch uMsg
      .case WM_INITDIALOG
      ; ------------------------------------------------------
      ; lParam is the icon handle passed from DialogBoxParam()
      ; ------------------------------------------------------
        mrm hWnd, hWin
        rcall SendMessage,hWin,WM_SETICON,1,lParam                  ; set the icon for the dialog
        rcall SendMessage,rvcall(GetDlgItem,hWin,103), \            ; set the icon in the client area
               STM_SETIMAGE,IMAGE_ICON,lParam
        rcall SetWindowText,hWin,"File List Box"

        mov hButn1, rvcall(GetDlgItem,hWin,101)
        rcall EnableWindow,hButn1,FALSE                             ; start button disabled

        mov hList, rvcall(GetDlgItem,hWin,104)                      ; get the list box handle
        invoke SetWindowLongPtr,hList, \
               GWL_WNDPROC,ADDR ListProc                            ; subclass the list box
        mov lpListProc, rax

        invoke DlgDirList,hWin,ppth,104,hList,DDL_ARCHIVE           ; load list box with file names

        .return TRUE

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

          .case WM_CTLCOLORLISTBOX                                       ; static controls
            rcall SetBkColor,wParam,00222222h
            rcall SetTextColor,wParam,00FFFFFFh
            mov rax, lColor
            ret

      .case WM_COMMAND
        .switch wParam
          .case 101
            mov pbuf, ptr$(buff)                                    ; get pointer to buffer
            mov csel, rvcall( SendMessage,hList,LB_GETCURSEL,0,0)   ; get the current selection
            rcall SendMessage,hList,LB_GETTEXT,csel,pbuf            ; get the text at that selection

          ; -------------------------------
          ; selected file name is in "pbuf"
          ; -------------------------------
            invoke MessageBox,hWnd,pbuf,"Title",MB_OK

          .case 102
            jmp exit_dialog                                         ; The Cancel button

        .endsw

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0                                      ; exit from system menu
    .endsw

    xor rax, rax
    ret

main endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

ListProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_LBUTTONDOWN
        rcall EnableWindow,hButn1,TRUE                              ; enable the button

      .case WM_LBUTTONDBLCLK
        rcall SendMessage,hWnd,WM_COMMAND,101,0                     ; activate WM_COMMAND message
    .endsw

    invoke CallWindowProc,lpListProc,hWin,uMsg,wParam,lParam

    ret

ListProc endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    end
