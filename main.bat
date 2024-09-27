@echo off
chcp 65001

title System Information Display

:: Set the window width (optional, adjust if needed)
mode con: cols=80 lines=40

:refresh
:: Clear the previous system information but keep the header
cls
echo.
echo.
echo                                      System Information Display
echo.
echo.
echo.
echo. 
echo                                        [42m System Information [0m
echo.

:: Get System Boot Time
for /f "tokens=*" %%A in ('wmic os get lastbootuptime ^| findstr /R /V "^$"') do (
    set bootTime=%%A
)

:: Convert Boot Time to readable format
set "year=%bootTime:~0,4%"
set "month=%bootTime:~4,2%"
set "day=%bootTime:~6,2%"
set "hour=%bootTime:~8,2%"
set "minute=%bootTime:~10,2%"
set "second=%bootTime:~12,2%"

set newBootTime=%month%/%day%/%year% %hour%:%minute%:%second%
echo                        [1mBoot Time:[0m %newBootTime%

:: Get the PC Name
set PCName=%COMPUTERNAME%
echo                        [1mPC NAME:[0m %PCName%

:: Get the HWID
for /f "tokens=3" %%A in ('reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography /v MachineGuid') do set HWID=%%A
echo                        [1mHWID:[0m %HWID%

:: Get the Local IP address (IPv4)
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /R /C:"IPv4 Address"') do set localIP=%%A
echo                        [1mLocal IP Address:[0m %localIP%

:: Get the Public IP address using PowerShell
for /f "delims=" %%a in ('powershell -command "(Invoke-WebRequest -Uri http://ipinfo.io/ip).Content.Trim()"') do set publicIP=%%a
echo                        [1mPublic IP Address:[0m %publicIP%

:: Get the MAC Address
for /f "tokens=2 delims=:" %%A in ('getmac /fo list /v ^| findstr /C:"Physical Address" ^| findstr /V "Media"') do set MACAddress=%%A
echo                        [1mMAC Address:[0m %MACAddress%

:: Get CPU Information
for /f "tokens=*" %%A in ('wmic cpu get Name ^| findstr /R /V "^$"') do (
    set CPU=%%A
)
echo                        [1mCPU:[0m %CPU%

:: Get Graphics Card Information
for /f "tokens=*" %%A in ('wmic path win32_videocontroller get name ^| findstr /R /V "^$"') do (
    set GPU=%%A
)
echo                        [1mGPU:[0m %GPU%

:: VM Check (Check if the system is running in a Virtual Machine)
for /f "tokens=*" %%A in ('wmic computersystem get model ^| findstr /I /C:"Virtual" /C:"VMware" /C:"VirtualBox"') do set VM=%%A

if defined VM (
    echo                        [1mVirtual Machine[0m [102mDetected:[0m %VM%
) else (
    echo                        [1mVirtual Machine[0m [101mNot Detected.[0m
)

:: Get VPN Information (Check for VPN)
netsh interface show interface | findstr /C:"VPN" >nul
if %ERRORLEVEL%==0 (
    echo                        [1mVPN is[0m [102mactive[0m
) else (
    echo                        [1mVPN[0m [101mNot Detected.[0m
)

echo.
echo.
echo                                 Made with ❤️ by github.com/22522501

echo.
pause > nul

:: Refresh the system information, but keep the header
goto refresh
