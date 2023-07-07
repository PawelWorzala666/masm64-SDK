; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBrush    dq ?

      b1up      dq ?
      b1dn      dq ?

      b2up      dq ?
      b2dn      dq ?

      b3up      dq ?
      b3dn      dq ?

    .data
      classname db "template_class",0
      caption db "Template",0

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                    ; initialise GDIPlus

    ics equ <32>                    ; icon size

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,ics,ics,LR_DEFAULTCOLOR)
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rvcall(CreateSolidBrush,00444444h)

    mov b1up,     rv(ResImageLoad,20)
    mov b1dn,     rv(ResImageLoad,25)

    mov b2up,     rv(ResImageLoad,30)
    mov b2dn,     rv(ResImageLoad,35)

    mov b3up,     rv(ResImageLoad,40)
    mov b3dn,     rv(ResImageLoad,45)

    call main

    GdiPlusEnd                      ; GdiPlus cleanup

    rcall ExitProcess,0

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

main proc

    LOCAL wc      :WNDCLASSEX
    LOCAL lft     :QWORD
    LOCAL top     :QWORD
    LOCAL wid     :QWORD
    LOCAL hgt     :QWORD

    mov wc.cbSize,         SIZEOF WNDCLASSEX
    mov wc.style,          CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW
    mov wc.lpfnWndProc,    ptr$(WndProc)
    mov wc.cbClsExtra,     0
    mov wc.cbWndExtra,     0
    mrm wc.hInstance,      hInstance
    mrm wc.hIcon,          hIcon
    mrm wc.hCursor,        hCursor
    mrm wc.hbrBackground,  hBrush
    mov wc.lpszMenuName,   0
    mov wc.lpszClassName,  ptr$(classname)
    mrm wc.hIconSm,        hIcon

    rcall RegisterClassEx,ptr$(wc)

    mov wid, rvcall(getpercent,sWid,65)     ; 65% screen width
    mov hgt, rvcall(getpercent,sHgt,65)     ; 65% screen height

    rcall aspect_ratio,hgt,45               ; height + 45%
    cmp wid, rax                            ; if wid > rax
    jle @F
    mov wid, rax                            ; set wid to rax
  @@:
    mov rax, sWid                           ; calculate offset from left side
    sub rax, wid
    shr rax, 1
    mov lft, rax

    mov rax, sHgt                           ; calculate offset from top edge
    sub rax, hgt
    shr rax, 1
    mov top, rax

  ; ---------------------------------
  ; centre window at calculated sizes
  ; ---------------------------------
    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
                          ADDR classname,ADDR caption, \
                          WS_OVERLAPPEDWINDOW or WS_VISIBLE,\
                          lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd, rax

    call msgloop

    ret

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

msgloop proc

    LOCAL msg    :MSG
    LOCAL pmsg   :QWORD

    mov pmsg, ptr$(msg)                     ; get the msg structure address
    jmp gmsg                                ; jump directly to GetMessage()

  mloop:
    rcall TranslateMessage,pmsg
    rcall DispatchMessage,pmsg
  gmsg:
    test rax, rvcall(GetMessage,pmsg,0,0,0) ; loop until GetMessage returns zero
    jnz mloop

    ret

msgloop endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL hDC :QWORD
    LOCAL ps  :PAINTSTRUCT
    LOCAL dfbuff[260]:BYTE

    .switch uMsg
      .case WM_COMMAND
        .switch wParam

          .case 100
            invoke MsgboxI,hWin,"The OK Button","OK",MB_OK,10

          .case 101
            invoke MsgboxI,hWin,"Iten Cancelled","Cancel",MB_OK,10

          .case 102
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL

          .case 200
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
          .case 300
            invoke MsgboxI,hWin, \
                   "Wickedly Crafted In 64 Bit Microsoft Assembler <MASM>", \
                   "About",MB_OK,10
        .endsw

      .case WM_CREATE
        rcall LoadMenu,hInstance,100
        rcall SetMenu,hWin,rax

        invoke iButton,hInstance,hWin,150, 50,b1up,b1dn,100
        invoke iButton,hInstance,hWin,150, 80,b2up,b2dn,101
        invoke iButton,hInstance,hWin,150,110,b3up,b3dn,102

        .return 0

      .case WM_PAINT
        rcall BeginPaint,hWin,ptr$(ps)
        mov hDC, rvcall(GetDC,hWin)

      ; code here

        rcall ReleaseDC,hWin,hDC
        rcall EndPaint,hWin,ptr$(ps)

      .case WM_DROPFILES
        rcall DragQueryFile,wParam,0,ptr$(dfbuff),260
        invoke MsgboxI,hWin,ADDR dfbuff,"Drop File Name",MB_OK,10

      .case WM_CLOSE
        rcall SendMessage,hWin,WM_DESTROY,0,0

      .case WM_DESTROY
        rcall PostQuitMessage,NULL

    .endsw

    rcall DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    .data?
      pBtnProc dq ?
      i__Tmp_@_@ dq ?
    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

iButton proc instance:QWORD,hparent:QWORD,tx:QWORD,ty:QWORD,pBmp1:QWORD,pBmp2:QWORD,cID:QWORD

  ; ----------------------------------------------------
  ; instance    the instance handle
  ; hparent     the parent window handle
  ; tx          button top X coordinate
  ; ty          button top Y coordinate
  ; pBmp1       the UP button image
  ; pBmp2       the DOWN button image
  ; cID         the control ID for WM_COMMAND processing
  ; ----------------------------------------------------

    LOCAL hndl :QWORD
    LOCAL bmp  :BITMAP

    rcall GetObject,pBmp1,SIZEOF BITMAP, ptr$(bmp)

  ; -------------------------------------------------
  ; create the button at the size of the first bitmap
  ; -------------------------------------------------
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
