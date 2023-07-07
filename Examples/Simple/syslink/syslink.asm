; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hIcon     dq ?
      hLink1    dq ?
      hLink2    dq ?
      hLink3    dq ?

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

  ; -----------------------
  ; get the instance handle
  ; -----------------------
    mov hInstance, rv(GetModuleHandle,0)

  ; -------------------------------------------------------------
  ; set the icon loaded size here to match the original icon size
  ; -------------------------------------------------------------
    mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,32,32,LR_DEFAULTCOLOR)

  ; ---------------------
  ; create a modal dialog
  ; ---------------------
    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon

  ; --------------------------------
  ; terminate app when dialog closes
  ; --------------------------------
    invoke ExitProcess,0

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL hFont :QWORD
    LOCAL nmh   :NMHDR

    .switch uMsg
      .case WM_INITDIALOG
      ; ------------------------------------------------------
      ; lParam is the icon handle passed from DialogBoxParam()
      ; ------------------------------------------------------
        invoke SendMessage,hWin,WM_SETICON,1,lParam     ; set the icon for the dialog
        invoke SendMessage,rv(GetDlgItem,hWin,102), \   ; set the icon in the client area
               STM_SETIMAGE,IMAGE_ICON,lParam
        invoke SetWindowText,hWin,"SysLink Control"

        mov hFont, GetFontHandle("Arial",16,600)

        mov hLink1, rv(GetDlgItem,hWin,103)
        invoke SendMessage,hLink1,WM_SETFONT,hFont,TRUE

        mov hLink2, rv(GetDlgItem,hWin,104)
        invoke SendMessage,hLink2,WM_SETFONT,hFont,TRUE

        mov hLink3, rv(GetDlgItem,hWin,105)
        invoke SendMessage,hLink3,WM_SETFONT,hFont,TRUE

      ; ----------------------------------------------------
      ; set the focus to the first control by returning TRUE
      ; ----------------------------------------------------
        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 101
            jmp exit_dialog             ; The OK button
        .endsw

      .case WM_NOTIFY
        mov r11, lParam
        mov edx, (NMHDR PTR [r11])._code
        .if edx == NM_CLICK
          mov rcx, (NMHDR PTR [r11]).hwndFrom
          .if rcx == hLink1
            invoke ShellExecute,hWin,"open","www.masm32.com",0,0,SW_SHOW

          .elseif rcx == hLink2
            invoke ShellExecute,hWin,"open","https://msdn.microsoft.com/library",0,0,SW_SHOW

          .elseif rcx == hLink3
            .data
              intel db "http://www.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html"
            .code
            invoke ShellExecute,hWin,"open",ADDR intel,0,0,SW_SHOW

          .endif
        .endif

      .case WM_CLOSE
        exit_dialog:
        invoke EndDialog,hWin,0         ; exit from system menu
    .endsw

    xor rax, rax
    ret

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
