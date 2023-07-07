; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    include \masm32\include64\masm64rt.inc

    .code

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

get_current_line_index proc Edit:QWORD

  ; -------------------------------------------------
  ; the add and remove 1 space is to stop a loud DING
  ; when reaching the start or end of the line
  ; -------------------------------------------------
    LOCAL begin   :QWORD
    LOCAL cr      :CHARRANGE
    LOCAL urv     :QWORD
    LOCAL cpMin   :DWORD
    LOCAL cpMax   :DWORD

    invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr           ; get original selection

    mov eax, cr.cpMin
    mov cpMin, eax
    mov eax, cr.cpMax
    mov cpMax, eax

    invoke SendMessage,Edit,WM_CHAR,32,0                    ; insert 1 space
    invoke SendMessage,Edit,WM_KEYDOWN,VK_HOME,0            ; send HOME key

    invoke SendMessage,Edit,EM_EXGETSEL,0,ADDR cr           ; get current select after HOME key

    mov eax, cr.cpMin
    mov begin, rax                                          ; save it as the line beginning

    invoke SendMessage,Edit,WM_KEYDOWN,VK_END,0             ; send END key
    invoke SendMessage,Edit,WM_KEYDOWN,VK_BACK,0            ; delete the inserted space
    invoke SendMessage,Edit,EM_UNDO,0,0                     ; undo the last 2 keystrokes
    invoke SendMessage,Edit,EM_UNDO,0,0

    mov eax, cpMin
    mov cr.cpMin, eax
    mov eax, cpMax
    mov cr.cpMax, eax

    invoke SendMessage,Edit,EM_EXSETSEL,0,ADDR cr           ; restore previous selection

    mov rax, begin                                          ; return the line index

    ret

get_current_line_index endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    end
