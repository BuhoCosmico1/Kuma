@echo off
setlocal
title Uptime Kuma - Inicio automatico con Windows (segundo plano)
cd /d "%~dp0"

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "LNK=%STARTUP%\UptimeKuma.lnk"
set "WORKDIR=%~dp0"
set "BAT=%~dp0IniciarKuma.bat"
set "VBS=%~dp0_kuma_oculto.vbs"

if not exist "%BAT%" (
    echo [ERROR] No se encontro IniciarKuma.bat junto a este archivo.
    pause
    exit /b 1
)

echo Generando lanzador oculto...
> "%VBS%" echo ' Generado automaticamente por InstalarInicioAutomatico.bat - no editar
>>"%VBS%" echo Dim fso, carpeta, bat
>>"%VBS%" echo Set fso = CreateObject("Scripting.FileSystemObject")
>>"%VBS%" echo carpeta = fso.GetParentFolderName(WScript.ScriptFullName)
>>"%VBS%" echo bat = carpeta ^& "\IniciarKuma.bat"
>>"%VBS%" echo If fso.FileExists(bat) Then CreateObject("WScript.Shell").Run """" ^& bat ^& """", 0, False

echo Creando acceso directo de inicio automatico en:
echo   %LNK%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$q=[char]34; $s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:LNK); $s.TargetPath='wscript.exe'; $s.Arguments=$q+$env:VBS+$q; $s.WorkingDirectory=$env:WORKDIR; $s.WindowStyle=7; $s.Description='Uptime Kuma segundo plano'; $s.Save()"

if exist "%LNK%" (
    echo Listo. Al iniciar sesion este usuario, Uptime Kuma
    echo arranca en segundo plano, sin ventana visible.
    echo.
    echo Para detenerlo ejecuta DetenerKuma.bat
    echo Para quitar el inicio automatico borra el archivo:
    echo   %LNK%
    echo.
    choice /c SN /n /m "Iniciar Uptime Kuma ahora en segundo plano? [S/N] "
    if errorlevel 2 goto fin
    wscript.exe "%VBS%"
    echo Uptime Kuma iniciado. Abri http://localhost:3001
) else (
    echo [ERROR] No se pudo crear el acceso directo.
)

:fin
echo.
pause
