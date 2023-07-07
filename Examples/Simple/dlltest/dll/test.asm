; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    ; -------------------------------------------
    ; Build this DLL with the provided MAKEIT.BAT
    ; -------------------------------------------

      .data?
        hInstance dq ?

      .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

LibMain proc instance:QWORD,reason:QWORD,unused:QWORD 

    .if reason == DLL_PROCESS_ATTACH
      mrm hInstance, instance               ; copy local to global
      mov rax, TRUE                         ; return TRUE so DLL will start

    .elseif reason == DLL_PROCESS_DETACH

    .elseif reason == DLL_THREAD_ATTACH

    .elseif reason == DLL_THREAD_DETACH

    .endif

    ret

LibMain endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

  comment * -------------------------------------------------------
          You should add the procedures your DLL requires AFTER
          the LibMain procedure. For each procedure that you
          wish to EXPORT you must place its name in the "test.def"
          file so that the linker will know which procedures to
          put in the EXPORT table in the DLL. Use the following
          syntax AFTER the LIBRARY name on the 1st line.
          LIBRARY test
          EXPORTS YourProcName
          EXPORTS AnotherProcName
          ------------------------------------------------------- *

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

TestMsgBox proc hndl:QWORD,text:QWORD,titl:QWORD,mbstyle:QWORD

    fn MessageBox,hndl,text,titl,mbstyle

  ; return value is in RAX

    ret

TestMsgBox endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

DLLlower proc

  ; rcx = address of string

    mov rax, rcx
    sub rax, 1

  @@:
    add rax, 1
    cmp BYTE PTR [rax], 0
    je @F
    cmp BYTE PTR [rax], "A"
    jb @B
    cmp BYTE PTR [rax], "Z"
    ja @B
    add BYTE PTR [rax], 32
    jmp @B
  @@:

    mov rax, rcx

    ret

DLLlower endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end

























