; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hIcon     dq ?
      hCombo    dq ?

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    mov hInstance, rvcall(GetModuleHandle,0)

    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon

    rcall ExitProcess,0
    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL pbuf :QWORD
    LOCAL buff[64]:BYTE
    LOCAL csel :QWORD

    .switch uMsg
      .case WM_INITDIALOG
        rcall SetWindowText,hWin,"Combo Test"
        mov hCombo, rvcall(GetDlgItem,hWin,103)                     ; get the combo handle

        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 1"          ; add strings to the combo box
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 2"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 3"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 4"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 5"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 6"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 7"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 8"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 9"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 10"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 11"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 12"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 13"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 14"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 15"
        rcall SendMessage,hCombo,CB_ADDSTRING,0,"String 16"

        rcall SendMessage,hCombo,CB_SETCURSEL,0,0                   ; set to first string (index 0)

        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 101
            mov csel, rvcall(SendMessage,hCombo,CB_GETCURSEL,0,0)   ; get the current selection
            mov pbuf, ptr$(buff)                                    ; get pointer to buffer
            rcall SendMessage,hCombo,CB_GETLBTEXT,csel,pbuf         ; load selected text into buffer
            invoke MsgboxI,hWin,pbuf,"Selected",MB_OK,10            ; display result
          .case 102
            jmp exit_dialog
        .endsw

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0                                      ; exit from system menu
    .endsw

    xor rax, rax
    ret

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
