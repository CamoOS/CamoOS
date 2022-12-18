@echo off

:: Detect admin, if not, fail.

fltmc > nul || goto requiresadmin

:: Detect Internet, if not, fail.

ping -n 2 google.com > nul
if %errorlevel% NEQ 0 goto nointernet

cd %~dp0

:: If the user has not extracted the DVD, fail
if not exist DVD goto nodvdfolder

set mydate=%date:~4,11%
set mydate=%mydate:/=-%

:: Use/Create DVD backup

if exist DVD (
	if exist DVD.bak (
		rd DVD /s /q
		robocopy DVD.bak DVD /e
	)
)

if not exist DVD.bak robocopy DVD DVD.bak /e

:: If install.esd detected, convert

if exist DVD\sources\install.esd (
	echo ESD detected, converting
	pushd DVD\sources
	dism /export-image /SourceImageFile:install.esd /SourceIndex:1 /DestinationImageFile:install.wim /Compress:fast
	del install.esd /f
	popd
)

:: Delete N version

echo Deleting N version

dism /Delete-Image /ImageFile:DVD\sources\install.wim /Index:2

:: Mount WIM

echo Mounting image

mkdir mount
dism /mount-image /imagefile:DVD\sources\install.wim /index:1 /mountdir:mount

:: Download Firefox and MAS

echo Downloading Firefox and MAS
curl -L "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win&lang=en-US" -o $OEM$\$$\Setup\Scripts\Firefox.msi
curl -L "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd" -o $OEM$\$$\Setup\Scripts\MAS_AIO.cmd

:: Load hives

echo Loading hives

:: ODU means Offline Default User, use as HKCU
reg load HKEY_USERS\ODU mount\users\default\ntuser.dat
reg load HKEY_LOCAL_MACHINE\SOFT mount\windows\system32\config\software

:: Apply tweaks

echo Applying tweaks

reg import tweaks.reg

:: Add Wallpaper

echo Adding Wallpaper

takeown /f mount\Windows\Web /r /d y
icacls mount\Windows\Web /grant administrators:f /t
forfiles /p mount\Windows\Web /s /m *.jpg /c "cmd /c copy ^"%~dp0img0.jpg^" @path /y"

:: Adding Startup file

echo Adding Startup file

set startupFolder=mount\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
if not exist "%startupFolder%" mkdir "%startupFolder%"
copy RunOnce.cmd "%startupFolder%" /y

:: Unload hives

echo Unloading hives

reg unload HKEY_USERS\ODU
reg unload HKEY_LOCAL_MACHINE\SOFT

:: Unmount image

echo Unmounting image

Dism /Unmount-Image /MountDir:mount /Commit

rd mount

:: Copy OEM folder

echo Copying OEM folder

robocopy $OEM$ DVD\sources\$OEM$ /e

:: Copy autounattend

echo Copying autounattend files
copy autounattend.xml DVD /y

:: Create ISO

echo Creating ISO

oscdimg.exe -h -m -o -u2 -udfver102 -bootdata:2#p0,e,bDVD\boot\etfsboot.com#pEF,e,bDVD\efi\microsoft\boot\efisys.bin -lCamoOS DVD CamoOS_built_%mydate%.iso

pause

exit

:requiresadmin
echo This script requires admin privliges.
pause
exit

:nointernet
echo Please connect to the Internet.
pause
exit

:nodvdfolder
echo Please extract an LTSC ISO and call the folder DVD.
pause
exit
