; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data?
      hInstance     dq ?    ; instance handle
      hIcon         dq ?    ; icon handle
      hList         dq ?    ; listbox handle
      lpListProc    dq ?    ; address of listbox subclass procedure

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
    .exit

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
        invoke SendMessage,rv(GetDlgItem,hWin,103), \   ; set the icon in the client area
               STM_SETIMAGE,IMAGE_ICON,lParam
        invoke SetWindowText,hWin,"List Box Demo"       ; set the dialog title programatically
        mov hList, rv(GetDlgItem,hWin,104)              ; get the list box handle

      ; -------------------------------------------------------------
      ; subclass the list box. This is done with the "subclass" tool.
      ; -------------------------------------------------------------
        invoke SetWindowLongPtr,hList,GWL_WNDPROC,ADDR ListProc
        mov lpListProc, rax

      ; -------------------------
      ; add items to the list box
      ; -------------------------
        invoke SendMessage,hList,LB_ADDSTRING,0,"One"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Two"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Three"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Four"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Five"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Six"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Seven"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Eight"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Nine"
        invoke SendMessage,hList,LB_ADDSTRING,0,"Ten"

      ; ----------------------------------------------------
      ; set the focus to the first control by returning TRUE
      ; ----------------------------------------------------
        .return TRUE

      .case WM_COMMAND
        .switch wParam
          .case 101
            invoke MessageBox,hWin,"Simple List Box Demo","About",MB_OK
          .case 102
            jmp exit_dialog             ; The Cancel button
        .endsw

      .case WM_CLOSE
        exit_dialog:
        invoke EndDialog,hWin,0         ; exit from system menu
    .endsw

    .return 0

main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

ListProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD

    LOCAL csel  :QWORD
    LOCAL lbuf  :QWORD
    LOCAL lbuffr[64]:BYTE

  ; -----------------------------
  ; Process control messages here
  ; -----------------------------
    .switch uMsg
      .case WM_LBUTTONDBLCLK
        mov csel, rv(SendMessage,hWin,LB_GETCURSEL,0,0)     ; get index of current selection
        mov lbuf, ptr$(lbuffr)                              ; set up a buffer to accept result
        invoke SendMessage,hWin,LB_GETTEXT,csel,lbuf        ; read selected text into buffer
        invoke MessageBox,hWin,lbuf,"You Selected",MB_OK    ; display result
    .endsw

    invoke CallWindowProc,lpListProc,hWin,uMsg,wParam,lParam

    ret

ListProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
