; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    backcolor equ <00333333h>

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCurs     dq ?
      butn1     dq ?
      butn2     dq ?
      bimg1     dq ?
      bimg2     dq ?
      hPic      dq ?
      lpbutnProc dq ?

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                    ; initialise GDIPlus

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
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
        rcall SendMessage,rvcall(GetDlgItem,hWin,103), \    ; set the icon in the client area
              STM_SETIMAGE,IMAGE_ICON,lParam
        rcall SetWindowText,hWin,"Colour Dialog"

        mov bimg1, rv(ResImageLoad,20)
        mov butn1, rv(GetDlgItem,hWin,101)
        rcall setup_button,butn1,bimg1,80,24

        mov bimg2, rv(ResImageLoad,25)
        mov butn2, rv(GetDlgItem,hWin,102)
        rcall setup_button,butn2,bimg2,80,24
        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 101
           invoke MsgboxI,hWnd,"You clicked OK","Title",MB_OK,10

          .case 102
            jmp exit_dialog                         ; The OK button
        .endsw

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
