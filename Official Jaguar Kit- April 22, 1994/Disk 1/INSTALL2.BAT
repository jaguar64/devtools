@echo 
@echo Please insert Disk #2 into drive %1
@pause
@pkunzip -d %1\GNU1.ZIP >NUL:
@pkunzip -d %1\GNU2.ZIP >NUL:
@echo 
@echo Please insert Disk #3 into drive %1
@pause
@%1\install3.bat %1


