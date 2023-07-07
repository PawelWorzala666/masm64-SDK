; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    include \masm64\include64\masm64rt.inc

    IFNDEF MEMORYSTATUSEX
      MEMORYSTATUSEX STRUCT 16
        dwLength dd ?
        dwMemoryLoad dd ?
        ullTotalPhys dq ?
        ullAvailPhys dq ?
        ullTotalPageFile dq ?
        ullAvailPageFile dq ?
        ullTotalVirtual dq ?
        ullAvailVirtual dq ?
        ullAvailExtendedVirtual dq ?
      MEMORYSTATUSEX ENDS
    ENDIF

    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBrush    dq ?
      hFont     dq ?
      allm      dq ?

      hDisp1    dq ?                ; static control result display
      hDisp2    dq ?
      hDisp3    dq ?

      hLbl1     dq ?                ; static labels
      hLbl2     dq ?
      hLbl3     dq ?

      hBtn1     dq ?                ; button handles
      hBtn2     dq ?
      hBtn3     dq ?

      Bmp1      dq ?                ; bitmap handles
      Bmp2      dq ?
      Bmp3      dq ?

    .data
      classname db "memstat2_class",0
      caption db "Memory Status",0
      ptitle    dq caption
      flag      dq 0                                        ; the thread exit flag
      mmax      dq 0                                        ; title bar flag

    .code

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

entry_point proc

    backcolor equ <00444444h>                               ; window back colour

    invoke CreateThread,0,0,ptr$(Thread),0,0,0              ; create the polling thread
    rcall CloseHandle, rax

    ics equ <48>                                            
    ; icon size

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,ics,ics,LR_DEFAULTCOLOR)

    mov Bmp1,      rv(LoadImage,hInstance,20,IMAGE_BITMAP,80,20,LR_DEFAULTCOLOR)    ; button bitmaps
    mov Bmp2,      rv(LoadImage,hInstance,25,IMAGE_BITMAP,80,20,LR_DEFAULTCOLOR)
    mov Bmp3,      rv(LoadImage,hInstance,30,IMAGE_BITMAP,80,20,LR_DEFAULTCOLOR)

    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rvcall(CreateSolidBrush,backcolor)
    mov hFont,     GetFontHandle("Segoe UI",18,600)

    call main

    .exit

entry_point endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

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

    mov wid, 245
    mov hgt, 135

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
                          WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
                          lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd, rax

    invoke SetWindowPos,hWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE

    call msgloop

    ret

main endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

msgloop proc

    LOCAL msg    :MSG
    LOCAL pmsg   :QWORD

    mov pmsg, ptr$(msg)                                     ; get the msg structure address
    jmp gmsg                                                ; jump directly to GetMessage()

  mloop:
    .switch msg.message
      .case WM_KEYUP
        .switch msg.wParam
          .case VK_ESCAPE
            rcall SendMessage,hWnd,WM_COMMAND,202,0         ; exit on escape key
          .case VK_SPACE
            rcall SendMessage,hWnd,WM_COMMAND,202,0         ; exit on space bar
          .case VK_M
            rcall SendMessage,hWnd,WM_COMMAND,201,0         ; M to minimise
        .endsw
    .endsw
    rcall TranslateMessage,pmsg
    rcall DispatchMessage,pmsg
  gmsg:
    test rax, rvcall(GetMessage,pmsg,0,0,0)                 ; loop until GetMessage returns zero
    jnz mloop

    ret

