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
      lpWndProc   dq ?                                              ; parent subclass address

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

    invoke MessageBox,hWnd,"I was created with the BarePI script.","Bare Plugin DLL",MB_OK

  ; |||||||||||||||||||||||||||||||||||||||||||||

  ; start any procedure, dialog or algorithm from
  ; here with full access to the editor's handles

  ; |||||||||||||||||||||||||||||||||||||||||||||

    ret

piInterface endp

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

    end
