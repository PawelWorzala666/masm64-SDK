; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    LOCAL pMem :QWORD           ; allocated memory pointer
    LOCAL aMem :QWORD           ; aligned memory pointer

    mbyt equ <4>                ; number of megabytes
    bcnt equ <1024*1024*mbyt>   ; 1 meg * multiplier
    maln equ <256>              ; required alignment, must be a power of 2
    padd equ <maln*2>           ; extra bytes to allow for required alignment

    conout lf,"Allocate ",str$(mbyt)," megabytes bytes of memory aligned to a ",str$(maln)," byte boundary",lf

    mov pMem, alloc(bcnt+padd)  ; allocate the memory plus padding
    memalign rax, maln          ; align the memory up to the next 256 byte boundary
    mov aMem, rax               ; store result in aligned memory pointer

    conout lf,"Memory address pMem 0",hex$(pMem),"h",lf, \
           lf,"aligned to a ",str$(maln)," byte boundary at",lf, \
           lf,"memory address aMem 0",hex$(aMem),"h",lf,lf

    waitkey

    mfree pMem                  ; free memory at the original allocated address

    invoke ExitProcess,0

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
