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

where /q bun
if errorlevel 1 (
    npm i -g bun
)

where /q bun
if errorlevel 1 (
    echo You must install Bun to proceed: https://bun.sh
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

echo 1. Start Server
echo 2. Start Server (engine dev)
echo 3. Update Source
if exist engine\.env (
    echo 4. Reconfigure Server
) else (
    echo 4. Configure Server
)
echo 5. Clean-build Server
echo 6. Build Web Client
echo 7. Run Java Client
set /p "action=> " || cmd /c exit -1073741510

if %action% == 1 (
    goto startProj
) else if %action% == 2 (
    goto startProjDev
) else if %action% == 3 (
    goto updateProj
) else if %action% == 4 (
    goto reconfigureProj
) else if %action% == 5 (
    goto rebuildProj
) else if %action% == 6 (
    goto buildWebClient
) else if %action% == 7 (
    goto runJavaClient
)

cls
echo Invalid input
goto index

:selectVer
echo Please select a game version - use the number to confirm your option:
echo 225. May 18, 2004
set /p "rev=> " || cmd /c exit -1073741510

if %rev% == 225 (
    goto downloadVer
)

cls
echo Invalid input
goto selectVer

:downloadVer
git clone https://github.com/LostCityRS/Engine-TS engine -b %rev% --single-branch
git clone https://github.com/LostCityRS/Content content -b %rev% --single-branch
git clone https://github.com/LostCityRS/Client-TS webclient -b %rev% --single-branch
git clone https://github.com/LostCityRS/Client-Java javaclient -b %rev% --single-branch
goto index

:startProj
if not exist engine (
    goto selectVer
)

cd engine

if not exist .env (
    call bun install
    call bun run setup
)

start bun start
exit

:startProjDev
if not exist engine (
    goto selectVer
)

cd engine

if not exist .env (
    call bun install
    call bun run setup
)

call bun run dev
exit

:updateProj
if not exist engine (
    goto selectVer
)

cd engine
git pull
cd ..

if not exist content (
    goto selectVer
)

cd content
git pull
cd ..

if not exist webclient (
    goto selectVer
)

cd webclient
git pull
cd ..

if not exist javaclient (
    goto selectVer
)

cd javaclient
git pull
cd ..

goto index

:reconfigureProj
cd engine
call bun install
call bun run setup

cd ..
goto index

:rebuildProj
cd engine
call bun run clean
call bun run build

cd ..
goto index

:buildWebClient
cd webclient
call bun run build
copy out\client.js ..\engine\public\client\client.js
copy out\deps.js ..\engine\public\client\deps.js

cd ..
goto index

:runJavaClient
cd javaclient
call gradlew.bat run --args="10 0 highmem members"

cd ..
goto index
