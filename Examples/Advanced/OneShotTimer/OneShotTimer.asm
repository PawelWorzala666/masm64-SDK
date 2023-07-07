; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hFont     dq ?

      hStat     dq ?                ; control handles
      hLabl     dq ?
      hEdit     dq ?
      hButn     dq ?
      hBack     dq ?
      hDark     dq ?

      bImg1     dq ?                ; button images
      bImg2     dq ?
      hCurs     dq ?
      pBtnProc  dq ?                ; address of button subclass procedure

      hThread   dq ?                ; thread data
      tID       dq ?
      tDelay    dq ?

    .data
      classname db "my_timer_class",0
      caption db "One Shot Timer",0
      tFlag     dq 0                ; thread is running flag

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                    ; initialise GDIPlus

    ics equ <128>                   ; icon size

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,ics,ics,0)
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hCurs,     rv(LoadCursor,0,IDC_HAND)
    mov bImg1,     rv(ResImageLoad,20)
    mov bImg2,     rv(ResImageLoad,25)
    mov hFont,     GetFontHandle("Segoe UI",22,600)
    mov hBack,     rvcall(CreateSolidBrush,00444444h)
    mov hDark,     rvcall(CreateSolidBrush,00333333h)

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
    mrm wc.hbrBackground,  rvcall(CreateSolidBrush,00444444h)
    mov wc.lpszMenuName,   0
    mov wc.lpszClassName,  ptr$(classname)
    mrm wc.hIconSm,        hIcon

    rcall RegisterClassEx,ptr$(wc)

    mov wid, 640
    mov hgt, 290

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

  ; ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

    mov hThread, rv(CreateThread,NULL,NULL,ADDR Thread,hWnd,CREATE_SUSPENDED,ADDR tID)

  ; ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

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
    LOCAL buff[32]:BYTE
    LOCAL pbuf  :QWORD
    LOCAL tvar  :QWORD

    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case 100
          ; |||||||||||||||||||||||||||||||||||

            .if tFlag == 0
              mov pbuf, ptr$(buff)
              rcall GetWindowText,hEdit,pbuf,32
              mov tDelay, uval(pbuf)
              rcall ResumeThread,hThread
              mov tFlag, 1
            .endif

            rcall SetWindowText,hWin," Timer Running"

          ; |||||||||||||||||||||||||||||||||||

          .case 110
            rcall SetWindowText,hWin," Done"
            invoke MsgboxI,hWin,str$(lParam),"Duration",MB_OK,10
            mov tFlag, 0
            rcall SetWindowText,hWin,ptr$(caption)

          .case 200
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
        .endsw

      .case WM_CREATE
        mov hStat, rv(icon_control,hInstance,hWin,80,50,1234)
        rcall SendMessage,hStat,STM_SETIMAGE,IMAGE_ICON,hIcon

        mov hLabl, rv(static_rght,hWin,hInstance,225,105,170,25,0)
        rcall SetWindowText,hLabl,"Set Duration Here : "
        rcall SendMessage,hLabl,WM_SETFONT,hFont,TRUE

        mov hEdit, rv(editbox,hWin,hInstance,"1000",395,105,75,23,9876)
        rcall SendMessage,hEdit,WM_SETFONT,hFont,TRUE

        mov hButn, rv(bmp_button,hInstance,hWin,"Button",475,105,90,23,100)
        rcall SendMessage,hButn,WM_SETFONT,hFont,TRUE
        rcall SendMessage,hButn,BM_SETIMAGE,IMAGE_BITMAP,bImg1
        invoke SetWindowLongPtr,hButn,GWL_WNDPROC,ADDR ButnProc
        mov pBtnProc, rax

        .return 0

      .case WM_CTLCOLORSTATIC
        rcall SetBkColor,wParam,00444444h
        rcall SetTextColor,wParam,00DDDDDDh
        mov rax, hBack                              ; default background colour
        ret

      .case WM_CTLCOLOREDIT                         ; edit controls
        rcall SetBkColor,wParam,000000BBh
        rcall SetTextColor,wParam,00FFFFFFh
        mov rax, hDark
        ret

      .case WM_CLOSE
        rcall SendMessage,hWin,WM_DESTROY,0,0

      .case WM_DESTROY
        rcall PostQuitMessage,NULL

    .endsw

    rcall DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

icon_control proc instance:QWORD,parent:QWORD,topx:QWORD,topy:QWORD,cID:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"STATIC",0,WS_CHILDWINDOW or \
                          WS_VISIBLE or SS_ICON, \
                          topx,topy,0,0,parent,cID,instance,0
    ret

icon_control endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

bmp_button proc instance:QWORD,hparent:QWORD,text:QWORD, \
                topx:QWORD,topy:QWORD,wid:QWORD,hgt:QWORD,cID:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"BUTTON",text, \
                          WS_CHILD or WS_VISIBLE or BS_BITMAP,\
                          topx,topy,wid,hgt,hparent,cID,instance,0
    ret

bmp_button endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

ButnProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_LBUTTONDOWN
        rcall SendMessage,hWin,BM_SETIMAGE,IMAGE_BITMAP,bImg2
        rcall SetCursor,hCurs

      .case WM_LBUTTONUP
        rcall SendMessage,hWin,BM_SETIMAGE,IMAGE_BITMAP,bImg1

      .case WM_MOUSEMOVE
        rcall SetCursor,hCurs

    .endsw

    invoke CallWindowProc,pBtnProc,hWin,uMsg,wParam,lParam

    ret

ButnProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Thread proc hCaller:QWORD

  lbl:
    rcall SleepEx,tDelay,0
    rcall SendMessage,hCaller,WM_COMMAND,110,tDelay
    rcall SuspendThread,rv(GetCurrentThread)
    jmp lbl

    ret

Thread endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