msgloop endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL hDC   :QWORD
    LOCAL ps    :PAINTSTRUCT
    LOCAL dfbuff[260]:BYTE
    LOCAL mse   :MEMORYSTATUSEX
    LOCAL pbuf  :QWORD
    LOCAL buff[64]:BYTE
    LOCAL rslt  :QWORD

    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case 200
            .data
              tmsg db "MemStat v2 - Real Time Sampling x64 Memory Status Tool",13,10
                   db "Copyright © The MASM64 SDK 2022, All Rights Reserved",13,10
                   db "Wickedly Crafted In 64 Bit Microsoft Assembler <MASM>",0
              pmsg dq tmsg
            .code
            invoke MsgboxI,hWin,pmsg, "  Isn't  MASM  Magnificent",MB_OK,10

          .case 201
            LowPriority                                     ; set low priority on minimize
            rcall ShowWindow,hWin,SW_MINIMIZE               ; minimise the dialog
            mov mmax, 1

          .case 202
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
        .endsw

      .case WM_SETFOCUS
        NormalPriority                                      ; set normal priority with focus
        mov mmax, 0
        rcall SetWindowText,hWin,ptitle

      .case WM_CREATE
        sbdr equ <0>
        slft equ <0>
        mrm hWnd, hWin
        mov hLbl1, rv(static_control, "GB Total :",slft,10,80,20,sbdr,WS_EX_RIGHT)
        mov hLbl2, rv(static_control, "GB  Free :",slft,35,80,20,sbdr,WS_EX_RIGHT)
        mov hLbl2, rv(static_control,  "GB Used :",slft,60,80,20,sbdr,WS_EX_RIGHT)

        ldis equ <85>
        wdis equ <40>

        mov hDisp1, rv(static_control,    "0",ldis,10,wdis,20,sbdr,WS_EX_LEFT)
        mov hDisp2, rv(static_control,    "0",ldis,35,wdis,20,sbdr,WS_EX_LEFT)
        mov hDisp3, rv(static_control,    "0",ldis,60,wdis,20,sbdr,WS_EX_LEFT)

        blft equ <135>

        mov hBtn1, rv(push_button,0,blft,10,80,20,200)
        mov hBtn2, rv(push_button,0,blft,35,80,20,201)
        mov hBtn3, rv(push_button,0,blft,60,80,20,202)

        rcall SendMessage,hBtn1,BM_SETIMAGE,IMAGE_BITMAP,Bmp1
        rcall SendMessage,hBtn2,BM_SETIMAGE,IMAGE_BITMAP,Bmp2
        rcall SendMessage,hBtn3,BM_SETIMAGE,IMAGE_BITMAP,Bmp3

        mov mse.dwLength, SIZEOF MEMORYSTATUSEX             ; initialise length
        invoke GlobalMemoryStatusEx,ADDR mse                ; call API
        mov pbuf, ptr$(buff)
        cvtsi2sd xmm0, mse.ullTotalPhys                     ; convert to scalar double
        divsd xmm0, AFL8(1073741824.0)                      ; div by 1 gig
        movsd allm, xmm0                                    ; store result in GLOBAL
        movsd rslt, xmm0                                    ; convert to REAL8
        rcall fptoa,rslt,pbuf                               ; convert REAL8 to string
        rcall truncate,pbuf,2                               ; truncate to 2 decimal places
        mcat pbuf, pbuf," gigabytes"
        rcall SetWindowText,hDisp1,pbuf                     ; display installed memory

        .return 0

      .case WM_CTLCOLORSTATIC                               ; static controls
        rcall SetBkColor,wParam,backcolor

        col1 equ <000080FFh>                                ; data colour
        col2 equ <0001D8FEh>                                ; lead colour

        mov rax, lParam
        .switch rax
          .case hDisp1
            rcall SetTextColor,wParam,col1
            jmp @F
          .case hDisp2
            rcall SetTextColor,wParam,col1
            jmp @F
          .case hDisp3
            rcall SetTextColor,wParam,col1
            jmp @F
        .endsw

        rcall SetTextColor,wParam,col2

        @@:

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

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

static_control proc ptxt:QWORD,tx:QWORD,ty:QWORD,wd:QWORD,ht:QWORD,bdr:QWORD,aln:QWORD

    LOCAL sStyle :QWORD
    LOCAL alignd :QWORD
    LOCAL hndl   :QWORD

    mov sStyle, WS_CHILD or WS_VISIBLE or SS_LEFT

    .if bdr == 1
      or sStyle, WS_BORDER
    .endif

    invoke CreateWindowEx,aln,"STATIC",ptxt,sStyle,tx,ty,wd,ht,hWnd,0,hInstance,0
    mov hndl, rax

    rcall SendMessage,hndl,WM_SETFONT,hFont,TRUE

    mov rax, hndl

    ret

static_control endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

push_button proc ptext:QWORD,tx:QWORD,ty:QWORD,wd:QWORD,ht:QWORD,idnum:QWORD

    invoke CreateWindowEx,WS_EX_LEFT,"BUTTON",ptext, \
                          WS_CHILD or WS_VISIBLE or BS_BITMAP,\
                          tx,ty,wd,ht,hWnd,idnum,hInstance,0
    ret

push_button endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

Thread proc arg:QWORD

    LOCAL mse   :MEMORYSTATUSEX
    LOCAL rslt  :REAL8
    LOCAL avlb  :REAL8
    LOCAL pbuf  :QWORD
    LOCAL buff[96]:BYTE

    mov pbuf, ptr$(buff)                                    ; get pointer to buffer

  lbl:
    rcall SleepEx,250,0                                     ; set poll interval
    mov mse.dwLength, SIZEOF MEMORYSTATUSEX                 ; initialise length
    invoke GlobalMemoryStatusEx,ADDR mse                    ; call API

    cvtsi2sd xmm0, mse.ullAvailPhys                         ; convert to scalar double
    divsd xmm0, AFL8(1073741824.0)                          ; div by 1 gig
    movsd avlb, xmm0                                        ; store result in variable
    movsd rslt, xmm0                                        ; convert to REAL8
    rcall fptoa,rslt,pbuf                                   ; convert REAL8 to string
    rcall truncate,pbuf,2                                   ; truncate to 2 decimal places

    cmp mmax, 0
    jne @F
      mcat pbuf,pbuf," gigabytes"                           ; static label text
      rcall SetWindowText,hDisp2,pbuf
      jmp nxt
    @@:
      mcat pbuf,pbuf," gigabytes free"                      ; the task bar text
      rcall SetWindowText,hWnd,pbuf
    nxt:

    movsd xmm0, allm                                        ; reload total memory
    movsd xmm1, avlb                                        ; reload available memory
    subsd xmm0, xmm1                                        ; subtract available from total
    movsd rslt, xmm0                                        ; store result in REAL8
    rcall fptoa,rslt,pbuf                                   ; convert REAL8 to string
    rcall truncate,pbuf,2                                   ; truncate to 2 decimal places
    mcat pbuf,pbuf," gigabytes"                             ; create text for used memory
    rcall SetWindowText,hDisp3,pbuf                         ; display the text

    cmp flag, 0                                             ; test if the exit flag is zero
    je lbl                                                  ; continue loop while flag == 0

    ret

Thread endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    end
