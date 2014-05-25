@rem ------------------------------------------------------------------------
@rem INSTALL2.BAT File created by MIKE'S JAGUAR DEV KIT ACCESS DATABASE APP -
@rem ------------------------------------------------------------------------
@echo 
@echo Please insert Disk #2 into drive %1
@pause
@pkunzip -d -o %1\*.ZIP >NUL:


@echo 
@echo Please insert Disk #3 into drive %1
@pause
@pkunzip -d -o %1\*.ZIP >NUL:


@echo 
@echo Please insert Disk #4 into drive %1
@pause
@pkunzip -d -o %1\*.ZIP >NUL:


@echo 
@echo Please insert Disk #5 into drive %1
@pause
@pkunzip -d -o %1\*.ZIP >NUL:


@echo 
@echo Please insert Disk #6 into drive %1
@pause
@pkunzip -d -o %1\*.ZIP >NUL:

@echo 
@echo The Jaguar Developer kit files are now installed.  Please
@echo don't forget to SET YOUR ENVIRONMENT VARIABLES as indicated by
@echo the documentation for the various tools.
@erase pkunzip.exe
@echo on
@echo Type 'erase install2.bat' to remove the installation batch file.
