; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    externdef TestMsgBox:PROC
    externdef DLLlower:PROC

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    LOCAL ptxt :QWORD
    LOCAL rval :QWORD

    mrm ptxt, "UPPERCASE TEXT CONVERTED TO LOWER CASE"

    mov ptxt, rv(DLLlower,ptxt)                                 ; call a low level DLL procedure

    mov rval, rv(TestMsgBox,0,ptxt,"DLL Procedure",MB_YESNO)    ; call a high level DLL procedure

    .switch rval
      .case IDYES
        fn TestMsgBox,0,"You selected YES","Result",MB_OK
      .case IDNO
        fn TestMsgBox,0,"You selected NO","Result",MB_OK
      .default
        fn TestMsgBox,0,LastError$(),"Error",MB_OK
    .endsw

    invoke ExitProcess,0

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
