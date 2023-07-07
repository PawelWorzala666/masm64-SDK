@echo off
  dir /b *.asm > src.txt
  \masm32\bin64\ml64 /c @src.txt
  dir /b *.obj > obj.txt
  @echo.
  \masm32\bin64\lib /MACHINE:X64 /OUT:iButton.lib @obj.txt
  del *.obj
  del obj.txt
  del src.txt
  dir *.lib
  pause
