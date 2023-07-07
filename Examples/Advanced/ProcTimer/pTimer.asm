; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    ThreadQuit equ <987654321>
    ForceActiv equ <918273645>
    BackColor  equ <00444444h>
    LabelColor equ <000080FFh>
    TimingColr equ <000000FFh>

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBrush    dq ?
      pcmd      dq ?                    ; pointer command line

      hThread   dq ?
      tID       dq ?                    ; thread ID

      stat1     dq ?                    ; static control handles
      stat2     dq ?
      text1     dq ?
      text2     dq ?
      hTim      dq ?
      hAbout    dq ?

      Font1     dq ?                    ; font handles
      Font2     dq ?
      Font3     dq ?

      tcnt      dq ?                    ; start tick count
      cntt      dq ?                    ; duration tick count

      timID     dq ?                    ; timer ID
      cnt       dq ?
      hTimer    dq ?

      ttlbuff   db 128 dup (?)

    .data
      classname db "Timer_64_Class",0
      caption   dq ttlbuff
      lName     dq 128
      var       dq 0
      mcnt      dq 0

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    ics equ <32>                    ; icon size

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,ics,ics,LR_DEFAULTCOLOR)
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rvcall(CreateSolidBrush,BackColor)

    call main

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

    mov pcmd, rvcall(cmd_tail)

    .If rv(exist,pcmd) eq 0
       rcall MessageBox,0,"Please specify the file name to run","No Command Line",MB_ICONINFORMATION
       ret
    .EndIf

    mov hThread, rv(CreateThread,0,0,ADDR RemoteThread,pcmd,CREATE_SUSPENDED,ADDR tID)

    mov tcnt, rvcall(GetTickCount)

    mov lName, 128
    invoke GetComputerName,caption,ptr$(lName)

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

    mov wid, 390
    mov hgt, 180

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
    invoke CreateWindowEx, \
                           WS_EX_LEFT or WS_EX_TOPMOST, \
                           ADDR classname, \
                           caption, \
                           WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
                           lft,0,wid,hgt, \
                           0,0,hInstance,0
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

    LOCAL pbuf  :QWORD
    LOCAL buff[128]:BYTE

    .switch uMsg
      .case WM_CREATE

        mov Font1, GetFontHandle("Segoe UI",20,600)
        mov Font2, GetFontHandle("Segoe UI",50,600)
        mov Font3, GetFontHandle("Segoe UI",20,300)

        mov stat1, rv(Static_Control,hWin,hInstance,50,5,120,25)
        rcall SetWindowText,stat1,"Minutes"
        rcall SendMessage,stat1,WM_SETFONT,Font1,TRUE

        mov stat2, rv(Static_Control,hWin,hInstance,200,5,120,25)
        rcall SetWindowText,stat2,"Seconds"
        rcall SendMessage,stat2,WM_SETFONT,Font1,TRUE

        mov text1, rv(Static_Control,hWin,hInstance,50,25,120,55)
        rcall SetWindowText,text1,"0"
        rcall SendMessage,text1,WM_SETFONT,Font2,TRUE

        mov text2, rv(Static_Control,hWin,hInstance,200,25,120,55)
        rcall SetWindowText,text2,"0"
        rcall SendMessage,text2,WM_SETFONT,Font2,TRUE

        mov hTim, rv(Static_Control,hWin,hInstance,5,80,364,25)
        rcall SetWindowText,hTim,"Milliseconds"
        rcall SendMessage,hTim,WM_SETFONT,Font1,TRUE

        mov hAbout, rv(Static_Control,hWin,hInstance,5,105,364,25)
        rcall SetWindowText,hAbout,"Wickedly Crafted In 64 Bit MASM"
        rcall SendMessage,hAbout,WM_SETFONT,Font3,TRUE

        rcall ResumeThread,hThread

        mov hTimer, rvcall(SetTimer,hWin,timID,990,0)               ; 1 second intervals

        .return 0

      .case WM_TIMER
      ; |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

        rcall GetTickCount
        sub rax, tcnt
        mov cntt, rax                                               ; current tick count from app start

        add var, 1
        .If var ge 60
          add mcnt, 1
          add cnt, 60                                               ; cnt used by following second calculation
          mov var, 0
        rcall SetWindowText,text1,str$(mcnt)                        ; minutes triggered by the timer interval
        .EndIf

        mov r10, cntt
        invoke intdiv,r10,1000
        sub rax, cnt
        rcall SetWindowText,text2, str$(rax)                        ; seconds calculated from GetTickCount

      ; |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

      .case WM_CTLCOLORSTATIC
        .switch lParam                                              ; control handle
        ; ----------------------------------------
          .case hTim
            rcall SetTextColor,wParam,LabelColor
        ; ----------------------------------------
          .case hAbout
            rcall SetTextColor,wParam,00BBBBBBh
        ; ----------------------------------------
          .case stat1
            jmp @F
          .case stat2
            @@:
            rcall SetTextColor,wParam,LabelColor
        ; ----------------------------------------
          .case text1
            jmp @F
          .case text2
            @@:
            rcall SetTextColor,wParam,TimingColr
        ; ----------------------------------------
        .endsw
          rcall SetBkColor,wParam,BackColor
          rcall CreateSolidBrush,BackColor
        ret

      .case WM_COMMAND
        .switch wParam

          .case 200
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL

          ; //////////////////////////////////////////////////

          .case ForceActiv
            rcall EnableWindow,hWin,FALSE
            rcall ShowWindow,hWin,SW_HIDE                           ; force window to have focus
            rcall SleepEx,500,0
            rcall ShowWindow,hWin,SW_SHOW
            rcall EnableWindow,hWin,TRUE

          ; --------------------------------------------------

          .case ThreadQuit
            rcall CloseHandle,hThread
            rcall KillTimer,hWin,timID

            rcall GetTickCount
            sub rax, tcnt
            mov cntt, rax                                           ; get current tick count from app start

            mov pbuf, ptr$(buff)
            mcat pbuf,"Timing Absolute ",str$(cntt)," ms"

            rcall SetWindowText,hTim,pbuf

          ; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        .endsw

      .case WM_CLOSE
        rcall SendMessage,hWin,WM_DESTROY,0,0

      .case WM_DESTROY
        rcall PostQuitMessage,NULL

    .endsw

    rcall DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Static_Control proc hparent:QWORD,instance:QWORD,topx:QWORD,topy:QWORD,wid:QWORD,hgt:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"STATIC", \
                          0,WS_CHILD or WS_VISIBLE or SS_CENTER,\           ;  or WS_BORDER
                          topx,topy,wid,hgt, \
                          hparent,0,instance,0
    ret

Static_Control endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

RemoteThread proc filename:QWORD

    rcall PostMessage,HWND_BROADCAST,WM_COMMAND,ForceActiv,0
    rcall winshell,filename,NORMAL_PRIORITY_CLASS
    rcall PostMessage,HWND_BROADCAST,WM_COMMAND,ThreadQuit,0
    rcall ExitThread,0

    ret

RemoteThread endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end










