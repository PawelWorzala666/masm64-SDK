; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    include binpath.inc

    externdef getpercent:PROC

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

aspect_ratio proc winhgt:QWORD,pcntadd:QWORD

  ; ------------------------------------------
  ; winhgt   = window height
  ; pcntadd  = % increase to get maximum width
  ; ------------------------------------------

    fn getpercent,winhgt,pcntadd
    add rax, winhgt

    ret

aspect_ratio endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい�

    end
