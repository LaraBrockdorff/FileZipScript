
 @if (@CodeSection==@Batch) @then
@echo off
 setlocal

rem age of files
 set "age=6"
 pushd "C:\Users\larab\Documents"

 for /d %%a in (*FOLDERNAME*) do (
     for /d %%I in ("%%~a\*") do (
         call :getAge modified created accessed "%%~fI"
         setlocal enabledelayedexpansion

         echo %%~fI was created !created! days ago.
         echo %%~nxI was modified !modified! days ago.
         echo %%~nxI was last accessed !accessed! days ago.

         echo 
         echo
         echo 
         set mydate=%date:~-4%-%date:~3,2%-%date:~0,2%
         echo before if
         echo %date%

         echo mydate is %date:~-4%_%date:~3,2%_%date:~0,2%

         if "!modified!" leq "%age%" (
             echo in if



             "C:\Program Files\WinRAR\WinRar.exe" a -ep1 -r -ad -m5 "%%~fI_%date:~-4%_%date:~3,2%_%date:~0,2%.rar" "%%~fI"
             move "%%~fI_%date:~-4%_%date:~3,2%_%date:~0,2%.rar" C:\Users\PATH_TO_SAVE_IN

         )
         endlocal
     )
 )
pause
 popd
 rem // end main runtime
 goto :EOF

 :getAge <modified_var> <created_var> <accessed_var> <file|folder>
 setlocal
 for /f %%I in ('cscript /nologo /e:JScript "%~f0" "%~4"') do set "%%I"
 endlocal & set "%~1=%modified%" & set "%~2=%created%" & set "%~3=%accessed%"
 goto :EOF

 rem // end batch portion / begin JScript
 @end

 var fso = new ActiveXObject("scripting.filesystemobject"),
     arg = WSH.Arguments(0),
     file = fso.FileExists(arg) ? fso.GetFile(arg) : fso.GetFolder(arg);

 var props = {
     modified: new Date() - file.DateLastModified,
     created: new Date() - file.DateCreated,
     accessed: new Date() - file.DateLastAccessed
 }

 for (var i in props) {
     // age in days
     props[i] = Math.floor(props[i] / 1000 / 60 / 60 / 24);
     WSH.Echo(i + '=' + props[i]);
 }
