@echo off
@rem ------------------------------------------------------------------------
@rem Verify that the parameters for the batch file make sense. If so, proceed.
@rem If not, then jump ahead to show error message and READTHIS.1ST file.
@rem ------------------------------------------------------------------------
@if %1==A: goto msg1
@if %1==a: goto msg1
@if %1==B: goto msg1
@if %1==b: goto msg1
@goto paramerror

@rem ------------------------------------------------------------------------
@rem Show the initial text message and current drive/directory so that the
@rem user has a chance to abort if they did it wrong.
@rem ------------------------------------------------------------------------
:msg1
@echo 
@echo The installation process will create a JAGUAR directory in the current
@echo directory and then install the Jaguar Developer Kit files into it.
@echo Please make sure that the current drive and directory is where you want
@echo the JAGUAR directory to be created.  The current directory is:
@echo  
@cd
@echo  
@echo If this is not where you want the JAGUAR directory to be created, then
@echo hit Control+C to abort the installation, then do the following steps:
@echo 
@echo 1) Change to the desired destination drive and directory.
@echo 
@echo 2) Run the install batch file again, using a commandline that looks like:
@echo 
@echo        a:\install a:        ---or---        b:\install b:
@echo 
@echo    depending on which drive you are installing from.
@echo 
@echo Otherwise, hit the <space> bar to proceed with the installation.
@echo  
@pause

@rem ------------------------------------------------------------------------
@rem Figure out the source drive so we can continue or fall through to error.
@rem ------------------------------------------------------------------------
@if %1==A: goto copya
@if %1==a: goto copya
@if %1==B: goto copyb
@if %1==b: goto copyb

@rem ------------------------------------------------------------------------
@rem Show error message, display the READTHIS.1ST file since they probably
@rem didn't really read it the first time, if they even looked at it at all.
@rem ------------------------------------------------------------------------
:paramerror
@echo 
@echo Invalid source drive specification.
@echo 
@echo 1) Change to desired DESTINATION drive and directory
@echo 
@echo 2) Please use a commandline that looks like:
@echo 
@echo        a:\install a:        ---or---        b:\install b:
@echo 
@echo    depending on which floppy drive you are installing from.
@echo 
@echo If you have not read the file READTHIS.1ST already, you should do so
@echo before trying the installation again.  Now showing READTHIS.1ST...
@echo 
@pause
@echo ------------------------------------------------------------------------
@more <READTHIS.1ST
@goto exit

:copya
:copyb
:copyziputil
@copy %1\pkunzip.exe >NUL:
@copy %1\install2.bat >NUL:

@echo 
@echo Extracting files from archive...
@echo 
@pkunzip -d %1\ALNPC.ZIP >NUL:
@pkunzip -d %1\MACPC.ZIP >NUL:
@pkunzip -d %1\GASMPC.ZIP >NUL:
@pkunzip -d %1\RDBJAG.ZIP >NUL:
@pkunzip -d %1\INCLUDES.ZIP >NUL:
@pkunzip -d %1\UTILPC.ZIP >NUL:
@pkunzip -d %1\EXAMPLES.ZIP >NUL:
@pkunzip -d %1\MISCDOCS.ZIP >NUL:
@pkunzip -d %1\JAGPEG.ZIP >NUL:
@pkunzip -d %1\DEJAG.ZIP >NUL:
@pkunzip -d %1\TESTJPG.ZIP >NUL:
@pkunzip -d %1\TGAJAGPC.ZIP >NUL:
@install2.bat %1

:exit
@echo on

