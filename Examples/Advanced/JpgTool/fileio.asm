; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

load_disk_image proc hWin:QWORD,iwid:QWORD

    LOCAL hFile :QWORD
    LOCAL hImg  :QWORD
    LOCAL wBMP  :QWORD
    LOCAL hBMP  :QWORD
    LOCAL ihgt  :QWORD                              ; image height

    LOCAL outp  :QWORD                              ; pointer for text buffer
    LOCAL obuf[64]:BYTE                             ; text buffer

    LOCAL pttl  :QWORD
    LOCAL tbuf[260]:BYTE

    .data
      fpatn db "All Files",0,"*.*",0,0
      ppatn dq fpatn
    .code
    rcall open_file_dialog,hWin,hInstance,"Open an image file - BMP JPG PNG TIF GIF",ppatn
    cmp BYTE PTR [rax], 0
    je bye                                          ; branch to end if canceled

    mov hFile, rax                                  ; store the file name in hFile

    .If oFlag ne 0                                  ; if a previous image was loaded
      rcall DeleteObject,hBitmap                    ; delete previous bitmap
    .EndIf

    mov oFlag, 1                                    ; set the file loaded flag

    rcall SetWindowText,hWin,"Loading ...."         ; display loading for long loads

    mov hBitmap, rvcall(LoadGdiImage,hFile)         ; load disk file as bitmap handle

    .If hBitmap eq 0
      mov pttl, ptr$(tbuf)
      rcall MessageBox,hWin,hFile, \
           "Invalid File Type",MB_ICONINFORMATION
      ret
    .EndIf

    invoke CopyImage,hBitmap,IMAGE_BITMAP, \
                     0,0,LR_COPYRETURNORG           ; make copy of original BMP
    mov hImg, rax

    rcall GetBmpSize,hImg
    mov wBMP, rax                                   ; bitmap width
    mov hBMP, rcx                                   ; bitmap height

    mov oWid, rax
    mov oHgt, rcx

    mov rax, iwid
    cmp wBMP, rax
    jge @F

    rcall getpercent,sHgt,80
    cmp hBMP, rax
    jb nxt
    jmp @F

  nxt:
    mrm iwid, wBMP
    mrm ihgt, hBMP
    jmp icopy

  @@:
    cvtsi2sd xmm0, wBMP                             ; convert width to floating point
    cvtsi2sd xmm1, hBMP                             ; convert height to floating point

    .If wBMP ge hBMP
      cvtsi2sd xmm2, iwid                           ; convert reference width to floating point
      divsd xmm0, xmm1                              ; calculate aspect ratio
      divsd xmm2, xmm0                              ; divide reference width by aspect ratio
      cvtsd2si rax, xmm2                            ; convert back to integer for height
      mov ihgt, rax                                 ; store as QWORD
    .EndIf

    .If hBMP gt wBMP
      divsd xmm0, xmm1                              ; calculate aspect ratio
      cvtsi2sd xmm2, sHgt                           ; the screen height
      mulsd xmm2, AFL8(0.6)                         ; multiply by 0.6
      cvtsd2si rax, xmm2
      mov ihgt, rax                                 ; convert back to integer for height
      mulsd xmm2, xmm0
      cvtsd2si rax, xmm2
      mov iwid, rax                                 ; convert back to integer for width
    .EndIf

  icopy:

    invoke CopyImage,hImg,IMAGE_BITMAP, \
                     iwid,ihgt,LR_COPYDELETEORG     ; resize and delete copy
    mov hImg, rax

    rcall SendMessage,hImgBox,STM_SETIMAGE, \
          IMAGE_BITMAP,hImg                         ; write image to static control

    mov outp, ptr$(obuf)                            ; get pointer to text buffer
    mcat outp," File Is Loaded At : ", \
                str$(wBMP)," x ", \
                str$(hBMP)," Pixels"                ; combine the strings

    rcall SendMessage,hStatus,SB_SETTEXT,0,outp     ; display string on status bar

    rcall SetWindowText,hWin,hFile                  ; display file name on title bar

    rcall szCopy,hFile,ptitle                       ; preserve file name into ptitle

  bye:
    ret

load_disk_image endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

save_JPG_image proc hWin:QWORD

    LOCAL fname :QWORD
    LOCAL nubmp :QWORD
    LOCAL rval  :QWORD
    LOCAL hFile :QWORD
    LOCAL flen  :QWORD

    LOCAL pbuf  :QWORD
    LOCAL buff[260]:BYTE

    .data
      jpgpatn db "JPG Files",0,"*.jpg",0,0
      PtrJPG dq jpgpatn
    .code
      rcall save_file_dialog,hWin,hInstance,"Save image as JPG",PtrJPG
      mov fname, rax
      cmp BYTE PTR [rax], 0
      jne @F
      ret
    @@:

    rcall FixExtension,fname,".jpg"
    mov fname, rax

  ; ------------------
  ; JPG quality dialog
  ; ------------------
    mov rval, rv(DialogBoxParam,hInstance,600,hWin,ADDR jpgdlg,hIcon)     ; get quality

    .If rval eq 0
      ret
    .EndIf

  ; -------------------------------------
  ; set the scaling for the image to save
  ; -------------------------------------
    mov rval, rv(DialogBoxParam,hInstance,1100,hWin,ADDR ScaleDlg,hIcon)

    .If rval eq 0
      ret
    .EndIf

    rcall scale_image_by_size,hWin,hBitmap,oWid,oHgt
    mov nubmp, rax

  ; ||||||||||||||||||||||||||||||||||||||

    rcall Gdip_Save_JPG,nubmp,fname,jqlity

  ; ||||||||||||||||||||||||||||||||||||||

    mov hFile, flopen(fname)
    mov flen, flsize(hFile)                                 ; get the size of the saved file
    flclose hFile

    mov pbuf, ptr$(buff)
    mcat pbuf,"File written to disk at ",str$(flen)," bytes"
    rcall NameFromPath,fname,fname                          ; strip path

    invoke MsgboxI,hWin,pbuf,fname,MB_OK,10                 ; display result

    rcall saved_image_size,oWid,oHgt,flen                   ; write result to status bar

    ret

save_JPG_image endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

saved_image_size proc wd:QWORD,ht:QWORD,cnt:QWORD

    LOCAL sbTxt :QWORD
    LOCAL sbBuf[128]:BYTE

    mov sbTxt, ptr$(sbBuf)                                  ; get pointer to buffer
    mcat sbTxt," Image Sized To ", \
                 str$(wd)," x ", \
                 str$(ht)," Pixels At ", \
                 str$(cnt)," bytes"                         ; combine all of the strings

    rcall SendMessage,hStatus,SB_SETTEXT,0,sbTxt            ; display result on status bar

    ret

saved_image_size endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい
