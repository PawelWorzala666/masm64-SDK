; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hIcon     dq ?
      hCurs     dq ?
      hWnd      dq ?
      bimg1     dq ?
      bimg2     dq ?
      butn1     dq ?
      butn2     dq ?
      lpbutnProc dq ?
      hPict     dq ?
      hStat     dq ?

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                    ; initialise GDIPlus

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
    mov bimg1, rv(ResImageLoad,20)
    mov bimg2, rv(ResImageLoad,25)
    mov hCurs, rv(LoadCursor,0,IDC_HAND)

    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon

    GdiPlusEnd                      ; GdiPlus cleanup

    .exit

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_INITDIALOG
        mrm hWnd, hWin                                      ; make handle global
        rcall SendMessage,hWin,WM_SETICON,1,lParam          ; set the icon for the dialog
        rcall SetWindowText,hWin,"Dialog Demo"

        mov butn1, rv(GetDlgItem,hWin,101)
        mov butn2, rv(GetDlgItem,hWin,102)
        mov hPict, rv(GetDlgItem,hWin,103)
        mov hStat, rv(GetDlgItem,hWin,104)

        rcall SendMessage,butn1,BM_SETIMAGE,IMAGE_BITMAP,bimg1
        rcall SendMessage,butn2,BM_SETIMAGE,IMAGE_BITMAP,bimg2
        rcall SendMessage,hPict,STM_SETIMAGE,IMAGE_ICON,hIcon

        rcall setup_button,butn1,bimg1,80,24
        rcall setup_button,butn2,bimg2,80,24

        .data
          stext \
                db "Friends, Romans, countrymen, lend me your ears, "
                db "I come to bury Caesar, not to praise him. "
                db "The evil that men do lives after them. "
                db "The good is oft interred with their bones.",0
          ptxt dq stext
        .code

        rcall SetWindowText,hStat,ptxt

        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 101
           invoke MsgboxI,hWnd,"You clicked OK","Title",MB_OK,10

          .case 102
            jmp exit_dialog                         ; The OK button
        .endsw

        backcolor equ <00444444h>

      .case WM_CTLCOLORDLG                          ; dialog colour
        rcall CreateSolidBrush,backcolor
        ret

      .case WM_CTLCOLORSTATIC                       ; static controls
        rcall SetBkColor,wParam,backcolor
        rcall SetTextColor,wParam,00FFFFFFh
        rcall CreateSolidBrush,backcolor
        ret

      .case WM_CTLCOLOREDIT                         ; edit controls
        rcall SetBkColor,wParam,001111111h
        rcall SetTextColor,wParam,000000FFh
        rcall CreateSolidBrush,00111111h
        ret

      .case WM_CTLCOLORLISTBOX                      ; list box controls
        rcall SetBkColor,wParam,00222222h
        rcall SetTextColor,wParam,00DDDDDDh
        rcall CreateSolidBrush,00222222h
        ret

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0                      ; exit from system menu
    .endsw

    xor rax, rax
    ret

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

setup_button proc hButn:QWORD,pImg:QWORD,bwid:QWORD,bhgt:QWORD

    LOCAL rct   :RECT

    invoke SetWindowLongPtr,hButn,GWL_WNDPROC,ADDR butnProc
    mov lpbutnProc, rax
    rcall GetWindowRect,hButn,ptr$(rct)
    rcall ScreenToClient,hWnd,ptr$(rct)
    invoke MoveWindow,hButn,rct.left,rct.top,bwid,bhgt,TRUE
    rcall SendMessage,hButn,BM_SETIMAGE,IMAGE_BITMAP,pImg

    ret

setup_button endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

butnProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_MOUSEMOVE
        rcall SetCursor,hCurs
    .endsw

    invoke CallWindowProc,lpbutnProc,hWin,uMsg,wParam,lParam

    ret

butnProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
