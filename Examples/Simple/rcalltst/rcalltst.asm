comment * いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

  EXAMPLE use rcall and rvcall to reduce call overhead with API calls that have 4 or less arguments.
          It will only support arguments that can be written directly to registers and will not
          allow either ADDR or quoted text.

          いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい *

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBrush    dq ?

    .data
      classname db "template_class",0
      caption db "Template",0

      mbtitle db "The Title",0
      mbtext db "This is a MessageBox",0
      pttl dq mbtitle
      ptxt dq mbtext


    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                    ; initialise GDIPlus

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rvcall(LoadIcon,hInstance,10)
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rvcall(CreateSolidBrush,00C4C4C4h)

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

    lea rcx, wc
    call RegisterClassEx

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

    LOCAL dfbuff[260]:BYTE
    LOCAL pbuff :QWORD

    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case 200
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
          .case 300
            invoke MsgboxI,hWin, \
                   "Wickedly Crafted In Microsoft Assembler (MASM)", \
                   "About rcall and rvcall Test",MB_OK,10
        .endsw

      .case WM_CREATE
        rcall LoadMenu,hInstance,100
        rcall SetMenu,hWin,rax
        .return 0

      .case WM_DROPFILES
        mov pbuff, ptr$(dfbuff)
        rcall DragQueryFile,wParam,0,pbuff,260
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

    end
