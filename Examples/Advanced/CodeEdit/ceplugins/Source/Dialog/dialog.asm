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

    invoke DialogBoxParam,hInstance,1000,0,ADDR DlgMain,hIcon

    ret

piInterface endp

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

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0         ; exit from system menu
    .endsw

    xor rax, rax
    ret

DlgMain endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
