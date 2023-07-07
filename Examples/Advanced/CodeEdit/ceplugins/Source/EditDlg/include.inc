
    IFNDEF CHARFORMAT2
      CHARFORMAT2 STRUCT QWORD
        cbSize dd ?
        dwMask dd ?
        dwEffects dd ?
        yHeight dd ?
        yOffset dd ?
        crTextColor dd ?
        bCharSet db ?
        bPitchAndFamily db ?
        szFaceName db LF_FACESIZE dup (?)
        wWeight dw ?
        sSpacing dw ?
        crBackColor dd ?
        lcid dd ?
        dwReserved dd ?
        sStyle dw ?
        wKerning dw ?
        bUnderlineType db ?
        bAnimation db ?
        bRevAuthor db ?
      CHARFORMAT2 ENDS
    ENDIF
