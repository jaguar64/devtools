if "%1"=="" goto quit
if "%2"=="" goto quit

split %1

echo Compressing %1.yy with quality of %2
cjpeg -Q%2 %1.yy
copy %1.jpg %1.rj
del %1.jpg
	
echo Compressing %1.cr with quality of %2
cjpeg -Q%2 %1.cr
copy %1.jpg %1.gj
del %1.jpg

echo Compressing %1.cb with quality of %2
cjpeg -Q%2 %1.cb
copy %1.jpg %1.bj
del %1.jpg

makeq %1.rj dq%2.dat
	
del %1.yy
del %1.cb
del %1.cr
jstrip %1.rj
jstrip %1.gj
jstrip %1.bj
del %1.rj
del %1.gj
del %1.bj
merge %1
del %1.rja
del %1.gja
del %1.bja
dir %1.jag

goto end

:quit
echo Provide the name and quality ("tgajag pic 75" for example)

:end

