@echo off

rem Define package names
set PACKAGES=dgram mqtt

:check_chocolatey
REM Check if Chocolatey is installed
where /q choco -v
IF %ERRORLEVEL% NEQ 0 (
    echo This script needs Chocolatey, a package manager for Windows, which allows you to easily install and manage software packages.
    echo Do you want to install Chocolatey?
    choice /c yn /m "Enter your choice: "
    
    REM Check the user's choice
    if /i "%errorlevel%"=="2" exit 0 /b
    
    REM Chocolatey is not installed, so install it
      echo Installing Chocolatey...
      call powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
      echo You need to shut down and restart powershell or console and start the installation script again.
      pause
      exit 0
  ) ELSE (
    echo Excelent! Chocolatey is already installed.
  )

:check_nodejs
rem Check if Node.js is installed
where /q node -v
if %errorlevel% neq 0 (
    echo Node.js https://nodejs.org/ is not installed. 
    echo Starting Node.js installation...
    choco install nodejs -y
    echo You need start the installation script again.
    pause
    refreshenv
) ELSE (
    echo Excelent! Node.js is already installed.
  )

:check_git
rem Check if Git is installed
where /q git >nul 2>nul
if %errorlevel% neq 0 (
    echo Starting git installation...
    choco install git -y
    echo Git installation completed.
    echo You need start the installation script again.
    pause
    refreshenv
) else (
    echo Excelent! Git is already installed.
)

REM Check if 7-Zip is installed
where /q 7z i | find "zip" >nul

REM If 7-Zip is not installed, install it using Chocolatey
if %errorlevel% neq 0 (
    echo Installing 7-Zip...
    choco install 7zip -y
) else (
    echo Excelent! 7-Zip is already installed.
)


rem Check if Zigbee2MQTT is installed
where /q zigbee2mqtt
if %errorlevel% neq 0 (
  rem Install zigbee2mqtt 
  rem git clone --depth 1 git@github.com:Koenkk/zigbee2mqtt.git
  curl -L -o repository.zip https://github.com/Koenkk/zigbee2mqtt/archive/refs/heads/master.zip
  7z x repository.zip
  ren zigbee2mqtt-master zigbee2mqtt
  del repository.zip
  del zigbee2mqtt-master -y

  cd zigbee2mqtt
  npm ci
)

rem Install npm packages for ZigLoxBridge
echo Installing npm packages...
for %%i in (%PACKAGES%) do (
    npm install -g %%i
)

npm start
echo Installation completed.


rem Zigbee2MQTT is installed, continue with the script
echo Zigbee2MQTT is installed. Proceeding with the script...

pause