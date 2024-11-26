echo off
CLS
REM     **Created by MIKE LU on 2024.11.26**
REM     DTM Filter Lookup: https://partner.microsoft.com/en-us/dashboard/hardware/dtmfilters
ECHO.                                         
ECHO       @       @  @   @   @@@    @      
ECHO       @   @   @  @   @  @   @   @       
ECHO       @   @   @  @   @  @   @   @   
ECHO       @   @   @  @@@@@  @   @   @       
ECHO       @@ @ @ @   @   @  @   @   @         
ECHO        @@   @@   @   @  @ @ @   @       
ECHO        @@   @@   @   @   @ @@   @       
ECHO         @   @    @   @    @@ @  @@@@@@@   v1.0   


::VARIABLE
SET FldrDOWNLOAD=C:\Users\Administrator\Desktop\HLKFilterUpdater\NewFilter
SET FldrARCHIVE=C:\Users\Administrator\Desktop\HLKFilterUpdater\OldFilters
SET CABFILE=Updatefilters.cab
SET LASTDOWNLOADCAB=Lastdownload.cab


::DOWNLOAD FILE FROM SYSDEV	
ECHO.
ECHO.
ECHO.
ECHO ********************************************************
ECHO.
ECHO Downloading the latest filter, please wait...
ECHO.
ECHO.
ECHO.
ECHO.
POWERSHELL Set-ExecutionPolicy RemoteSigned		
POWERSHELL -NOPROFILE -command "& 'C:\Users\Administrator\Desktop\HLKFilterUpdater\Patch\SysdevDownload.PS1' -QUIET "


::CHECK FOR FILE UPDATES								
IF NOT EXIST %FldrDOWNLOAD%\%CABFILE% (
	ECHO %date% %time% File download FAILED>> %ErrataArchive%\ErrataUpdates.log
	GOTO ENDBATCH)
FC %FldrDOWNLOAD%\%CABFILE% %FldrDOWNLOAD%\%LASTDOWNLOADCAB%
IF ERRORLEVEL 1 (GOTO NEWUPDATE) ELSE (GOTO NOUPDATE)


:NEWUPDATE
::UPDATE LOG
ECHO %date% %time% Updated filter detected>> %FldrARCHIVE%\ErrataUpdates.log

::ARCHIVE NEWLY DOWNLOADED FILE BY RENAMING WITH DATE 
::SET VARIABLE CURDATE TO CURRENT DATE FOR USE IN FILENAME 
for /f "tokens=2,3,4 delims=/ " %%j in ("%DATE%") do set CURDATE=%%l.%%j.%%k


::RENAME FILE
COPY %FldrDOWNLOAD%\%CABFILE% %FldrARCHIVE%\%CURDATE%_%CABFILE%


::REPLACE LASTDOWNLOADCAB FILE WITH NEWLY DOWNLOADED CAB FILE			
DEL %FldrDOWNLOAD%\%LASTDOWNLOADCAB% /Q
RENAME %FldrDOWNLOAD%\%CABFILE% %LASTDOWNLOADCAB%
GOTO ENDBATCH


:NOUPDATE
::UPDATE LOG
ECHO %date% %time% No Updated filter detected>> %FldrARCHIVE%\ErrataUpdates.log
DEL %FldrDOWNLOAD%\%CABFILE%
GOTO ENDBATCH


:ENDBATCH
::RESET ALL VARIABLES
SET FldrDOWNLOAD=
SET FldrARCHIVE=
SET CABFILE=
SET LASTDOWNLOADCAB=
set CURDATE=
CLS


::EXTRACT CAB FILE
@EChO OFF
C:\Users\Administrator\Desktop\HLKFilterUpdater\Patch\7z e C:\Users\Administrator\Desktop\HLKFilterUpdater\NewFilter\Lastdownload.cab
CLS
ECHO.
ECHO ********************************************************
ECHO.
ECHO Download is complete! 
ECHO Now updating filter on your server...
ECHO.
ECHO.
ECHO.
for /f "eol=A tokens=25-28" %%m in (C:\Users\Administrator\Desktop\HLKFilterUpdater\ReadMe.txt) do echo Filter version : %%m %%n %%o %%p
ECHO.
ECHO ********************************************************
ECHO.
ECHO.

::APPLY FILTER
IF EXIST "C:\Program Files (x86)\Windows Kits\10" (GOTO applyFilter) ELSE (GOTO end) 
:applyFilter
COPY C:\Users\Administrator\Desktop\HLKFilterUpdater\UpdateFilters.sql "C:\Program Files (x86)\Windows Kits\10\Hardware Lab Kit\Controller"
updatefilters.exe
:end
DEL C:\Users\Administrator\Desktop\HLKFilterUpdater\UpdateFilters.sql
DEL C:\Users\Administrator\Desktop\HLKFilterUpdater\ReadMe.txt

