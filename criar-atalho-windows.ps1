# Cria o atalho "Stoa" no ambiente de trabalho.
# Usa o Chrome ou o Edge em modo aplicacao (janela propria, sem barra de enderecos),
# o que permite afixar o atalho na barra de tarefas.
$ErrorActionPreference = 'Stop'

$dir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$html = Join-Path $dir 'index.html'
$ico  = Join-Path $dir 'icon\stoa.ico'

if (-not (Test-Path $html)) { Write-Host 'Nao encontrei o index.html nesta pasta.'; exit 1 }
if (-not (Test-Path $ico))  { Write-Host 'Nao encontrei icon\stoa.ico nesta pasta.'; exit 1 }

$url = ([Uri]$html).AbsoluteUri

$candidates = @(
  @{ Name = 'Google Chrome';  Path = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" },
  @{ Name = 'Google Chrome';  Path = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe" },
  @{ Name = 'Google Chrome';  Path = "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe" },
  @{ Name = 'Microsoft Edge'; Path = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe" },
  @{ Name = 'Microsoft Edge'; Path = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe" }
)
$browser = $candidates | Where-Object { Test-Path $_.Path } | Select-Object -First 1

$desk = [Environment]::GetFolderPath('Desktop')
$lnk  = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $desk 'Stoa.lnk'))

if ($browser) {
  $lnk.TargetPath = $browser.Path
  $lnk.Arguments  = "--app=`"$url`""
  $msg = "Atalho 'Stoa' criado: abre numa janela propria do $($browser.Name)."
} else {
  $lnk.TargetPath = $html
  $msg = "Atalho 'Stoa' criado (Chrome/Edge nao encontrados: abre no browser predefinido e nao pode ser afixado na barra de tarefas)."
}
$lnk.WorkingDirectory = $dir
$lnk.IconLocation     = "$ico,0"
$lnk.Description      = 'Stoa - Santuario diario estoico'
$lnk.Save()

Write-Host $msg
if ($browser) {
  Write-Host ''
  Write-Host 'Para afixar na barra de tarefas: arrasta o atalho do ambiente de trabalho para a barra,'
  Write-Host 'ou clica nele com o botao direito > Mostrar mais opcoes > Afixar na barra de tarefas.'
}
