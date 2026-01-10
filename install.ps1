<#
.SYNOPSIS
    Script d'installation de PassDiali CLI

.DESCRIPTION
    Installe PassDiali CLI dans le profil PowerShell

.NOTES
    Auteur: Naoufal Najim
    Version: 1.0.0
#>

$ErrorActionPreference = 'Stop'

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "     PassDiali CLI - Installation" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ATTENTION: Installation recommandee en tant qu'administrateur" -ForegroundColor Yellow
    Write-Host "Continuer quand meme? (O/N): " -NoNewline
    $response = Read-Host
    if ($response -ne 'O' -and $response -ne 'o') {
        Write-Host "`nInstallation annulee`n" -ForegroundColor Red
        exit
    }
}

Write-Host "Preparation de l'installation...`n" -ForegroundColor Cyan

$installPath = Join-Path $env:USERPROFILE "Documents\PassDiali"
if (-not (Test-Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath -Force | Out-Null
    Write-Host "Dossier cree: $installPath" -ForegroundColor Green
}

$scriptPath = Join-Path $installPath "passdiali.ps1"

if (Test-Path ".\passdiali.ps1") {
    Copy-Item ".\passdiali.ps1" $scriptPath -Force
    Write-Host "Script copie localement" -ForegroundColor Green
}
else {
    Write-Host "Telechargement depuis GitHub..." -ForegroundColor Cyan
    try {
        $url = "https://raw.githubusercontent.com/naoufalnajim01/PassDiali-CLI/main/passdiali.ps1"
        Invoke-WebRequest -Uri $url -OutFile $scriptPath -UseBasicParsing
        Write-Host "Script telecharge" -ForegroundColor Green
    }
    catch {
        Write-Host "Erreur de telechargement: $_" -ForegroundColor Red
        exit 1
    }
}

$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir = Split-Path $profilePath -Parent

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

$aliasExists = Select-String -Path $profilePath -Pattern "PassDiali" -Quiet

if (-not $aliasExists) {
    $aliasCommand = @"

# PassDiali CLI - Generateur de mots de passe securise
function PassDiali {
    & "$scriptPath" @args
}
Set-Alias -Name pd -Value PassDiali -Scope Global
"@
    
    Add-Content -Path $profilePath -Value $aliasCommand
    Write-Host "Alias ajoute au profil PowerShell" -ForegroundColor Green
}
else {
    Write-Host "Alias deja present dans le profil" -ForegroundColor Yellow
}

. $profilePath

Write-Host "`n================================================" -ForegroundColor Green
Write-Host "     Installation terminee avec succes" -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Green

Write-Host "PassDiali CLI est maintenant installe!`n" -ForegroundColor Cyan

Write-Host "Commandes disponibles:" -ForegroundColor Yellow
Write-Host "  PassDiali                    - Generer un mot de passe"
Write-Host "  pd                           - Raccourci (alias)"
Write-Host "  Get-Help PassDiali -Full     - Documentation complete"

Write-Host "`nExemples d'utilisation:" -ForegroundColor Yellow
Write-Host "  PassDiali"
Write-Host "  PassDiali -Length 32 -ExcludeAmbiguous"
Write-Host "  PassDiali -Type Passphrase -Words 5"
Write-Host "  PassDiali -Type PIN -Length 6"
Write-Host "  PassDiali -Analyze 'VotreMotDePasse123!'"

Write-Host "`nPlus d'infos:" -ForegroundColor Yellow
Write-Host "  Web: https://passdiali.connectapps.org"
Write-Host "  GitHub: https://github.com/naoufalnajim01/PassDiali-CLI"

Write-Host "`nNote: Redemarrez PowerShell si les commandes ne sont pas reconnues`n" -ForegroundColor DarkGray

Write-Host "Test de l'installation..." -ForegroundColor Cyan
try {
    PassDiali -Length 16 -ShowEntropy
    Write-Host "`nTest reussi! PassDiali fonctionne correctement.`n" -ForegroundColor Green
}
catch {
    Write-Host "`nErreur lors du test: $_" -ForegroundColor Yellow
    Write-Host "Veuillez redemarrer PowerShell et reessayer.`n" -ForegroundColor Yellow
}
