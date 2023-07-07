; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    USING r14,r15                               ; specify registers to preserve

    LOCAL arrmem :QWORD
    LOCAL buffer[64]:BYTE
    LOCAL pbuf :QWORD
    LOCAL strt$ :QWORD

    SaveRegs                                    ; preserve registers in USING list

    mrm strt$, "The number = "

    icnt equ <16384>

    mov arrmem, rv(fixed_array,icnt,32)         ; allocate the array

  ; -----------------------
  ; load array with strings
  ; -----------------------
    mov r14, 0
    mov r15, arrmem
  @@:
    mov pbuf, ptr$(buffer)                      ; get buffer pointer
    mcat pbuf,strt$,str$(r14)                   ; join the strings
    invoke mcopy,pbuf, \
           QWORD PTR [r15+r14*8], len(pbuf)     ; load each string into array
    add r14, 1
    cmp r14, icnt
    jb @B
  ; ---------------------------------
  ; display the contents of the array
  ; ---------------------------------
    mov r14, 0
    mov r15, arrmem
  @@:
    conout QWORD PTR [r15+r14*8],lf             ; display each string in array
    add r14, 1
    cmp r14, icnt
    jb @B
  ; ---------------------------------

    waitkey                                     ; pause to see results

    mfree arrmem                                ; release array memory
    RestoreRegs                                 ; restore preserved registers
    invoke ExitProcess,0                        ; terminate process

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
