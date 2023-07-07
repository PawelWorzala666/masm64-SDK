; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hIcon     dq ?
      radio1    dq ?
      radio2    dq ?
      radio3    dq ?
      radio4    dq ?
      static    dq ?

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    mov hInstance, rv(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,32,32,LR_DEFAULTCOLOR)

    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon    ; modal dialog

    invoke ExitProcess,0

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_INITDIALOG
      ; ------------------------------------------------------
      ; lParam is the icon handle passed from DialogBoxParam()
      ; ------------------------------------------------------
        invoke SendMessage,hWin,WM_SETICON,1,lParam     ; set the icon for the dialog
        invoke SendMessage,rv(GetDlgItem,hWin,108), \   ; set the icon in the client area
               STM_SETIMAGE,IMAGE_ICON,lParam

        invoke SetWindowText,hWin,"Radio Button Dialog"

        mov radio1, rv(GetDlgItem,hWin,102)
        mov radio2, rv(GetDlgItem,hWin,103)
        mov radio3, rv(GetDlgItem,hWin,104)
        mov radio4, rv(GetDlgItem,hWin,105)
        mov static, rv(GetDlgItem,hWin,107)

        invoke SendMessage,radio1,BM_SETCHECK,BST_CHECKED,0
        invoke SetWindowText,static,"Radio button ONE is selected"
        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 102
            invoke SetWindowText,static,"Radio button ONE is selected"
          .case 103
            invoke SetWindowText,static,"Radio button TWO is selected"
          .case 104
            invoke SetWindowText,static,"Radio button THREE is selected"
          .case 105
            invoke SetWindowText,static,"Radio button FOUR is selected"
          .case 106
            jmp exit_dialog             ; The EXIT button
        .endsw

      .case WM_CLOSE
        exit_dialog:
        invoke EndDialog,hWin,0         ; exit from system menu
    .endsw

    xor rax, rax
    ret

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
