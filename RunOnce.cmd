@echo off

:: Reboot

shutdown -r -t 5 -c "Required Reboot"
del %0 /f
