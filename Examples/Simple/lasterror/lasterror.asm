; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    LOCAL lError :QWORD
 ;     LOCAL hInstance :QWORD
 ; 
 ;     mov hInstance, rvcall(GetModuleHandle,0)

    invoke SendMessage,0,WM_COMMAND,50,0                ; missing window handle
    mrm lError, LastError$()                            ; get the error status
    invoke MessageBox,0,lError,"LastError$()",MB_OK     ; display the last error

    invoke ExitProcess,0

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
