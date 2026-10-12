@echo off
rem Cria um atalho "Stoa" no ambiente de trabalho com o icone da aplicacao.
rem Mantem este ficheiro na mesma pasta que index.html e a pasta "icon".
setlocal
set "DIR=%~dp0"
if not exist "%DIR%index.html" (
  echo Nao encontrei o index.html nesta pasta.
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir = $env:DIR; $desk = [Environment]::GetFolderPath('Desktop'); $lnk = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $desk 'Stoa.lnk')); $lnk.TargetPath = (Join-Path $dir 'index.html'); $lnk.WorkingDirectory = $dir; $lnk.IconLocation = (Join-Path $dir 'icon\stoa.ico') + ',0'; $lnk.Description = 'Stoa - Santuario diario estoico'; $lnk.Save()"
if errorlevel 1 (
  echo Nao foi possivel criar o atalho.
) else (
  echo Atalho "Stoa" criado no ambiente de trabalho.
)
pause
