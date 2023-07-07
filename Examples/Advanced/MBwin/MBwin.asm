; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    backcolor equ <00444444h>                           ; window & control back colour

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBrush    dq ?
      hButn     dq ?
      bImg1     dq ?
      bImg2     dq ?
      hStat     dq ?
      hFont     dq ?
      iImg      dq ?

      lpButnProc dq ?   ; address of default subclass procedure

    .data
      classname db "template_class",0
      caption db " Custom Dialog Box",0

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                    ; initialise GDIPlus

    ics equ <64>                    ; icon size

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,ics,ics,LR_DEFAULTCOLOR)
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rvcall(CreateSolidBrush,backcolor)
    mov hFont,     GetFontHandle("Segoe UI",20,600)

    mov bImg1,     rv(ResImageLoad,20)
    mov bImg2,     rv(ResImageLoad,25)

    call main

    GdiPlusEnd                      ; GdiPlus cleanup

    .exit

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

    mov wid, 485
    mov hgt, 182

    mov rax, sWid                           ; calculate offset from left side
    sub rax, wid
    shr rax, 1
    mov lft, rax

    mov rax, sHgt                           ; calculate offset from top edge
    sub rax, hgt
    shr rax, 1
    mov top, rax

    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
                          ADDR classname,ADDR caption, \
                          WS_OVERLAPPED or WS_VISIBLE,\     ;  or WS_SYSMENU
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
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
        .endsw

      .case WM_CREATE
        mrm hWnd, hWin
        mov hButn, rv(bmp_button,"Button",353,105,100,25,100)
        invoke SetWindowLongPtr,hButn,GWL_WNDPROC,ADDR ButnProc
        mov lpButnProc, rax

        rcall SendMessage,hButn,BM_SETIMAGE,IMAGE_BITMAP,bImg1      ; set default start image

        mov iImg, rvcall(image_control,20,16)
        rcall SendMessage,iImg,STM_SETIMAGE,IMAGE_ICON,hIcon

        mov hStat, rv(static_control,110,15,350,90,0)
        rcall SendMessage,hStat,WM_SETFONT,hFont,TRUE

        .data
          tMsg db "This is an example of a Custom Dialog Box.",13,10
               db "It is created with a normal CreateWindowEx",13,10
               db "procedure call.",0
          pMsg dq tMsg
        .code

        rcall SetWindowText,hStat,pMsg
        .return 0

      .case WM_CTLCOLORSTATIC                                       ; static colour control
        rcall SetBkColor,wParam,backcolor
        rcall SetTextColor,wParam,00EEEEEEh
        mov rax, hBrush
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

image_control proc tx:QWORD,ty:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"STATIC",0, \
           WS_CHILDWINDOW or WS_VISIBLE or SS_ICON,tx,ty,0,0,hWnd,0,hInstance,0
    ret

image_control endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

static_control proc tx:QWORD,ty:QWORD,wd:QWORD,ht:QWORD,bdr:QWORD

    LOCAL sStyle :QWORD

    mov sStyle, WS_CHILD or WS_VISIBLE or SS_LEFT

    .if bdr == 1
      or sStyle, WS_BORDER
    .endif

    invoke CreateWindowEx,WS_EX_LEFT,"STATIC",0,sStyle,tx,ty,wd,ht,hWnd,0,hInstance,0

    ret

static_control endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

bmp_button proc ptext:QWORD,tx:QWORD,ty:QWORD,wd:QWORD,ht:QWORD,idnum:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"BUTTON",ptext, \
                          WS_CHILD or WS_VISIBLE or BS_BITMAP,\
                          tx,ty,wd,ht,hWnd,idnum,hInstance,0
    ret

bmp_button endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

ButnProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_LBUTTONDOWN
        rcall SendMessage,hButn,BM_SETIMAGE,IMAGE_BITMAP,bImg2

      .case WM_LBUTTONUP
        rcall SendMessage,hButn,BM_SETIMAGE,IMAGE_BITMAP,bImg1
    .endsw

    invoke CallWindowProc,lpButnProc,hWin,uMsg,wParam,lParam

    ret

ButnProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
