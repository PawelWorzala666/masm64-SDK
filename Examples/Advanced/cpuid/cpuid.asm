; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc

    .data
      x64 X64ST <>      ; empty structure
      p64 dq x64        ; pointer to structure

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 entry_point proc

    LOCAL cloc  :QWORD
    LOCAL pbuf  :QWORD
    LOCAL buff[128]:BYTE

    LOCAL pdis  :QWORD
    LOCAL dbuf[256]:BYTE

    mov pbuf, ptr$(buff)

    rcall Get_Vendor,pbuf

    conout lf,"  The CPU Brand is ",pbuf,lf

    rcall cpuid_string,pbuf                         ; call procedure
    conout "  The CPU model is ",pbuf,lf,lf         ; get the CPU model string

    conout "  Available Instruction Sets",lf,lf
    conout cfm$("  1 = supported\n  0 = not supported\n\n")

    rcall mmi,p64                                   ; call mmi with struct address as arg

    conout "  ",str$(x64.mmx)," mmx",lf
    conout "  ",str$(x64.sse)," sse",lf
    conout "  ",str$(x64.sse2)," sse2",lf
    conout "  ",str$(x64.sse3)," sse3",lf
    conout "  ",str$(x64.ssse3)," ssse3",lf
    conout "  ",str$(x64.sse41)," sse4.1",lf
    conout "  ",str$(x64.sse42)," sse4.2",lf
    conout "  ",str$(x64.avx)," avx",lf
    conout "  ",str$(x64.avx2)," avx2",lf
    conout "  ",str$(x64.aes)," aes",lf
    conout "  ",str$(x64.htt)," htt",lf,lf

    conout "  AMD Specific",lf,lf

    conout "  ",str$(x64.mmxx)," mmx Ext",lf
    conout "  ",str$(x64.amd3D)," 3Dnow",lf
    conout "  ",str$(x64.amd3x)," 3Dnow Ext",lf

    mov pdis, ptr$(dbuf)                            ; get pointer to display buffer
    rcall display_string,pdis                       ; construct display string
    conout lf,"  Instruction Sets : ",pdis,lf       ; display at console

    waitkey cfm$("\n  Press any key ....\n")
    .exit

 entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

 display_string proc pdis:QWORD

    LOCAL cloc  :QWORD

    mov cloc, 0

  ; INTEL

    .If x64.mmx eq 1
      mov cloc, rv(szappend,pdis,"mmx ",cloc)
    .EndIf

    .If x64.sse eq 1
      mov cloc, rv(szappend,pdis,"sse ",cloc)
    .EndIf

    .If x64.sse2 eq 1
      mov cloc, rv(szappend,pdis,"sse2 ",cloc)
    .EndIf

    .If x64.sse3 eq 1
      mov cloc, rv(szappend,pdis,"sse3 ",cloc)
    .EndIf

    .If x64.ssse3 eq 1
      mov cloc, rv(szappend,pdis,"ssse3 ",cloc)
    .EndIf

    .If x64.sse41 eq 1
      mov cloc, rv(szappend,pdis,"sse4.1 ",cloc)
    .EndIf

    .If x64.sse42 eq 1
      mov cloc, rv(szappend,pdis,"sse4.2 ",cloc)
    .EndIf

    .If x64.avx eq 1
      mov cloc, rv(szappend,pdis,"avx ",cloc)
    .EndIf

    .If x64.avx2 eq 1
      mov cloc, rv(szappend,pdis,"avx2 ",cloc)
    .EndIf

    .If x64.aes eq 1
      mov cloc, rv(szappend,pdis,"aes ",cloc)
    .EndIf

    .If x64.htt eq 1
      mov cloc, rv(szappend,pdis,"htt ",cloc)
    .EndIf

  ; AMD

    .If x64.mmxx eq 1
      mov cloc, rv(szappend,pdis,"mmx Extended ",cloc)
    .EndIf

    .If x64.amd3D eq 1
      mov cloc, rv(szappend,pdis,"3Dnow ",cloc)
    .EndIf

    .If x64.amd3x eq 1
      mov cloc, rv(szappend,pdis,"3Dnow Extended ",cloc)
    .EndIf

    ret

 display_string endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
