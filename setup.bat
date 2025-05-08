@echo off

where /q git
if errorlevel 1 (
    echo You must install Git to proceed: https://git-scm.com
    exit /b
)

where /q node
if errorlevel 1 (
    echo You must install Node to proceed: https://nodejs.org/en
    exit /b
)

if not exist engine (
    goto select
) else (
    goto update
)

:select
echo Please select a game version - use the number to confirm your option:
echo 225. May 18, 2004
set /p "rev=> "

if %rev% == 225 (
    goto download
) else (
    cls
    echo Invalid input
    goto select
)

:download
git clone https://github.com/LostCityRS/Engine-TS engine -b %rev% --single-branch
git clone https://github.com/LostCityRS/Content engine\data\src -b %rev% --single-branch

:update
cd engine
git pull

cd data\src
git pull

cd ..\..\..
