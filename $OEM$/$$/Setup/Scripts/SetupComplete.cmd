@echo off

:: Require Admin privileges
:: FIXME: Do something else when not admin

fltmc > nul || exit /b

:: Activate with MAS (we trust it since it is open source)

call "%~dp0MAS_AIO.cmd" /KMS38

:: Shut up, LTSC!

%~dp0OOSU10.exe %~dp0ooshutup10.cfg /quiet

:: Replace Edge with Firefox

call "%~dp0UninstallAllEdgeChromium.cmd"
start /wait msiexec /i "%~dp0Firefox.msi" /passive /quiet

:: Disable Bluetooth

sc config bthserv start=disabled
powershell stop-service -name bthserv -force

:: Remove scripts

cd \

if "%~dp0"=="%SystemRoot%\Setup\Scripts\" rd /s /q "%~dp0"