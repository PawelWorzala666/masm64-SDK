; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm32\include64\masm64rt.inc

    backcolor equ <00444444h>                           ; window & control back colour

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBrush    dq ?
      hImg      dq ?
      hButn     dq ?
      bImag     dq ?
      hStat     dq ?
      hFont     dq ?

    .data
      classname db "template_class",0
      caption db "Custom MessageBox",0

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    ics equ <64>                    ; icon size

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,ics,ics,LR_DEFAULTCOLOR)    ; icon
    mov bImag,     rv(LoadImage,hInstance,20,IMAGE_BITMAP,100,26,LR_DEFAULTCOLOR)   ; butn image
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rvcall(CreateSolidBrush,backcolor)
    mov hFont,     GetFontHandle("Segoe UI",18,600)

    call main

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
                          WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
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
          .case 150
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
        .endsw

      .case WM_CREATE
        mrm hWnd, hWin
        mov hImg, rvcall(image_control,20,20)
        rcall SendMessage,hImg,STM_SETIMAGE,IMAGE_ICON,hIcon

        mov hButn, rv(push_button,"Button",360,110,100,26,150)
        rcall SendMessage,hButn,BM_SETIMAGE,IMAGE_BITMAP,bImag

        mov hStat, rv(static_control,110,15,350,90,0)
        rcall SendMessage,hStat,WM_SETFONT,hFont,TRUE

        .data
          tMsg db 13,10,"This is a test of a custom MessageBox.",13,10
               db "It is created with a normal CreateWindowEx ",13,10
               db "procedure call.",0
          pMsg dq tMsg
        .code

        rcall SetWindowText,hStat,pMsg
        .return 0

      .case WM_CTLCOLORSTATIC                               ; static colour control
        rcall SetBkColor,wParam,backcolor
        rcall SetTextColor,wParam,00EEEEEEh
        rcall CreateSolidBrush,backcolor
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

push_button proc ptext:QWORD,tx:QWORD,ty:QWORD,wd:QWORD,ht:QWORD,idnum:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"BUTTON",ptext, \
                          WS_CHILD or WS_VISIBLE or BS_BITMAP,\
                          tx,ty,wd,ht,hWnd,idnum,hInstance,0
    ret

push_button endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
