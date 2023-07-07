; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

About proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_INITDIALOG
        rcall SendMessage,hWin,WM_SETICON,1,lParam          ; set the icon for the dialog
        rcall SendMessage,rvcall(GetDlgItem,hWin,1501), \   ; set the icon in the client area
              STM_SETIMAGE,IMAGE_ICON,lParam

        bkcol equ <00444444h>    ; button background colour
        txcol equ <000000FFh>    ; button text colour
        hvcol equ <0000FFFFh>    ; button text hover colour
        btnID equ <250>          ; ID for WM_COMMAND processing

        invoke colr_button,"OK",hInstance,hWin, \
               368,173,90,25,btnID,bkcol,txcol,hvcol
        mov aButn1, rax                                     ; Save the control handle
        rcall SendMessage,aButn1,WM_SETFONT,hFont1,TRUE

        mov lbl1, rvcall(GetDlgItem,hWin,1502)
        rcall SendMessage,lbl1,WM_SETFONT,hFont2,TRUE

      .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 250
            jmp exit_dialog                                 ; The OK button

          .case 2
            jmp exit_dialog                                 ; exit on keystroke

        .endsw

      .case WM_CTLCOLORDLG                                  ; set static control colour
        rcall SetBkColor,wParam,00333333h
        rcall SetTextColor,wParam,00EEEEEEh                 ; 000000FFh
        rcall CreateSolidBrush,00333333h
        ret

      .case WM_CTLCOLORSTATIC                               ; set static control colour
        rcall SetBkColor,wParam,00333333h
        rcall SetTextColor,wParam,00DDDDDDh
        rcall CreateSolidBrush,00333333h
        ret

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0         ; exit from system menu
    .endsw

    xor rax, rax
    ret

About endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

jpgdlg proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL ptxt1 :QWORD
    LOCAL ptxt2 :QWORD

    LOCAL txt1[64]:BYTE
    LOCAL txt2[64]:BYTE

    .switch uMsg
      .case WM_INITDIALOG
        rcall SendMessage,hWin,WM_SETICON,1,lParam          ; set the icon for the dialog
        rcall SendMessage,rvcall(GetDlgItem,hWin,605), \    ; set the icon in the client area
              STM_SETIMAGE,IMAGE_ICON,lParam

        mov jEdit1, rvcall(GetDlgItem,hWin,602)
        invoke SetWindowLongPtr,jEdit1,GWL_WNDPROC,ADDR jEdit1Proc
        mov lpjEdit1Proc, rax

        mov jEdit2, rvcall(GetDlgItem,hWin,606)
        invoke SetWindowLongPtr,jEdit2,GWL_WNDPROC,ADDR jEdit2Proc
        mov lpjEdit2Proc, rax

        rcall SetWindowText,jEdit1,str$(jscale)
        rcall SetWindowText,jEdit2,str$(jqlity)

        rcall SetFocus,jEdit2
        rcall SendMessage,jEdit2,WM_KEYDOWN,VK_END,0

      .case WM_COMMAND
        .switch wParam
          .case 603
            mov ptxt1, ptr$(txt1)
            mov ptxt2, ptr$(txt2)
            rcall GetWindowText,jEdit1,ptxt1,64
            rcall GetWindowText,jEdit2,ptxt2,64

            mov jscale, uval(ptxt1)                         ; set the global scaling and quality values
            mov jqlity, uval(ptxt2)

            .If jqlity gt 100
              mov jqlity, 100
            .EndIf

            rcall EndDialog,hWin,1                          ; exit with non zero

          .case 604
            jmp exit_dialog                                 ; The Cancel button
        .endsw

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0                              ; exit with zero
    .endsw

    xor rax, rax
    ret

jpgdlg endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

jEdit1Proc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
  ; ----------------------------------
  ; numbers, back space and enter only
  ; ----------------------------------
    .If uMsg eq WM_CHAR
      .switch wParam
        .case 8                     ; allow backspace
          jmp dodef
        .case 13                    ; set focus to 2nd edit control on ENTER
          rcall SetFocus, jEdit2
          rcall SendMessage,jEdit2,WM_KEYDOWN,VK_END,0
      .endsw

      .If wParam ge 48              ; set char range to numbers only
        .If wParam le 57
          jmp dodef
        .EndIf
      .EndIf

      ret                           ; exit on non allowed characters
    .EndIf

  dodef:                            ; default handler label

    invoke CallWindowProc,lpjEdit1Proc,hWin,uMsg,wParam,lParam

    ret

jEdit1Proc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

jEdit2Proc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
  ; ----------------------------------
  ; numbers, back space and enter only
  ; ----------------------------------
    .If uMsg eq WM_CHAR
      .switch wParam
        .case 8                     ; allow backspace
          jmp dodef
        .case 13                    ; send message on ENTER
          rcall SendMessage,rvcall(GetParent,hWin),WM_COMMAND,603,0
          .return 0
      .endsw

      .If wParam ge 48              ; set char range to numbers only
        .If wParam le 57
          jmp dodef
        .EndIf
      .EndIf

      ret                           ; exit on non allowed characters

    .EndIf

  dodef:                            ; default handler label

    invoke CallWindowProc,lpjEdit2Proc,hWin,uMsg,wParam,lParam

    ret

