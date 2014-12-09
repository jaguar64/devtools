@pkunzip -d %1\GNU3.ZIP >NUL:
@pkunzip -d %1\CES_DEMO.ZIP >NUL:
@pkunzip -d %1\BRIEFMAC.ZIP >NUL:
@pkunzip -d %1\MUSIC.ZIP >NUL:
@pkunzip -d %1\3DDEMO.ZIP >NUL:
@pkunzip -d %1\WDBPC.ZIP >NUL:
@pkunzip -d %1\CDROM.ZIP >NUL:
@echo 
@echo The Jaguar Developer kit files are now installed.  Please
@echo don't forget to SET YOUR ENVIRONMENT VARIABLES as indicated by
@echo the documentation for the various tools.
@erase pkunzip.exe
@erase install2.bat
@echo on
