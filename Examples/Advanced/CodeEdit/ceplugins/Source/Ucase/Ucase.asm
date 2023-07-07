; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

    include \masm64\include64\masm64rt.inc

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

  ; -------------------------------------------
  ; Build this DLL with the provided MAKEIT.BAT
  ; -------------------------------------------

    .data?
      hInstance   dq ?
      hWnd        dq ?
      hMenu       dq ?
      hEdit       dq ?
      hStatus     dq ?
      hToolbar    dq ?

    .code

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

PluginEntryPoint proc instance:QWORD,reason:QWORD,unused:QWORD 

    .if reason == DLL_PROCESS_ATTACH
      mrm hInstance, instance                                       ; copy stack arg to global
      mov rax, TRUE                                                 ; return TRUE so DLL will start
    .endif

    ret

PluginEntryPoint endp

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

piInterface proc hWin:QWORD,Menu:QWORD,Edit:QWORD,tbar:QWORD,sbar:QWORD

  ; ------------------------------------
  ; load arguments into GLOBAL variables
  ; ------------------------------------
    mrm hWnd,     hWin
    mrm hMenu,    Menu
    mrm hEdit,    Edit
    mrm hToolbar, tbar
    mrm hStatus,  sbar

    rcall upper_case                                                ; run a single algorithm

    ret

piInterface endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

 upper_case proc

    LOCAL cr    :CHARRANGE
    LOCAL ptxt  :QWORD
    LOCAL tlen  :QWORD
    LOCAL pMem  :QWORD

    invoke SendMessage,hEdit,EM_EXGETSEL,0,ADDR cr                  ; get the character range

    mov eax, cr.cpMax
    sub eax, cr.cpMin
    mov tlen, rax                                                   ; selection length

    mov pMem, alloc(tlen)

    invoke SendMessage,hEdit,EM_GETSELTEXT,0,pMem                   ; current line written to tbuf

    invoke szUpper,pMem

    mov pMem, rax

    invoke SendMessage,hEdit,EM_REPLACESEL,TRUE,pMem                ; set the character range

    invoke SendMessage,hEdit,EM_EXSETSEL,0,ADDR cr                  ; get the character range

    mfree pMem

    ret

 upper_case endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    end