jEdit2Proc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

ScaleDlg proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL obuf :QWORD
    LOCAL buff[32]:BYTE

    .switch uMsg
      .case WM_INITDIALOG
        rcall SendMessage,hWin,WM_SETICON,1,lParam          ; set the icon for the dialog
        rcall SendMessage,rvcall(GetDlgItem,hWin,114), \    ; set the icon in the client area
              STM_SETIMAGE,IMAGE_ICON,lParam

        mov hlbl1, rvcall(GetDlgItem,hWin,102)
        mov hlbl2, rvcall(GetDlgItem,hWin,104)

        mov hText1, rvcall(GetDlgItem,hWin,111)
        rcall SetWindowLongPtr,hText1,GWL_WNDPROC,ptr$(Text1Proc)
        mov lpText1Proc, rax

        mov hText2, rvcall(GetDlgItem,hWin,113)
        rcall SetWindowLongPtr,hText2,GWL_WNDPROC,ptr$(Text1Proc)
        mov lpText2Proc, rax

        rcall SetWindowText,hlbl1,str$(oWid)
        rcall SetWindowText,hlbl2,str$(oHgt)
        rcall SetWindowText,hText1,str$(oWid)
        rcall SetWindowText,hText2,str$(oHgt)

        rcall PostMessage,hText1,WM_KEYDOWN,VK_END,0

        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 1
            mov obuf, ptr$(buff)
            rcall GetWindowText,hText1,obuf,32

            .If len(obuf) eq 0
              rcall SetFocus,hText1
              ret
            .EndIf

            mov oWid, uval(obuf)                            ; return integer in GLOBAL
            rcall GetWindowText,hText2,obuf,32

            .If len(obuf) eq 0
              rcall SetFocus,hText2
              ret
            .EndIf

            mov oHgt, uval(obuf)                            ; return integer in GLOBAL
            rcall EndDialog,hWin,1                          ; exit dialog

          .case 2
            jmp exit_dialog                                 ; The Cancel button
        .endsw

      .case WM_CLOSE
        exit_dialog:
        rcall EndDialog,hWin,0                              ; exit from system menu
    .endsw

    xor rax, rax
    ret

ScaleDlg endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Text1Proc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD  ; adjust WIDTH

    LOCAL ptxt  :QWORD
    LOCAL text[64]:BYTE
    LOCAL nwid  :QWORD

    .switch uMsg

      .case WM_CHAR                                 ; only allow numbers backspace and enter
        cmp wParam, 8
        je deflbl
        cmp wParam, 13
        je deflbl
        cmp wParam, 48
        jge @F
        ret
      @@:
        cmp wParam, 57
        jbe @F
        ret
      @@:

      .case WM_KEYUP
        mov ptxt, ptr$(text)                        ; pointer to output buffer
        rcall GetWindowText,hWin,ptxt,64            ; get current edit text
        mov nwid, uval(ptxt)                        ; convert current value in edit control

        cvtsi2sd xmm4, oWid                         ; convert original width to floating point
        cvtsi2sd xmm3, oHgt                         ; convert original height to floating point
        divsd xmm4, xmm3                            ; divide width by height for aspect ratio

        cvtsi2sd xmm2, nwid                         ; convert new width to floating point
        divsd xmm2, xmm4                            ; divide it by aspect ratio
        cvtsd2si rax, xmm2                          ; convert result back to integer
        mov ptxt, rax                               ; save it in variable

        rcall SetWindowText,hText2,str$(ptxt)       ; set new value in height edit control

    .endsw

    deflbl:

    invoke CallWindowProc,lpText1Proc,hWin,uMsg,wParam,lParam

    ret

Text1Proc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Text2Proc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD  ; adjust HEIGHT

    LOCAL ptxt  :QWORD
    LOCAL text[64]:BYTE
    LOCAL nwid  :QWORD

    .switch uMsg
      .case WM_CHAR                                 ; only allow numbers backspace and enter
        cmp wParam, 8
        je deflbl
        cmp wParam, 13
        je deflbl
        cmp wParam, 48
        jge @F
        ret
      @@:
        cmp wParam, 57
        jbe @F
        ret
      @@:

      .case WM_KEYUP
        mov ptxt, ptr$(text)                        ; pointer to output buffer
        rcall GetWindowText,hWin,ptxt,64            ; get current edit text
        mov nwid, uval(ptxt)                        ; convert current value in edit control

        cvtsi2sd xmm3, oWid                         ; convert original width to floating point
        cvtsi2sd xmm4, oHgt                         ; convert original height to floating point
        divsd xmm4, xmm3                            ; divide width by height for aspect ratio

        cvtsi2sd xmm2, nwid                         ; convert new width to floating point
        divsd xmm2, xmm4                            ; divide it by aspect ratio
        cvtsd2si rax, xmm2                          ; convert result back to integer
        mov ptxt, rax                               ; save it in variable

        rcall SetWindowText,hText1,str$(ptxt)       ; set new value in width edit control
    .endsw

    deflbl:

    invoke CallWindowProc,lpText2Proc,hWin,uMsg,wParam,lParam

    ret

Text2Proc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい
