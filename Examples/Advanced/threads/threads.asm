; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    include \masm64\include64\masm64rt.inc

    .code

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

entry_point proc

    LOCAL rvar1 :QWORD          ; thread return value
    LOCAL rvar2 :QWORD          ; thread return value
    LOCAL rvar3 :QWORD          ; thread return value
    LOCAL rvar4 :QWORD          ; thread return value
    LOCAL rvar5 :QWORD          ; thread return value
    LOCAL rvar6 :QWORD          ; thread return value
    LOCAL rvar7 :QWORD          ; thread return value
    LOCAL rvar8 :QWORD          ; thread return value

    LOCAL pvar1 :QWORD          ; its pointer
    LOCAL pvar2 :QWORD          ; its pointer
    LOCAL pvar3 :QWORD          ; its pointer
    LOCAL pvar4 :QWORD          ; its pointer
    LOCAL pvar5 :QWORD          ; its pointer
    LOCAL pvar6 :QWORD          ; its pointer
    LOCAL pvar7 :QWORD          ; its pointer
    LOCAL pvar8 :QWORD          ; its pointer
    LOCAL result:QWORD
    LOCAL tc    :QWORD

    mov pvar1, ptr$(rvar1)      ; load address into pointer
    mov rvar1, 0                ; set rvar1 to 0
    mov pvar2, ptr$(rvar2)      ; load address into pointer
    mov rvar2, 0                ; set rvar2 to 0
    mov pvar3, ptr$(rvar3)      ; load address into pointer
    mov rvar3, 0                ; set rvar3 to 0
    mov pvar4, ptr$(rvar4)      ; load address into pointer
    mov rvar4, 0                ; set rvar4 to 0
    mov pvar5, ptr$(rvar5)      ; load address into pointer
    mov rvar5, 0                ; set rvar5 to 0
    mov pvar6, ptr$(rvar6)      ; load address into pointer
    mov rvar6, 0                ; set rvar6 to 0
    mov pvar7, ptr$(rvar7)      ; load address into pointer
    mov rvar7, 0                ; set rvar7 to 0
    mov pvar8, ptr$(rvar8)      ; load address into pointer
    mov rvar8, 0                ; set rvar8 to 0

    fn callthread,0,1,pvar1
    fn callthread,0,2,pvar2
    fn callthread,0,3,pvar3
    fn callthread,0,4,pvar4
    fn callthread,0,5,pvar5
    fn callthread,0,6,pvar6
    fn callthread,0,7,pvar7
    fn callthread,0,8,pvar8

    mov tc, rv(GetTickCount)
    add tc, 30000               ; add 30 seconds for timeout

  ; --------------------------------------
  ; wait until all threads have terminated
  ; --------------------------------------
  @@:
    fn SleepEx,1,0              ; 1 timeslice delay
    fn GetTickCount             ; check duration for timeout
    cmp rax, tc
    jae timeout                 ; exit on timeout delay
    xor r11, r11
    add r11, rvar1              ; add all the indicators together
    add r11, rvar2
    add r11, rvar3
    add r11, rvar4
    add r11, rvar5
    add r11, rvar6
    add r11, rvar7
    add r11, rvar8
    cmp r11, 8
    jne @B                      ; terminate the loop when all threads have exited
    jmp nxt

  timeout:
    conout "Operation timed out",lf
    jmp bye

  nxt:
    mov result, r11

    conout lf,"--------------------------",lf, \
              "thread finished count = ",str$(result),lf, \
              "--------------------------",lf,lf
  bye:
    waitkey

    invoke ExitProcess,0

    ret

entry_point endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

callthread proc a1:QWORD,a2:QWORD,a3:QWORD

    LOCAL arr[8]   :QWORD
    LOCAL hThread  :QWORD
    LOCAL hProcess :QWORD

    mov hProcess, rv(GetCurrentProcess)

    invoke SetPriorityClass,hProcess,HIGH_PRIORITY_CLASS

    lea r10, arr                    ; load the array address
    mov QWORD PTR [r10],    0       ; first member is the flag to be tested set to zero
    mrm QWORD PTR [r10+8],  a1
    mrm QWORD PTR [r10+16], a2
    mrm QWORD PTR [r10+24], a3

    mov hThread, rv(CreateThread,0,0,ADDR threadproc,ADDR arr,0,0)

  ; --------------------------------------------------------
  ; spinlock ensures the arguments are written to the thread
  ; before the call to close the thread handle is made.
  ; NOTE : "pause" is not used here as it is too slow.
  ; --------------------------------------------------------
    lea rax, arr
  spinlock:                         ; loop until flag NE 0
    cmp QWORD PTR [rax], 0
    je spinlock

    conout "Thread ",str$(a2)," started",lf

    fn CloseHandle, hThread

    invoke SetPriorityClass,hProcess,NORMAL_PRIORITY_CLASS

    ret

callthread endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

threadproc proc arg:QWORD

    LOCAL arg1 :QWORD
    LOCAL arg2 :QWORD
    LOCAL arg3 :QWORD

  ; ------------------------------------------------------
  ; copy arguments to LOCAL values before setting the flag
  ; ------------------------------------------------------
  ; arg is passed in RCX

    mrm arg1, QWORD PTR [rcx+8]
    mrm arg2, QWORD PTR [rcx+16]
    mrm arg3, QWORD PTR [rcx+24]

  ; -----------------------------------------------------
  ; set the flag to be evaluated by the calling spinlock
  ; -----------------------------------------------------
    mov QWORD PTR [rcx], 1

  @@:
    ; conout str$(arg1),lf
    add arg1, 1
    cmp arg1, 1000000000
    jbe @B

    conout "thread ",str$(arg2)," finished",lf

  ; -------------------------------------------
  ; increment the initial thread closed counter
  ; -------------------------------------------
    mov rax, arg3
    add QWORD PTR [rax], 1

    ret

threadproc endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    end
