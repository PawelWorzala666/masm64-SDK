; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    include \masm64\include64\masm64rt.inc

    .code

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

entry_point proc

    LOCAL pmem2 :QWORD

	LOCAL pmem :QWORD

    LOCAL nlen :QWORD
    LOCAL real :QWORD

    conout lf,"  realloc test",lf,lf

  ; ---------------------------------------

    conout "  -------------------------",lf
    conout "  Increase allocated memory",lf
    conout "  -------------------------",lf

    mov pmem2, alloc(1024)

    mov nlen, msize(pmem2)
    conout " v2  old length = ",str$(nlen),lf

    mov pmem, alloc(1024)

    mov pmem2, realloc(pmem2,1024*1024)

    mov nlen, msize(pmem2)
    conout " 2v new length = ",str$(nlen),lf,lf

mov pmem, realloc(pmem,1024*1024)

    mov nlen, msize(pmem)
    conout "  old length = ",str$(nlen),lf

    mov nlen, msize(pmem2)
    conout " 2v2 new length = ",str$(nlen),lf,lf

    mfree pmem

 

    waitkey "  Press any key to continue ..."

    invoke ExitProcess,0

    ret

entry_point endp


    end
