; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm64\include64\masm64rt.inc
  ; ----------------------------------------------------------------------------------------
  ; NOTE : The quality of the PAD is the controlling factor on how strong the encryption is.
  ;        The pad should be a unique random pad that is effectively not reproducable.
  ;        This pad below is purely for demonstration purposes.
  ; ----------------------------------------------------------------------------------------

    .data
      padd db "123456789012345678901234567890123456789012345678901234567890",0
      blen dq SIZEOF padd
      ppad dq padd

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

entry_point proc

    LOCAL st1  :QWORD
    LOCAL slen :QWORD

    mrm st1, "Cannons to right of us, cannons to left of us"
    mov slen, len(st1)
    sub blen, 1

    invoke xor_data,st1,slen,ppad,blen          ; xor string against pad to encrypt
    conout "Encrypted data = ",st1,lf           ; display encrypted result

    invoke xor_data,st1,slen,ppad,blen          ; xor string against pad to decrypt
    conout "Decrypted data = ",st1,lf           ; display decrypted data

    waitkey

    invoke ExitProcess,0

    ret

entry_point endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
