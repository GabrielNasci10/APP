@echo off
rem Cria um atalho "Stoa" no ambiente de trabalho com o icone da aplicacao.
rem Mantem este ficheiro na mesma pasta que index.html, criar-atalho-windows.ps1 e a pasta "icon".
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0criar-atalho-windows.ps1"
if errorlevel 1 echo Nao foi possivel criar o atalho.
pause
