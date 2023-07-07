; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hIcon     dq ?

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    mov hInstance, rv(GetModuleHandle,0)

  ; -------------------------------------------------------------
  ; set the icon loaded size here to match the original icon size
  ; -------------------------------------------------------------
    mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon       ; create a modal dialog
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
        invoke SendMessage,rv(GetDlgItem,hWin,102), \   ; set the icon in the client area
               STM_SETIMAGE,IMAGE_ICON,lParam
        invoke SetWindowText,hWin,"Big Icon Demo"
        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 101
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
