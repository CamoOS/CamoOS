@echo off

:: Require Admin privileges
:: FIXME: Do something else when not admin

fltmc > nul || exit /b

:: Activate with MAS (we trust it since it is open source)

call "%~dp0MAS_AIO.cmd" /HWID

:: Shut up, Windows!

%~dp0OOSU10.exe %~dp0ooshutup10.cfg /quiet

:: Install Firefox

start /wait msiexec /i "%~dp0Firefox.msi" /passive /quiet

:: Disable Bluetooth

sc config bthserv start=disabled
powershell stop-service -name bthserv -force

:: Harden

%~dp0hardentools-cli.exe -harden

:: Remove scripts

cd \

if "%~dp0"=="%SystemRoot%\Setup\Scripts\" rd /s /q "%~dp0"