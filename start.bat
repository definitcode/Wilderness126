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

where /q java
if errorlevel 1 (
    echo You must install Java 17 or newer to proceed: https://adoptium.net/
    exit /b
)

for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k%"
if %jver% lss 170 (
    echo You must install Java 17 or newer to proceed: https://adoptium.net/
    echo And it must be your primary Java version!
    exit /b
)

:index
if not exist engine (
	goto startProj
)

echo 1. Start
echo 2. Update
if exist engine\.env (
    echo 3. Reconfigure
) else (
    echo 3. Configure
)
set /p "action=> "

if %action% == 1 (
    goto startProj
) else if %action% == 2 (
    goto updateProj
) else if %action% == 3 (
    goto reconfigureProj
)

cls
echo Invalid input
goto index

:selectVer
echo Please select a game version - use the number to confirm your option:
echo 225. May 18, 2004
set /p "rev=> "

if %rev% == 225 (
    goto downloadVer
)

cls
echo Invalid input
goto selectVer

:downloadVer
git clone https://github.com/LostCityRS/Engine-TS engine -b %rev% --single-branch
git clone https://github.com/LostCityRS/Content content -b %rev% --single-branch
goto index

:startProj
if not exist engine (
    goto selectVer
)

cd engine

if not exist engine\.env (
    call npm install
    call npm run setup
)

start npm start
exit

:updateProj
cd engine
git pull
cd ..

cd content
git pull
cd ..

goto index

:reconfigureProj
cd engine
call npm install
call npm run setup
cd ..
goto index
