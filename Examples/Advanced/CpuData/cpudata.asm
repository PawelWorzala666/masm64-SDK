; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    include \masm64\include64\masm64rt.inc

    tbht equ <24>                       ; title bar height (use even numbers)
    lnps equ <tbht/2>                   ; tbht / 2 for line position
    wWid equ <525>                      ; window width
    wHgt equ <482>                      ; window height
    fntp equ <85.0>                     ; FP notation, font pecentage of title height
    ttxc equ <0000FF00h>                ; title bar text colour
    tcol equ <00252525h>                ; title bar back colour
    talg equ <DT_CENTER>                ; title bar text alignment
    ttxt equ "CPU and Memory Summary"   ; title bar text

    padd equ <240>
    lwid equ <155>
    indl equ <110>
    indr equ <80>

    include cpudata.inc

    .code

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

entry_point proc

    ; GdiPlusBegin                        ; initialise GDIPlus

    mov hInstance, rvcall(GetModuleHandle,0)
    mov hIcon,     rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_LOADTRANSPARENT)
    mov hCursor,   rvcall(LoadCursor,0,IDC_ARROW)
    mov sWid,      rvcall(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,      rvcall(GetSystemMetrics,SM_CYSCREEN)
    mov hBrush,    rvcall(CreateSolidBrush,00191919h)

    mov rax, tbht                       ; scale font to title bar height
    cvtsi2sd xmm0, rax
    divsd xmm0, AFL8(100.0)
    mulsd xmm0, AFL8(fntp)
    cvtsd2si r11, xmm0
    mov hFont, GetFontHandle("Tahoma",r11,800)  ; scaled font
    mov lFont, GetFontHandle("Tahoma",18,400)   ; light font
    mov bFont, GetFontHandle("Tahoma",18,800)   ; bold font

    call main

    ; GdiPlusEnd                          ; GdiPlus cleanup

    rcall ExitProcess,0

    ret

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

    mov wid, wWid
    mov hgt, wHgt

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
    invoke CreateWindowEx,WS_EX_LEFT, \
                          ADDR classname,ADDR caption, \
                          WS_POPUP or WS_VISIBLE,\
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

    mov pmsg, ptr$(msg)                     ; get the msg structure address
    jmp gmsg                                ; jump directly to GetMessage()

  mloop:
    .switch msg.message
      .case WM_KEYUP
        .switch msg.wParam
          .case VK_ESCAPE
            invoke SendMessage,hWnd,WM_COMMAND,61,0
        .endsw
    .endsw
    rcall TranslateMessage,pmsg
    rcall DispatchMessage,pmsg
  gmsg:
    test rax, rvcall(GetMessage,pmsg,0,0,0) ; loop until GetMessage returns zero
    jnz mloop

    ret

msgloop endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL pt    :POINT
    LOCAL ps    :PAINTSTRUCT
    LOCAL rct   :RECT
    LOCAL hDC   :QWORD
    LOCAL hOld  :QWORD

    LOCAL pbuf  :QWORD
    LOCAL buff[260]:BYTE

    LOCAL apnd  :QWORD
    LOCAL buf2[260]:BYTE

    LOCAL mse   :MEMORYSTATUSEX
    LOCAL syi   :SYSTEM___INFO
    LOCAL lpp   :QWORD
    LOCAL mstat :QWORD
    LOCAL astat :QWORD
    LOCAL wids  :QWORD
    LOCAL hgts  :QWORD

    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case 60
            invoke MsgboxI,hWin,"Wickedly Crafted In 64 Bit Microsoft Assembler <MASM>", \
                                "Isn't MASM Magnificent",MB_OK,10
          .case 61
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
        .endsw

      .case WM_CREATE
        invoke GetSystemInfo,ADDR syi
        mov mse.dwLength, SIZEOF MEMORYSTATUSEX             ; initialise length
        invoke GlobalMemoryStatusEx,ADDR mse                ; call API
      ; -----------------
      ; title bar buttons
      ; -----------------
        mov btn1, rv(transparent_button,hInstance,hWin,"¤",0,0,tbht,tbht,60,0)
        sett btn1, 00FFFFFFh, hFont

        rcall GetWindowRect,hWin,ptr$(rct)
        mov r11d, rct.right
        sub r11d, rct.left          ; get wWid
        sub r11d, tbht

        mov btn2, rv(transparent_button,hInstance,hWin,"×",r11d,0,tbht,tbht,61,0)
        sett btn2, 00FFFFFFh, hFont
      ; -------------------
      ; title and copyright
      ; -------------------
        mov hLabel1, rv(transparent_label,hInstance,hWin,"CPU and Windows Memory Information",indl,50,500,20,0,DT_LEFT)
        sett hLabel1,00EEEEEEh,lFont

        mov hLabel2, rv(transparent_label,hInstance,hWin,"Copyright © The MASM64 SDK 2022",indl,70,400,20,0,DT_LEFT)
        sett hLabel2,00EEEEEEh,lFont

        mov hLabel3, rv(transparent_label,hInstance,hWin,"All Rights Reserved",indl,90,400,20,0,DT_LEFT)
        sett hLabel3,00EEEEEEh,lFont
      ; -------------------

        mov hLabel4, rv(transparent_label,hInstance,hWin,"CPUID Reports . . .",indl,120,400,20,0,DT_LEFT)
        sett hLabel4,0000FF00h,bFont

      ; ------------------------
      ; CPU vendor and ID string
      ; ------------------------
        mov pbuf, ptr$(buff)
        rcall Get_Vendor,pbuf
        mov apnd, ptr$(buf2)
        mcat apnd,"Your CPU is ",pbuf

        mov hLabel5, rv(transparent_label,hInstance,hWin,apnd,indl,140,500,20,0,DT_LEFT)
        sett hLabel5,00EEEEEEh,lFont

        mov pbuf, ptr$(buff)
        rcall cpuid_string,pbuf

        mov hLabel6, rv(transparent_label,hInstance,hWin,pbuf,indl,160,500,20,0,DT_LEFT)
        sett hLabel6,00EEEEEEh,lFont
      ; ------------------------

        mov hLabel7, rv(transparent_label,hInstance,hWin,"Windows Reports . . . ",indl,190,200,20,0,DT_LEFT)
        sett hLabel7,0000FF00h,bFont

        xor rax, rax
        mov eax, syi.dwNumberOfProcessors
        mov lpp, rax
        mov hRslt1, rv(transparent_label,hInstance,hWin,str$(lpp),indr,210,lwid,20,0,DT_RIGHT)
        sett hRslt1,00EEEEEEh,lFont

        mov hDesc1, rv(transparent_label,hInstance,hWin," :  Logical Processors Present",padd,210,250,20,0,DT_LEFT)
        sett hDesc1,00EEEEEEh,lFont

        mcat pbuf, "0x",hex$(syi.lpMinimumApplicationAddress)
        mov hRslt2, rv(transparent_label,hInstance,hWin,pbuf,indr,230,lwid,20,0,DT_RIGHT)
        sett hRslt2,00EEEEEEh,lFont
        mov hDesc2, rv(transparent_label,hInstance,hWin," :  Lowest Application Address",padd,230,250,20,0,DT_LEFT)
        sett hDesc2,00EEEEEEh,lFont

        mcat pbuf,"0x",hex$(syi.lpMaximumApplicationAddress)
        mov hRslt3, rv(transparent_label,hInstance,hWin,pbuf,indr,250,lwid,20,0,DT_RIGHT)
        sett hRslt3,00EEEEEEh,lFont
        mov hDesc3, rv(transparent_label,hInstance,hWin," :  Highest Application Address",padd,250,250,20,0,DT_LEFT)
        sett hDesc3,00EEEEEEh,lFont

        mov mstat, rv(intdiv,mse.ullTotalPhys,1024*1024)
        mov hRslt4, rv(transparent_label,hInstance,hWin,str$(mstat),indr,270,lwid,20,0,DT_RIGHT)
        sett hRslt4,00EEEEEEh,lFont

        mov hDesc4, rv(transparent_label,hInstance,hWin," :  MB Total System Memory",padd,270,250,20,0,DT_LEFT)
        sett hDesc4,00EEEEEEh,lFont

        mov astat, rv(intdiv,mse.ullAvailPhys,1024*1024)
        mov hRslt5, rv(transparent_label,hInstance,hWin,str$(astat),indr,290,lwid,20,0,DT_RIGHT)
        sett hRslt5,00EEEEEEh,lFont

        mov hDesc5, rv(transparent_label,hInstance,hWin," :  MB Total Available Memory",padd,290,250,20,0,DT_LEFT)
        sett hDesc5,00EEEEEEh,lFont

        mov hRslt6, rv(transparent_label,hInstance,hWin,str$(syi.dwPageSize),indr,310,lwid,20,0,DT_RIGHT)
        sett hRslt6,00EEEEEEh,lFont

        mov hDesc6, rv(transparent_label,hInstance,hWin," :  Bytes VirtualAlloc Page Size",padd,310,250,20,0,DT_LEFT)
        sett hDesc6,00EEEEEEh,lFont

        mov wids, rv(GetSystemMetrics,SM_CXSCREEN)
        mov hgts, rv(GetSystemMetrics,SM_CYSCREEN)
        mcat pbuf,str$(wids)," x ",str$(hgts)
        mov hRslt7, rv(transparent_label,hInstance,hWin,pbuf,indr,330,lwid,20,0,DT_RIGHT)
        sett hRslt7,00EEEEEEh,lFont

        mov hDesc7, rv(transparent_label,hInstance,hWin," :  Screen resolution",padd,330,250,20,0,DT_LEFT)
        sett hDesc7,00EEEEEEh,lFont

        mov hLabel8, rv(transparent_label,hInstance,hWin,"CPUID Verified Instruction Sets . . .",indl,360,300,20,0,DT_LEFT)
        sett hLabel8,0000FF00h,bFont

        rcall mmi,p64                       ; call the procedure passing the structure address
        mov pbuf, ptr$(buff)
        rcall display_string,pbuf           ; get the supported instruction sets as a string

        mov hLabel9, rv(transparent_label,hInstance,hWin,pbuf,indl,380,400,20,0,DT_LEFT)
        sett hLabel9,00EEEEEEh,lFont

        mov wickedly, rv(transparent_label,hInstance,hWin,"Wickedly Crafted In 64 Bit Microsoft Assembler <MASM>",indl,410,450,20,0,DT_LEFT)
        sett wickedly,000000DDh,lFont

        mov btn3, rv(transparent_button,hInstance,hWin,"Close",410,440,90,22,61,1)
        sett btn3,0000FFFFh,bFont

        .return 0

      .case WM_NCHITTEST
        rcall GetCursorPos,ptr$(pt)
        rcall ScreenToClient,hWin,ptr$(pt)
        rcall GetWindowRect,hWin,ptr$(rct)
        mov r11d, rct.right
        sub r11d, rct.left          ; get wWid
        sub r11d, tbht
        cmp pt.x, r11d              ; right side cold spot
        ja @F
        cmp pt.x, tbht              ; left side cold spot
        jb @F
        cmp pt.y, tbht              ; ttlb height test
        ja @F
          cmp rvcall(DefWindowProc,hWin,uMsg,wParam,lParam), HTCLIENT
          jne @F
          mov rax, HTCAPTION
        @@:
        ret

      .case WM_PAINT
        rcall BeginPaint,hWin,ptr$(ps)
        invoke line,hWin,-1,lnps,sWid,lnps,tcol,tbht
        mov hDC, rvcall(GetDC,hWin)

      ; *****************************************

        rcall SetBkMode,hDC,TRANSPARENT
        rcall SetTextColor,hDC,ttxc

        mov rct.left, tbht
        mov rct.top, 0
        mov rct.right, wWid
        sub rct.right, tbht
        mov rct.bottom, tbht

        mov hOld, rv(SelectObject,hDC,hFont)

        invoke DrawText,hDC,ADDR ttlbartxt,-1,ADDR rct,DT_SINGLELINE or talg or DT_VCENTER

        rcall SelectObject,hOld

      ; *****************************************

        invoke DrawIconEx,hDC,21,50,hIcon,64,64,0,hBrush,DI_MASK

        rcall ReleaseDC,hWin,hDC
        rcall EndPaint,hWin,ptr$(ps)
        invoke InvalidateRect,btn1,NULL,TRUE    ; repaint the 2 buttons
        invoke InvalidateRect,btn2,NULL,TRUE

      .case WM_CLOSE
        rcall SendMessage,hWin,WM_DESTROY,0,0

      .case WM_DESTROY
        rcall PostQuitMessage,NULL

    .endsw

    rcall DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

 display_string proc pdis:QWORD

    LOCAL cloc  :QWORD

    mov cloc, 0

  ; INTEL

    .If x64.mmx eq 1
      mov cloc, rv(szappend,pdis,"mmx ",cloc)
    .EndIf

    .If x64.sse eq 1
      mov cloc, rv(szappend,pdis,"sse ",cloc)
    .EndIf

    .If x64.sse2 eq 1
      mov cloc, rv(szappend,pdis,"sse2 ",cloc)
    .EndIf

    .If x64.sse3 eq 1
      mov cloc, rv(szappend,pdis,"sse3 ",cloc)
    .EndIf

    .If x64.ssse3 eq 1
      mov cloc, rv(szappend,pdis,"ssse3 ",cloc)
    .EndIf

    .If x64.sse41 eq 1
      mov cloc, rv(szappend,pdis,"sse4.1 ",cloc)
    .EndIf

    .If x64.sse42 eq 1
      mov cloc, rv(szappend,pdis,"sse4.2 ",cloc)
    .EndIf

    .If x64.avx eq 1
      mov cloc, rv(szappend,pdis,"avx ",cloc)
    .EndIf

    .If x64.avx2 eq 1
      mov cloc, rv(szappend,pdis,"avx2 ",cloc)
    .EndIf

    .If x64.aes eq 1
      mov cloc, rv(szappend,pdis,"aes ",cloc)
    .EndIf

    .If x64.htt eq 1
      mov cloc, rv(szappend,pdis,"htt ",cloc)
    .EndIf

  ; AMD

    .If x64.mmxx eq 1
      mov cloc, rv(szappend,pdis,"mmx Extended ",cloc)
    .EndIf

    .If x64.amd3D eq 1
      mov cloc, rv(szappend,pdis,"3Dnow ",cloc)
    .EndIf

    .If x64.amd3x eq 1
      mov cloc, rv(szappend,pdis,"3Dnow Extended ",cloc)
    .EndIf

    ret

 display_string endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    end
