@echo off
setlocal
title Uptime Kuma
cd /d "%~dp0"

rem Puerto donde queda escuchando Uptime Kuma
set "UPTIME_KUMA_PORT=3001"
rem Para equipos lentos / evitar "database is locked" descomenta la linea siguiente:
rem set "UPTIME_KUMA_SQLITE_SINGLE_CONNECTION=true"

if not exist "node_modules" (
    echo No hay node_modules. Ejecuta primero InstalarDependencias.bat
    pause
    exit /b 1
)

if not exist "dist\index.html" (
    echo Falta dist\index.html. Ejecuta primero InstalarDependencias.bat
    pause
    exit /b 1
)

:loop
echo [%date% %time%] Iniciando Uptime Kuma en el puerto %UPTIME_KUMA_PORT% ...
node server/server.js --port=%UPTIME_KUMA_PORT%
echo.
echo [%date% %time%] Uptime Kuma se cerro (codigo %errorlevel%). Reintentando en 5s...
ping -n 6 127.0.0.1 >nul
goto loop
