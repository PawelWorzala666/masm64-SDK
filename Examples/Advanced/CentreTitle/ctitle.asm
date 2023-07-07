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
      hTbar     dq ?
      tbFont    dq ?
      sbFont    dq ?
      tBrush    dq ?
      tbHgt     dq ?
      hStatus   dq ?
      tButn1    dq ?
      tButn2    dq ?
      iClose    dq ?
      iZoom     dq ?

    .data
      classname db "template_class",0
      caption db "Template",0

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                                                ; initialise GDIPlus

    ics equ <32>                                                ; icon size

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,ics,ics,LR_DEFAULTCOLOR)
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rvcall(CreateSolidBrush,00444444h)
    mov tBrush,    rvcall(CreateSolidBrush,00222222h)
    mov tbFont,    GetFontHandle("Arial",28,600)
    mov sbFont,    GetFontHandle("Arial",16,600)

    mov iClose,    rvcall(ResImageLoad,20)
    mov iZoom,     rvcall(ResImageLoad,21)

    hTB equ <32>                                                ; title bar height

    mov tbHgt, hTB

    call main

    GdiPlusEnd                                                  ; GdiPlus cleanup

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

    mov wid, rvcall(getpercent,sWid,55)     ; 55% screen width
    mov hgt, rvcall(getpercent,sHgt,55)     ; 55% screen height

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
    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_TRANSPARENT, \
                          ADDR classname,ADDR caption, \
                          WS_VISIBLE or WS_POPUP or WS_THICKFRAME,\
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
    .switch msg.message
      .case WM_KEYUP
        .switch msg.wParam
          .case VK_F1
            invoke SendMessage,hWnd,WM_COMMAND,100,0
          .case VK_ESCAPE
            rcall SendMessage,hWnd,WM_COMMAND,101,0
        .endsw
    .endsw
    invoke TranslateMessage,pmsg
    invoke DispatchMessage,pmsg
  gmsg:
    test rax, rv(GetMessage,pmsg,0,0,0)     ; loop until GetMessage returns zero
    jnz mloop

    ret

msgloop endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL hDC :QWORD
    LOCAL ps  :PAINTSTRUCT
    LOCAL dfbuff[260]:BYTE
    LOCAL pt  :POINT
    LOCAL htrv :QWORD
    LOCAL rct :RECT

    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case 100
            rcall IsZoomed,hWin
            .if rax == 0
              rcall ShowWindow,hWin,SW_MAXIMIZE
            .else
              rcall ShowWindow,hWin,SW_SHOWNORMAL
            .endif

          .case 101
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL

        .endsw

      .case WM_CREATE
        rcall GetClientRect,hWin,ptr$(rct)
        mov hTbar, rv(static_ttl,hWin,hInstance,0,0,rct.right,tbHgt,0)      ; title bar
        rcall SendMessage,hTbar,WM_SETFONT,tbFont,TRUE
        rcall SetWindowText,hTbar,"Window Title"

        mov hStatus, rv(statusbar,hWin,hInstance,0,0,100,25,0)              ; status bar
        rcall SetWindowText,hStatus," Status bar"
        rcall SendMessage,hStatus,WM_SETFONT,sbFont,TRUE

        mov tButn1, rv(tbutton,hInstance,hWin,"?",0,0,tbHgt,tbHgt,100)      ; left toolbar button
        rcall SendMessage,tButn1,BM_SETIMAGE,IMAGE_BITMAP,iZoom

        mov tButn2, rv(tbutton,hInstance,hWin,"x",100,0,tbHgt,tbHgt,101)    ; right toolbar burron
        rcall SendMessage,tButn2,BM_SETIMAGE,IMAGE_BITMAP,iClose

        .return 0

      .case WM_NCHITTEST
        rcall GetCursorPos,ptr$(pt)
        rcall ScreenToClient,hWin,(ptr$(pt))
        mov htrv, rvcall(DefWindowProc,hWnd,uMsg,wParam,lParam)
        .switch htrv
          .case HTCLIENT
            rcall GetClientRect,hWin,ptr$(rct)
            .if pt.x } hTB
              sub rct.right, hTB
              mov edx, rct.right
              .if pt.x { edx
                .if pt.y {= hTB
                  mov rax, HTCAPTION
                  ret
                .endif
              .endif
            .endif
        .endsw

      .case WM_CTLCOLORSTATIC
        mov rdx, lParam
        .if rdx == hTbar
          rcall SetBkColor,wParam,00222222h
          rcall SetTextColor,wParam,00FFFFFFh
          mov rax, tBrush
          ret
        .elseif rdx == hStatus
          rcall SetBkColor,wParam,00444444h
          rcall SetTextColor,wParam,00FFFFFFh
          mov rax, hBrush
          ret
        .endif

      ; ---------------------------------------------------------

      .case WM_SIZE
        rcall GetClientRect,hWin,ptr$(rct)

        mov r11d, rct.right
        sub r11, tbHgt
        sub r11, tbHgt

        invoke MoveWindow,hTbar,tbHgt,0,r11d,tbHgt,TRUE
        rcall SetWindowText,hTbar,"Window Title"

        mov r11d, rct.right
        sub r11, tbHgt

        invoke MoveWindow,tButn2,r11,0,tbHgt,tbHgt,TRUE

        sub rct.bottom, 24
        add rct.right, 2
        invoke MoveWindow,hStatus,-1,rct.bottom,rct.right,25,TRUE

      ; ---------------------------------------------------------

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

 static_ttl proc hparent:QWORD,instance:QWORD,topx:QWORD,topy:QWORD,wid:QWORD,hgt:QWORD,edge:QWORD

    LOCAL fram  :QWORD

    .if edge == 1
      mov fram, WS_EX_STATICEDGE
    .else
      mov fram, 0
    .endif

    invoke CreateWindowEx,fram,"STATIC",0,WS_CHILD or WS_VISIBLE or SS_CENTER or SS_CENTERIMAGE,\
                          topx,topy,wid,hgt,hparent,0,instance,0
    ret

 static_ttl endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 statusbar proc hparent:QWORD,instance:QWORD,topx:QWORD,topy:QWORD,wid:QWORD,hgt:QWORD,edge:QWORD

    LOCAL fram  :QWORD

    .if edge == 1
      mov fram, WS_EX_STATICEDGE
    .else
      mov fram, 0
    .endif

    invoke CreateWindowEx,fram,"STATIC",0,WS_CHILD or WS_VISIBLE or WS_BORDER or SS_LEFT or SS_CENTERIMAGE,\
                          topx,topy,wid,hgt,hparent,0,instance,0
    ret

 statusbar endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

tbutton proc instance:QWORD,hparent:QWORD,text:QWORD,topx:QWORD,topy:QWORD,wid:QWORD,hgt:QWORD,idnum:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"BUTTON",text, \
                          WS_CHILD or WS_VISIBLE or BS_BITMAP,\
                          topx,topy,wid,hgt,hparent,idnum,instance,0
    ret

tbutton endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
