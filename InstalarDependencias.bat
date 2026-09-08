@echo off
setlocal
title Uptime Kuma - Instalar dependencias
cd /d "%~dp0"

echo ============================================
echo   Uptime Kuma - Instalacion de dependencias
echo ============================================
echo.

where node >nul 2>nul
if errorlevel 1 (
    echo [ERROR] No se encontro Node.js en el PATH.
    echo Instala Node.js 20.4 o superior desde https://nodejs.org
    echo.
    pause
    exit /b 1
)

for /f "delims=" %%v in ('node -v') do set NODEVER=%%v
echo Node detectado: %NODEVER%
echo.

echo Instalando dependencias de produccion (npm ci)...
call npm ci --omit dev --no-audit
if errorlevel 1 (
    echo.
    echo npm ci fallo, intentando con npm install...
    call npm install --omit dev --no-audit
    if errorlevel 1 (
        echo.
        echo [ERROR] No se pudieron instalar las dependencias.
        pause
        exit /b 1
    )
)

echo.
if not exist "dist\index.html" (
    echo Falta el frontend compilado, descargando dist...
    call npm run download-dist
    if errorlevel 1 (
        echo.
        echo [ERROR] No se pudo descargar el dist.
        pause
        exit /b 1
    )
)

echo.
echo ============================================
echo   Listo. Dependencias instaladas.
echo ============================================
echo.
pause
