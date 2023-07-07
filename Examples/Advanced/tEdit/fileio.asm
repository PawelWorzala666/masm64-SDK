; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

LoadFileThread proc arg:QWORD

  lbl:
    mov btFlag, 0
    rcall stream_file_in,hEdit,pFile
    rcall PostMessage,hWnd,PM_LOADDONE,0,0
    rcall SuspendThread,rvcall(GetCurrentThread)
    jmp lbl

    ret

LoadFileThread endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

SaveFileThread proc arg:QWORD

  lbl:
    mov btFlag, 0
    rcall stream_file_out,hEdit,pFile
    rcall PostMessage,hWnd,PM_SAVEDONE,0,0
    rcall SuspendThread,rvcall(GetCurrentThread)
    jmp lbl

    ret

SaveFileThread endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

stream_file_in proc edit:QWORD,lpszFileName:QWORD

    LOCAL hFile :QWORD
    LOCAL est   :EDITSTREAM

    invoke CreateFile,lpszFileName,GENERIC_READ,FILE_SHARE_READ, \
                      NULL,OPEN_EXISTING,NULL,FILE_ATTRIBUTE_NORMAL
    mov hFile, rax

    mrm est.dwCookie, hFile
    mov est.dwError, 0
    mov rax, offset cb_Open_File
    mov est.pfnCallback, rax

    invoke SendMessage,edit,EM_STREAMIN,SF_TEXT,ADDR est
    invoke CloseHandle,hFile
    invoke SendMessage,edit,EM_SETMODIFY,0,0

    rcall SetWindowText,hWnd,ptitle

    xor rax, rax
    ret

stream_file_in endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

cb_Open_File proc dwCookie:QWORD,pbBuff:QWORD,cb:QWORD,pcb:QWORD

  ; -------------------------------------------------------------------
  ; this callback procedure is called by the "stream_file_in" procedure
  ; -------------------------------------------------------------------

    LOCAL buffer[64]:BYTE
    LOCAL pbuf  :QWORD

    mov pbuf, ptr$(buffer)
    mov rax, cb
    add btFlag, rax

    mcat pbuf,str$(btFlag)," bytes read"
    rcall SetWindowText,hWnd,pbuf

    invoke ReadFile,dwCookie,pbBuff,cb,pcb,NULL
    xor rax, rax
    ret

cb_Open_File endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

stream_file_out proc edit:QWORD,lpszFileName:QWORD

    LOCAL hFile :QWORD
    LOCAL est   :EDITSTREAM

    invoke CreateFile,lpszFileName,GENERIC_WRITE,FILE_SHARE_WRITE,NULL, \
                      CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
    mov hFile, rax

    mrm est.dwCookie, hFile
    mov est.dwError, 0
    mov rax, offset cb_Save_File
    mov est.pfnCallback, rax

    invoke SendMessage,edit,EM_STREAMOUT,SF_TEXT,ADDR est

    invoke CloseHandle,hFile

    invoke SendMessage,edit,EM_SETMODIFY,0,0

    rcall SetWindowText,hWnd,ptitle

    xor rax, rax
    ret

stream_file_out endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

cb_Save_File proc dwCookie:QWORD,pbBuff:QWORD,cb:QWORD,pcb:QWORD

  ; --------------------------------------------------------------------
  ; this callback procedure is called by the "stream_file_out" procedure
  ; --------------------------------------------------------------------

    LOCAL buffer[64]:BYTE
    LOCAL pbuf  :QWORD

    mov pbuf, ptr$(buffer)
    mov rax, cb
    add btFlag, rax

    mcat pbuf,str$(btFlag)," bytes written"
    rcall SetWindowText,hWnd,pbuf

    invoke WriteFile,dwCookie,pbBuff,cb,pcb,NULL
    xor rax, rax
    ret

cb_Save_File endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 confirmation proc parent:QWORD,edit:QWORD

  ; ------------------------------------------------------
  ; return values
  ; 0 = proceed with following operation, new or open file
  ; 1 = cancel following operation
  ; ------------------------------------------------------
    LOCAL nbuff[260]:BYTE
    LOCAL pbuff :QWORD

    invoke SendMessage,edit,EM_GETMODIFY,0,0
    test rax, rax       ; test if EM_GETMODIFY = 0
    jnz continue        ; jump forward if edit control modified
    ret                 ; if unmodified, exit with RAX = 0

  continue:
    invoke MsgboxI,parent,"File is not saved, save it now ?","Confirmation",MB_YESNOCANCEL,10

    .switch rax
      .case IDYES
        rcall GetWindowText,parent,pFile,260
        rcall szCmp,pFile,"Untitled"
        test rax, rax
        jnz @F

        rcall stream_file_out,edit,pFile
        rcall SetWindowText,parent,pFile
        rcall SendMessage,edit,EM_SETMODIFY,FALSE,0

        xor rax, rax
        ret
      @@:
        invoke save_file_dialog,parent,hInstance,"Save File As ...",chr$("*.*",0,0)
        mov pFile, rax
        cmp BYTE PTR [rax], 0
        je @F

        rcall stream_file_out,edit,pFile
        rcall SetWindowText,parent,pFile
        rcall SendMessage,edit,EM_SETMODIFY,FALSE,0

        xor rax, rax
        ret
      @@:
      .case IDNO
        xor rax, rax
        ret
      .case IDCANCEL
        mov rax, 1
        ret
    .endsw

    ret

 confirmation endp

 ; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい
