; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance     dq ?
      hWnd          dq ?
      hIcon         dq ?
      hCursor       dq ?
      sWid          dq ?
      sHgt          dq ?
      hBrush        dq ?
      hList         dq ?
      lpListProc    dq ?
      hRad1         dq ?
      hRad2         dq ?
      hRad3         dq ?
      hRad4         dq ?
      hRad5         dq ?
      hChk1         dq ?
      hsled         dq ?

    .data
      classname db "controls_class",0
      caption db "Standard Windows Controls",0

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    GdiPlusBegin                    ; initialise GDIPlus

    mov hInstance, rv(GetModuleHandle,0)
    mov hIcon,     rv(LoadIcon,hInstance,10)
    mov hCursor,   rv(LoadCursor,0,IDC_ARROW)
    mov sWid,      rv(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rv(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rv(CreateSolidBrush,00EEEEEEh)

    call main

    GdiPlusEnd                      ; GdiPlus cleanup

    invoke ExitProcess,0

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

    invoke RegisterClassEx,ADDR wc

    mov wid, function(getpercent,sWid,50)   ; 65% screen width
    mov hgt, function(getpercent,sHgt,50)   ; 65% screen height

    invoke aspect_ratio,hgt,45              ; height + 45%
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
    invoke TranslateMessage,pmsg
    invoke DispatchMessage,pmsg
  gmsg:
    test rax, rv(GetMessage,pmsg,0,0,0)     ; loop until GetMessage returns zero
    jnz mloop

    ret

msgloop endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL dfbuff[260]:BYTE

    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case 200
            invoke SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
          .case 300
            invoke MsgboxI,hWin, \
                   "Using the old style windows controls.", \
                   "About Window Controls Demo",MB_OK,10

          .case 601
            invoke MessageBox,hWin,"Howdy Howdy Howdy","Button1",MB_OK
          .case 602
            invoke MessageBox,hWin,"Arrrrgh, G'day","Button2",MB_OK
          .case 603
            invoke MessageBox,hWin,"Grittings Awl","Button3",MB_OK
          .case 604
            invoke MessageBox,hWin,"Urrrrgh, 'ullo","Button4",MB_OK

        .endsw

      .case WM_CREATE
        invoke LoadMenu,hInstance,100
        invoke SetMenu,hWin,rax

        blft equ <25>   ; top X
        btop equ <20>   ; top Y
        bwid equ <110>  ; width
        bhgt equ <25>   ; height

        invoke button,hInstance,hWin,"Button1",blft,btop,bwid,bhgt,601
        invoke button,hInstance,hWin,"Button2",blft,btop+bhgt,bwid,bhgt,602
        invoke button,hInstance,hWin,"Button3",blft,btop+bhgt*2,bwid,bhgt,603
        invoke button,hInstance,hWin,"Button4",blft,btop+bhgt*3,bwid,bhgt,604

        invoke static,hInstance,hWin,"Double Click To Select",150,20,200,20

      ; ---------------------------------
      ; create a list box and subclass it
      ; ---------------------------------
        mov hList, rv(listbox,hWin,hInstance,0,150,40,200,178,700)
        mov lpListProc, rv(SetWindowLongPtr,hList,GWL_WNDPROC,ADDR ListProc)

      ; ------------------------------
      ; add text items to the list box
      ; ------------------------------
        invoke SendMessage,hList,LB_ADDSTRING,0,"Zero"
        invoke SendMessage,hList,LB_ADDSTRING,0,"One"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Two"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Three"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Four"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Five"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Six"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Seven"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Eight"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Nine"

        invoke group_box,hInstance,hWin,0,370,31,175,189

        mov hRad1, rv(radiobutton,hWin,hInstance,"Radio 1",385,50,140,20,620)
        mov hRad2, rv(radiobutton,hWin,hInstance,"Radio 2",385,80,140,20,621)
        mov hRad3, rv(radiobutton,hWin,hInstance,"Radio 3",385,110,140,20,622)
        mov hRad4, rv(radiobutton,hWin,hInstance,"Radio 4",385,140,140,20,623)
        mov hRad5, rv(radiobutton,hWin,hInstance,"Radio 5",385,170,140,20,624)

      ; --------------------------------
      ; set default checked radio button
      ; --------------------------------
        invoke SendMessage,hRad1,BM_SETCHECK,BST_CHECKED,0

        mov hChk1, rv(checkbox,hWin,hInstance,"Check Box",385,230,140,20,630)

        mov hsled, rv(editbox,hWin,hInstance,"Single Line Edit",25,230,150,20,0)

        .return 0

      .case WM_DROPFILES
        invoke DragQueryFile,wParam,0,ADDR dfbuff,260
        invoke MsgboxI,hWin,ADDR dfbuff,"Drop File Name",MB_OK,10

      .case WM_CLOSE
        invoke SendMessage,hWin,WM_DESTROY,0,0

      .case WM_DESTROY
        invoke PostQuitMessage,NULL

    .endsw

    invoke DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

ListProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

  ; -----------------------------------
  ; subclass procedure for the list box
  ; -----------------------------------
    LOCAL indx  :QWORD                                      ; list box index variable
    LOCAL pbuf  :QWORD                                      ; buffer pointer
    LOCAL buffer[64]:BYTE                                   ; allocate space for text

    .switch uMsg
      .case WM_LBUTTONDBLCLK
        mov pbuf, ptr$(buffer)                              ; get buffer address
        mov indx, rv(SendMessage,hWin,LB_GETCURSEL,0,0)     ; get index of current selection
        invoke SendMessage,hWin,LB_GETTEXT,indx,pbuf        ; load selected text into "pbuf"
        invoke MessageBox,hWnd,pbuf,"Title",MB_OK           ; display the selection

    .endsw

    invoke CallWindowProc,lpListProc,hWin,uMsg,wParam,lParam

    ret

ListProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

static proc instance:QWORD,hparent:QWORD,text:QWORD,topx:QWORD,topy:QWORD,wid:QWORD,hgt:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"STATIC",text, \
                          WS_CHILD or WS_VISIBLE,\
                          topx,topy,wid,hgt,hparent,-1,instance,0
    ret

static endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
