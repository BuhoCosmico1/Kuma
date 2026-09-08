@echo off
setlocal
title Uptime Kuma - Detener
cd /d "%~dp0"

echo Deteniendo Uptime Kuma...

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Get-CimInstance Win32_Process -Filter \"name='node.exe'\" | Where-Object { $_.CommandLine -like '*server*server.js*' }; if ($p) { $p | ForEach-Object { Write-Host ('  Cerrando PID ' + $_.ProcessId); Stop-Process -Id $_.ProcessId -Force }; Get-CimInstance Win32_Process -Filter \"name='cmd.exe'\" | Where-Object { $_.CommandLine -like '*IniciarKuma*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }; Write-Host 'Uptime Kuma detenido.' } else { Write-Host 'No hay procesos de Uptime Kuma en ejecucion.' }"

echo.
pause
