; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hImgBox   dq ?
      hBmp      dq ?

    .data
      classname db "template_class",0
      caption db "Load JPG image from disk",0

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                    ; initialise GDIPlus

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rvcall(LoadIcon,hInstance,10)
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)

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
    mov wc.hbrBackground,  0
    mov wc.lpszMenuName,   0
    mov wc.lpszClassName,  ptr$(classname)
    mrm wc.hIconSm,        hIcon

    lea rcx, wc
    call RegisterClassEx

    mov wid, 780                            ; window width
    mov hgt, 490                            ; window height

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
    invoke CreateWindowEx,WS_EX_LEFT,ADDR classname,ADDR caption, \
                          WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
                          lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd, rax

    call msgloop

    ret

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

msgloop proc

    LOCAL msg   :MSG
    LOCAL pmsg  :QWORD
    LOCAL .r15  :QWORD
    LOCAL .r14  :QWORD

    mov .r15, r15
    mov .r14, r14

    lea r15, msg                                    ; load msg address into r15
    xor r14, r14                                    ; set r14 to zero

    jmp gmsg                                        ; jump directly to GetMessage()

  mloop:
    rcall TranslateMessage,r15
    rcall DispatchMessage,r15
  gmsg:
    test rax, rvcall(GetMessage,r15,r14,r14,r14)    ; loop until GetMessage returns zero
    jnz mloop

  mquit:
    mov r15, .r15
    mov r14, .r14

    ret

msgloop endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL dfbuff[260]:BYTE

    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case 200
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
          .case 300
            invoke MsgboxI,hWin, \
                   "Load a JPG image using GDI+", \
                   "About LoadGdiImage",MB_OK,10
        .endsw

      .case WM_CREATE
      ; --------------------------------------------------------------------------------------------
        mov hImgBox, rvcall(ImageCtl,hInstance,hWin,-1,0)           ; create the static control
        mov hBmp, rv(LoadGdiImage,"bali.jpg")                       ; load disk file as bitmap handle
        rcall SendMessage,hImgBox,STM_SETIMAGE,IMAGE_BITMAP,hBmp    ; write image to static control
      ; --------------------------------------------------------------------------------------------

        rcall LoadMenu,hInstance,100
        rcall SetMenu,hWin,rax
        .return 0

      .case WM_CLOSE
        rcall SendMessage,hWin,WM_DESTROY,0,0

      .case WM_DESTROY
        rcall PostQuitMessage,NULL

    .endsw

    rcall DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

ImageCtl proc instance:QWORD,parent:QWORD,topx:QWORD,topy:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"STATIC",0, \
                          WS_CHILD or WS_VISIBLE or SS_BITMAP,\
                          topx,topy,0,0,parent,-1,instance,0
    ret

ImageCtl endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
