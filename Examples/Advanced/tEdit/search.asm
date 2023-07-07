; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 replace_text proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL nbuff[260]:BYTE
    LOCAL pbuff :QWORD
    LOCAL tln   :QWORD
    LOCAL cr    :CHARRANGE

    .switch uMsg
      .case WM_INITDIALOG
        mov FndEd,  rv(GetDlgItem,hWin,1001)
        invoke SetWindowLongPtr,FndEd,GWL_WNDPROC,ADDR FndEdProc1
        mov lpFndEdProc1, rax

        mov BtnUp,  rv(GetDlgItem,hWin,1002)
        mov BtnDn,  rv(GetDlgItem,hWin,1003)
        mov BtnQt,  rv(GetDlgItem,hWin,1005)
        mov Chk1,   rv(GetDlgItem,hWin,1006)
        mov Chk2,   rv(GetDlgItem,hWin,1007)
        mov fImage, rv(GetDlgItem,hWin,1008)

        mov RepEd,  rv(GetDlgItem,hWin,1009)
        invoke SetWindowLongPtr,RepEd,GWL_WNDPROC,ADDR RepEdProc
        mov lpRepEdProc, rax

        mov RepBtn, rv(GetDlgItem,hWin,1010)

      ; ---------------
      ; whole word flag
      ; ---------------
        .if wwRep == 1
          rcall SendMessage,Chk1,BM_SETCHECK,BST_CHECKED,0
        .endif

      ; -------------------
      ; case sensitive flag
      ; -------------------
        .if csRep == 1
          rcall SendMessage,Chk2,BM_SETCHECK,BST_CHECKED,0
        .endif


        rcall SendMessage,fImage,STM_SETIMAGE,IMAGE_ICON,hIcon     ; large icon
        rcall SendMessage,hWin,WM_SETICON,1,hIcon                  ; title bar icon
        mov rax, TRUE
        ret

      .case WM_COMMAND
        .switch wParam
          .case 1002
          search_up:
            mov pbuff, ptr$(nbuff)
            rcall GetWindowText,FndEd,pbuff,260
            mov rax, pbuff
            cmp BYTE PTR [rax], 0
            je @F
          ; ---------------------
          ; call search from here
          ; ---------------------
            mov sdflag, 0
            mov tln, rv(GetWindowTextLength,FndEd)
            add tln, 1
            rcall TextFind,pbuff,tln,hWin
            cmp rax, -1
            jne @F
            fn MessageBox,hWin,"No Further Matches","Search",MB_OK
          ; ---------------------
          @@:
            rcall SetFocus,FndEd

          .case 1003
          search_down:
            mov pbuff, ptr$(nbuff)
            rcall GetWindowText,FndEd,pbuff,260
            mov rax, pbuff
            cmp BYTE PTR [rax], 0
            je @F
          ; ---------------------
          ; call search from here
          ; ---------------------
            mov sdflag, 1
            mov tln, rv(GetWindowTextLength,FndEd)
            add tln, 1
            rcall TextFind,pbuff,tln,hWin
            cmp rax, -1
            jne @F
            fn MessageBox,hWin,"No Further Matches","Search",MB_OK
          ; ---------------------
          @@:
            rcall SetFocus,FndEd

          .case 1005
            jmp exit_dialog

          .case 1006
            .if rv(SendMessage,Chk1,BM_GETCHECK,0,0) == BST_CHECKED
              mov wwRep, 1
            .else
              mov wwRep, 0
            .endif
            rcall SetFocus,FndEd

          .case 1007
            .if rv(SendMessage,Chk2,BM_GETCHECK,0,0) == BST_CHECKED
              mov csRep, 1
            .else
              mov csRep, 0
            .endif
            rcall SetFocus,FndEd

          .case 1010                    ; replace text button
          ; -------------------------------------------
          ; test if both dlg edit controls have content
          ; -------------------------------------------
            .if rv(GetWindowTextLength,FndEd) == 0
              rcall SetFocus,FndEd
              xor rax, rax
              ret
            .endif
            .if rv(GetWindowTextLength,RepEd) == 0
              rcall SetFocus,RepEd
              xor rax, rax
              ret
            .endif

          ; --------------------------------------------------
          ; check if text is selected in the main edit control
          ; --------------------------------------------------
            invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr
            mov eax, cr.cpMin
            cmp eax, cr.cpMax
            jne @F
            fn MessageBox,hWin,"There is no text selected to replace.","Find the text first",MB_OK
            ret
          @@:
          ; ----------------
          ; replace the text
          ; ----------------
            mov pbuff, ptr$(nbuff)
            rcall GetWindowText,RepEd,pbuff,260
            rcall SendMessage,hEdit,EM_REPLACESEL,TRUE,pbuff
            rcall SetFocus,FndEd
        .endsw

      .case WM_CLOSE
        exit_dialog:
        mov ssrch, 0                    ; clear the single instance flag
        rcall EndDialog,hWin,0          ; exit from system menu

    .endsw

    xor rax, rax
    ret

 replace_text endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

FndEdProc1 proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

  ; -------------------------------------------
  ; First edit control subclass for replace dlg
  ; -------------------------------------------

    .if uMsg == WM_CHAR
      .switch wParam
        .case 9
          rcall SetFocus, RepEd
          xor rax, rax
          ret
        .case 13
          rcall SetFocus, RepEd
          xor rax, rax
          ret
        .case 27
          rcall SendMessage,rv(GetParent,hWin),WM_CLOSE,0,0        ; close parent
          xor rax, rax
          ret
      .endsw

    .elseif uMsg == WM_KEYDOWN
      .switch wParam
        .case VK_UP
          rcall SendMessage,rv(GetParent,hWin),WM_COMMAND,1002,0   ; up button
          xor rax, rax
          ret
        .case VK_DOWN
          rcall SendMessage,rv(GetParent,hWin),WM_COMMAND,1003,0   ; down button
          xor rax, rax
          ret
      .endsw

    .endif

    invoke CallWindowProc,lpFndEdProc1,hWin,uMsg,wParam,lParam

    ret

FndEdProc1 endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

RepEdProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

  ; -----------------------------
  ; Process control messages here
  ; -----------------------------

    .if uMsg == WM_CHAR
      .switch wParam
        .case 9
          rcall SetFocus, RepEd
          xor rax, rax
          ret
        .case 13

        .case 27
          rcall SendMessage,rv(GetParent,hWin),WM_CLOSE,0,0        ; close parent
          xor rax, rax
          ret
      .endsw

    .elseif uMsg == WM_KEYDOWN
      .switch wParam
        .case VK_UP
          rcall SendMessage,rv(GetParent,hWin),WM_COMMAND,1002,0   ; up button
          xor rax, rax
          ret
        .case VK_DOWN
          rcall SendMessage,rv(GetParent,hWin),WM_COMMAND,1003,0   ; down button
          xor rax, rax
          ret
      .endsw

    .endif

    invoke CallWindowProc,lpRepEdProc,hWin,uMsg,wParam,lParam

    ret

RepEdProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 find_text proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL nbuff[260]:BYTE
    LOCAL pbuff :QWORD
    LOCAL tln   :QWORD

    .switch uMsg
      .case WM_INITDIALOG
        mov FndEd,  rv(GetDlgItem,hWin,1001)

       ; ------------------------------------------------
       ; subclass the edit control to process key strokes
       ; ------------------------------------------------
        invoke SetWindowLongPtr,FndEd,GWL_WNDPROC,ADDR FndEdProc
        mov lpFndEdProc, rax

        mov BtnUp,  rv(GetDlgItem,hWin,1002)
        mov BtnDn,  rv(GetDlgItem,hWin,1003)
        mov BtnQt,  rv(GetDlgItem,hWin,1005)
        mov Chk1,   rv(GetDlgItem,hWin,1006)
        mov Chk2,   rv(GetDlgItem,hWin,1007)
        mov fImage, rv(GetDlgItem,hWin,1008)

      ; ---------------
      ; whole word flag
      ; ---------------
        .if wwflag == 1
          rcall SendMessage,Chk1,BM_SETCHECK,BST_CHECKED,0
        .endif

      ; -------------------
      ; case sensitive flag
      ; -------------------
        .if csflag == 1
          rcall SendMessage,Chk2,BM_SETCHECK,BST_CHECKED,0
        .endif

        rcall SendMessage,fImage,STM_SETIMAGE,IMAGE_ICON,hIcon     ; large icon
        rcall SendMessage,hWin,WM_SETICON,1,hIcon                  ; title bar icon
        mov rax, TRUE
        ret

      .case WM_COMMAND
        .switch wParam
          .case 1002
          search_up:
            mov pbuff, ptr$(nbuff)
            rcall GetWindowText,FndEd,pbuff,260
            mov rax, pbuff
            cmp BYTE PTR [rax], 0
            je @F
          ; ---------------------
          ; call search from here
          ; ---------------------
            mov sdflag, 0
            mov tln, rv(GetWindowTextLength,FndEd)
            add tln, 1
            rcall TextFind,pbuff,tln,hWin
            cmp rax, -1
            jne @F
            rcall MessageBox,hWin,"No Further Matches","Search",MB_OK
          ; ---------------------
          @@:
            invoke SetFocus,FndEd

          .case 1003
          search_down:
            mov pbuff, ptr$(nbuff)
            rcall GetWindowText,FndEd,pbuff,260
            mov rax, pbuff
            cmp BYTE PTR [rax], 0
            je @F
          ; ---------------------
          ; call search from here
          ; ---------------------
            mov sdflag, 1
            mov tln, rv(GetWindowTextLength,FndEd)
            add tln, 1
            rcall TextFind,pbuff,tln,hWin
            cmp rax, -1
            jne @F
            rcall MessageBox,hWin,"No Further Matches","Search",MB_OK
          ; ---------------------
          @@:
            rcall SetFocus,FndEd

          .case 1005
            jmp exit_dialog

          .case 1006
            .if rv(SendMessage,Chk1,BM_GETCHECK,0,0) == BST_CHECKED
              mov wwflag, 1
            .else
              mov wwflag, 0
            .endif
            rcall SetFocus,FndEd

          .case 1007
            .if rv(SendMessage,Chk2,BM_GETCHECK,0,0) == BST_CHECKED
              mov csflag, 1
            .else
              mov csflag, 0
            .endif
            rcall SetFocus,FndEd

        .endsw

      .case WM_CLOSE
        exit_dialog:
        mov ssrch, 0                    ; clear the single instance flag
        rcall EndDialog,hWin,0          ; exit from system menu

    .endsw

    xor rax, rax
    ret

 find_text endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

FndEdProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

  ; -----------------------------
  ; Process control messages here
  ; -----------------------------

    .if uMsg == WM_CHAR
      .switch wParam
        .case 13
          rcall SendMessage,rv(GetParent,hWin),WM_COMMAND,1003,0   ; down button
          xor rax, rax
          ret
        .case 27
          rcall SendMessage,rv(GetParent,hWin),WM_CLOSE,0,0        ; close parent
          xor rax, rax
          ret
      .endsw

    .elseif uMsg == WM_KEYDOWN
      .switch wParam
        .case VK_UP
          rcall SendMessage,rv(GetParent,hWin),WM_COMMAND,1002,0   ; up button
          xor rax, rax
          ret
        .case VK_DOWN
          rcall SendMessage,rv(GetParent,hWin),WM_COMMAND,1003,0   ; down button
          xor rax, rax
          ret

      .endsw

    .endif

    invoke CallWindowProc,lpFndEdProc,hWin,uMsg,wParam,lParam

    ret

FndEdProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

TextFind proc lpBuffer:QWORD, tlen:QWORD, hDlg:QWORD

    LOCAL tp :DWORD
    LOCAL tl :DWORD
    LOCAL sch:QWORD
    LOCAL ft :FINDTEXTEX
    LOCAL Cr :CHARRANGE

    rcall SendMessage,hEdit,WM_GETTEXTLENGTH,0,0
    mov tl, eax

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR Cr

    .if sdflag == 0                 ; backwards
      nop                           ; do nothing
    .else                           ; forwards
      add Cr.cpMin, 1               ; inc starting pos by 1 so not searching same position repeatedly
    .endif

    mrmd ft.chrg.cpMin, Cr.cpMin    ; start pos
    mrmd ft.chrg.cpMax, tl          ; end of text
    mrm ft.lpstrText, lpBuffer      ; string to search for
    mrmd ft.chrgText.cpMin, Cr.cpMax
    mrmd ft.chrgText.cpMax, tl

    ; 0 = case insensitive
    ; 1 = FR_DOWN                   ; search backwards
    ; 2 = FT_WHOLEWORD
    ; 4 = FT_MATCHCASE
    ; 6 = FT_WHOLEWORD or FT_MATCHCASE

    mov sch, FR_DOWN

    .if sdflag == 1
      mov sch, FR_DOWN              ; search backwards
    .else
      mov sch, 0                    ; search forward
    .endif

    .if csflag == 1
      or sch, 4
    .endif
    .if wwflag == 1
      or sch, 2
    .endif

    invoke SendMessage,hEdit,EM_FINDTEXTEX,sch,ADDR ft
    mov tp, eax

    rcall SetFocus,hDlg

    .if tp == -1
      mov rax, -1
      ret
    .endif

    mrmd Cr.cpMin,tp                ; put start pos into structure
    dec tlen                        ; dec length for zero terminator
    mov rax, tlen
    add tp,eax                      ; add length to character pos
    mrmd Cr.cpMax,tp                ; put end pos into structure

    ; ------------------------------------
    ; set the selection to the search word
    ; ------------------------------------
    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR Cr

    xor rax, rax

    ret

TextFind endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい
