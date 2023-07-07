
    sett MACRO hndl, coulr, font
      rcall SendMessage,hndl,WM_COMMAND,0,coulr
      rcall SendMessage,hndl,WM_SETFONT,font,TRUE
    ENDM

    IFNDEF MEMORYSTATUSEX
      MEMORYSTATUSEX STRUCT 16
        dwLength dd ?
        dwMemoryLoad dd ?
        ullTotalPhys dq ?
        ullAvailPhys dq ?
        ullTotalPageFile dq ?
        ullAvailPageFile dq ?
        ullTotalVirtual dq ?
        ullAvailVirtual dq ?
        ullAvailExtendedVirtual dq ?
      MEMORYSTATUSEX ENDS
    ENDIF

    IFNDEF SYSTEM___INFO
      SYSTEM___INFO STRUCT 16
          UNION
          dwOemId dd ?
            STRUCT
              wProcessorArchitecture dw ?
              wReserved dw ?
            ENDS
          ENDS
        dwPageSize dd ?
        lpMinimumApplicationAddress dq ?
        lpMaximumApplicationAddress dq ?
        dwActiveProcessorMask dq ?
        dwNumberOfProcessors dd ?
        dwProcessorType dd ?
        dwAllocationGranularity dd ?
        wProcessorLevel dw ?
        wProcessorRevision dw ?
      SYSTEM___INFO ENDS
    ENDIF


    .data?
      hInstance dq ?
      hWnd      dq ?
      hIcon     dq ?
      hCursor   dq ?
      sWid      dq ?
      sHgt      dq ?
      hBrush    dq ?
      hFont     dq ?
      lFont     dq ?
      bFont     dq ?
      btn1      dq ?
      btn2      dq ?
      btn3      dq ?

      hLabel1   dq ?
      hLabel2   dq ?
      hLabel3   dq ?
      hLabel4   dq ?
      hLabel5   dq ?
      hLabel6   dq ?
      hLabel7   dq ?
      hLabel8   dq ?
      hLabel9   dq ?
      wickedly  dq ?

      hRslt1    dq ?
      hRslt2    dq ?
      hRslt3    dq ?
      hRslt4    dq ?
      hRslt5    dq ?
      hRslt6    dq ?
      hRslt7    dq ?
      hRslt8    dq ?

      hDesc1    dq ?
      hDesc2    dq ?
      hDesc3    dq ?
      hDesc4    dq ?
      hDesc5    dq ?
      hDesc6    dq ?
      hDesc7    dq ?
      hDesc8    dq ?

    .data
      classname db "new_hittest_class",0
      caption db "Unused",0
      ttlbartxt db ttxt,0
      x64 X64ST <>              ; empty structure
      p64 dq x64 
