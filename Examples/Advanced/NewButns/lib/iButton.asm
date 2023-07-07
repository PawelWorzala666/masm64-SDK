; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm32\include64\masm64rt.inc

    .data?
      pBtnProc dq ?
      i__Tmp_@_@ dq ?
    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

iButton proc tx:QWORD,ty:QWORD,pBmp1:QWORD,pBmp2:QWORD,instance:QWORD,hparent:QWORD,cID:QWORD

  ; ----------------------------------------------------
  ; tx          button top X coordinate
  ; ty          button top Y coordinate
  ; pBmp1       the UP button image
  ; pBmp2       the DOWN button image
  ; instance    the instance handle
  ; hparent     the parent window handle
  ; cID         the control ID for WM_COMMAND processing
  ; ----------------------------------------------------

    LOCAL hndl :QWORD
    LOCAL bmp  :BITMAP

    rcall GetObject,pBmp1,SIZEOF BITMAP, ptr$(bmp)

    invoke CreateWindowEx,WS_EX_LEFT,"BUTTON",0, \
                          WS_CHILD or WS_VISIBLE or BS_BITMAP,\
                          tx,ty,bmp.bmWidth,bmp.bmHeight,hparent,cID,instance,0
    mov hndl, rax
    rcall SendMessage,hndl,BM_SETIMAGE,IMAGE_BITMAP,pBmp1
    invoke SetWindowLongPtr,hndl,GWL_WNDPROC,ADDR iButnProc
    mov pBtnProc, rax
    invoke SetWindowLongPtr,hndl,GWL_USERDATA,pBmp2
    mov rax, hndl

    ret

iButton endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

iButnProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_LBUTTONUP
        rcall SendMessage,hWin,BM_SETIMAGE,IMAGE_BITMAP,i__Tmp_@_@

      .case WM_LBUTTONDOWN
        mov i__Tmp_@_@, rvcall(SendMessage,hWin,BM_GETIMAGE,IMAGE_BITMAP,0)
        rcall SendMessage,hWin,BM_SETIMAGE,IMAGE_BITMAP, \
                          rv(GetWindowLongPtr,hWin,GWL_USERDATA)
        rcall SetCursor,rv(LoadCursor,0,IDC_HAND)

      .case WM_MOUSEMOVE
        rcall SetCursor,rv(LoadCursor,0,IDC_HAND)

    .endsw

    invoke CallWindowProc,pBtnProc,hWin,uMsg,wParam,lParam

    ret

iButnProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
