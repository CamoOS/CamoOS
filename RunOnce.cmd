@echo off

:: Reboot

shutdown -r -t 5 -c "Required Reboot"
ping localhost -n 2
del %0 /f