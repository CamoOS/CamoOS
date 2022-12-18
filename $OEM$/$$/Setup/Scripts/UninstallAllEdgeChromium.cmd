@setlocal DisableDelayedExpansion
@echo off
if defined PROCESSOR_ARCHITEW6432 start %SystemRoot%\Sysnative\cmd.exe /c "%0 " &exit
reg.exe query "HKU\S-1-5-19" 1>nul 2>nul || (echo Run the script as administrator&goto :TheEnd)

set "u_path=%LocalAppData%\Microsoft"
set "s_path=%ProgramFiles(x86)%\Microsoft"
if /i %PROCESSOR_ARCHITECTURE%==x86 (if not defined PROCESSOR_ARCHITEW6432 (
  set "s_path=%ProgramFiles%\Microsoft"
  )
)

@cls
echo.

reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /v NoRemove /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /v NoRemove /f 2>nul
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /v NoRemove /f 2>nul

echo.
for /D %%i in ("%u_path%\Edge SxS\Application\*") do if exist "%%i\installer\setup.exe" (
echo Canary...
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-sxs --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\Edge Internal\Application\*") do if exist "%%i\installer\setup.exe" (
echo Internal...
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-internal --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\Edge Dev\Application\*") do if exist "%%i\installer\setup.exe" (
echo Dev...
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-dev --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\Edge Beta\Application\*") do if exist "%%i\installer\setup.exe" (
echo Beta...
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-beta --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\Edge\Application\*") do if exist "%%i\installer\setup.exe" (
echo Stable...
start "" /w "%%i\installer\setup.exe" --uninstall --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\EdgeWebView\Application\*") do if exist "%%i\installer\setup.exe" (
echo WebView2 Runtime...
start "" /w "%%i\installer\setup.exe" --uninstall --msedgewebview --verbose-logging --force-uninstall --delete-profile
)

for /D %%i in ("%s_path%\EdgeWebView\Application\*") do if exist "%%i\installer\setup.exe" (
echo WebView2 Runtime...
start "" /w "%%i\installer\setup.exe" --uninstall --msedgewebview --system-level --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%s_path%\Edge\Application\*") do if exist "%%i\installer\setup.exe" (
echo Stable...
start "" /w "%%i\installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%s_path%\Edge Beta\Application\*") do if exist "%%i\installer\setup.exe" (
echo Beta...
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-beta --system-level --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%s_path%\Edge Dev\Application\*") do if exist "%%i\installer\setup.exe" (
echo Dev...
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-dev --system-level --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%s_path%\Edge Internal\Application\*") do if exist "%%i\installer\setup.exe" (
echo Internal...
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-internal --system-level --verbose-logging --force-uninstall --delete-profile
)

del /f /q "%AppData%\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge*.lnk" 2>nul
del /f /q "%SystemRoot%\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge*.lnk" 2>nul

reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /v DoNotUpdateToEdgeWithChromium /t REG_DWORD /d 1 /f 1>nul

:TheEnd
echo.
echo Press any key to exit.