; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance dq ?
      hIcon     dq ?
      Edit1     dq ?
      Edit2     dq ?
      Edit3     dq ?

      lpEdit1Proc dq ?
      lpEdit2Proc dq ?
      lpEdit3Proc dq ?

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

  ; -----------------------
  ; get the instance handle
  ; -----------------------
    mov hInstance, rv(GetModuleHandle,0)

  ; -------------------------------------------------------------
  ; set the icon loaded size here to match the original icon size
  ; -------------------------------------------------------------
    mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,32,32,LR_DEFAULTCOLOR)

  ; ---------------------
  ; create a modal dialog
  ; ---------------------
    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon

  ; --------------------------------
  ; terminate app when dialog closes
  ; --------------------------------
    invoke ExitProcess,0

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    .switch uMsg
      .case WM_INITDIALOG
      ; ------------------------------------------------------
      ; lParam is the icon handle passed from DialogBoxParam()
      ; ------------------------------------------------------
        invoke SendMessage,hWin,WM_SETICON,1,lParam     ; set the icon for the dialog
        invoke SendMessage,rv(GetDlgItem,hWin,102), \   ; set the icon in the client area
               STM_SETIMAGE,IMAGE_ICON,lParam
        invoke SetWindowText,hWin,"Filtered Textbox Data Input"

        mov Edit1, rv(GetDlgItem,hWin,106)
        invoke SetWindowLongPtr,Edit1,GWL_WNDPROC,ADDR Edit1Proc
        mov lpEdit1Proc, rax

        mov Edit2, rv(GetDlgItem,hWin,107)
        invoke SetWindowLongPtr,Edit2,GWL_WNDPROC,ADDR Edit2Proc
        mov lpEdit2Proc, rax

        mov Edit3, rv(GetDlgItem,hWin,108)
        invoke SetWindowLongPtr,Edit3,GWL_WNDPROC,ADDR Edit3Proc
        mov lpEdit3Proc, rax

      ; ----------------------------------------------------
      ; set the focus to the first control by returning TRUE
      ; ----------------------------------------------------
        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 101
            jmp exit_dialog             ; The OK button
        .endsw

      .case WM_CLOSE
        exit_dialog:
        invoke EndDialog,hWin,0         ; exit from system menu
    .endsw

    xor rax, rax
    ret

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Edit1Proc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

  ; -------------
  ; Integers Only
  ; -------------
    .switch uMsg
      .case WM_CHAR
        cmp wParam, 8       ; accept back space
        je okchar
        cmp wParam, 48      ; reject anything below 48
        jb @F
        cmp wParam, 57      ; reject anything above 57
        ja @F
        jmp okchar

      @@:
        mov wParam, 0       ; send rejects here
        ret

    okchar:                 ; OK characters get processed normally
    .endsw

    invoke CallWindowProc,lpEdit1Proc,hWin,uMsg,wParam,lParam

    ret

Edit1Proc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Edit2Proc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL pbuf  :QWORD
    LOCAL buffer[64]:BYTE
    LOCAL var   :QWORD

  ; ------------------------
  ; Integer & floating point
  ; ------------------------
    .switch uMsg
      .case WM_CHAR
        cmp wParam, 8           ; accept back space
        je okchar
        cmp wParam, 46          ; allow period for floating point notation
        jne nxt1

      ; --------------------------------------------
      ; load text in text box and check for a period
      ; This allows for only one period, no extras.
      ; --------------------------------------------
        mov pbuf, ptr$(buffer)
        invoke GetWindowText,hWin,pbuf,64

      ; ---------------
      ; scan for period
      ; ---------------
        mov rax, pbuf
        sub rax, 1
      @@:
        add rax, 1
        cmp BYTE PTR [rax], 0   ; if it gets to the terminator there is no period
        je okchar
        cmp BYTE PTR [rax], 46  ; check if char is period
        jne @B                  ; loop back if its not
        mov wParam, 0           ; disallow extra period
        ret                     ; exit bypassing default handling
      ; ---------------

      nxt1:
        cmp wParam, 48          ; reject anything below 48
        jb @F
        cmp wParam, 57          ; reject anything above 57
        ja @F
        jmp okchar

      @@:
        mov wParam, 0           ; send rejects here
        ret

    okchar:                     ; OK characters get processed normally
    .endsw

    invoke CallWindowProc,lpEdit2Proc,hWin,uMsg,wParam,lParam

    ret

Edit2Proc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Edit3Proc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

  ; -----------------
  ; Mixed case Text Only Version
  ; upper, lower, backspace and space.
  ; -----------------

    .switch uMsg
      .case WM_CHAR
        cmp wParam, 8
        je okchar
        cmp wParam, 32
        je okchar
        jb reject
        cmp wParam, 65
        jb reject
        cmp wParam, 90
        jbe okchar
        cmp wParam, 97
        jb reject
        cmp wParam, 122
        ja reject
        jmp okchar

    reject:
      mov wParam, 0
      ret

    okchar:
    .endsw

    invoke CallWindowProc,lpEdit3Proc,hWin,uMsg,wParam,lParam

    ret

Edit3Proc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
