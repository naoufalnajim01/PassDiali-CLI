<#
.SYNOPSIS
    Script d'installation de PassDiali CLI

.DESCRIPTION
    Installe PassDiali CLI dans le profil PowerShell pour un accès global

.NOTES
    Auteur: Naoufal Najim
    Version: 1.0.0
#>

$ErrorActionPreference = 'Stop'

Write-Host "`n╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                  ║" -ForegroundColor Cyan
Write-Host "║        🔐 PassDiali CLI - Installation          ║" -ForegroundColor Cyan
Write-Host "║                                                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Vérifier les permissions
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "  ⚠️  " -NoNewline -ForegroundColor Yellow
    Write-Host "Installation recommandée en tant qu'administrateur" -ForegroundColor Yellow
    Write-Host "     Continuer quand même? (O/N): " -NoNewline
    $response = Read-Host
    if ($response -ne 'O' -and $response -ne 'o') {
        Write-Host "`n  ❌ Installation annulée`n" -ForegroundColor Red
        exit
    }
}

Write-Host "  📦 Préparation de l'installation...`n" -ForegroundColor Cyan

# Créer le dossier PassDiali dans Documents
$installPath = Join-Path $env:USERPROFILE "Documents\PassDiali"
if (-not (Test-Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath -Force | Out-Null
    Write-Host "  ✅ Dossier créé: " -NoNewline -ForegroundColor Green
    Write-Host $installPath -ForegroundColor White
}

# Télécharger ou copier le script principal
$scriptPath = Join-Path $installPath "passdiali.ps1"

if (Test-Path ".\passdiali.ps1") {
    # Installation locale
    Copy-Item ".\passdiali.ps1" $scriptPath -Force
    Write-Host "  ✅ Script copié localement" -ForegroundColor Green
}
else {
    # Téléchargement depuis GitHub
    Write-Host "  📥 Téléchargement depuis GitHub..." -ForegroundColor Cyan
    try {
        $url = "https://raw.githubusercontent.com/naoufalnajim01/PassDiali-CLI/main/passdiali.ps1"
        Invoke-WebRequest -Uri $url -OutFile $scriptPath -UseBasicParsing
        Write-Host "  ✅ Script téléchargé" -ForegroundColor Green
    }
    catch {
        Write-Host "  ❌ Erreur de téléchargement: $_" -ForegroundColor Red
        exit 1
    }
}

# Créer un alias dans le profil PowerShell
$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir = Split-Path $profilePath -Parent

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

# Vérifier si l'alias existe déjà
$aliasExists = Select-String -Path $profilePath -Pattern "PassDiali" -Quiet

if (-not $aliasExists) {
    $aliasCommand = @"

# PassDiali CLI - Générateur de mots de passe sécurisé
function PassDiali {
    & "$scriptPath" @args
}
Set-Alias -Name pd -Value PassDiali -Scope Global
"@
    
    Add-Content -Path $profilePath -Value $aliasCommand
    Write-Host "  ✅ Alias ajouté au profil PowerShell" -ForegroundColor Green
}
else {
    Write-Host "  ℹ️  Alias déjà présent dans le profil" -ForegroundColor Yellow
}

# Charger le profil dans la session actuelle
. $profilePath

Write-Host "`n╔════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                                                  ║" -ForegroundColor Green
Write-Host "║        ✅ Installation terminée avec succès!     ║" -ForegroundColor Green
Write-Host "║                                                  ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "  🎉 PassDiali CLI est maintenant installé!`n" -ForegroundColor Cyan

Write-Host "  📝 Commandes disponibles:" -ForegroundColor Yellow
Write-Host "     • " -NoNewline -ForegroundColor DarkGray
Write-Host "PassDiali" -NoNewline -ForegroundColor White
Write-Host "                    - Générer un mot de passe" -ForegroundColor DarkGray
Write-Host "     • " -NoNewline -ForegroundColor DarkGray
Write-Host "pd" -NoNewline -ForegroundColor White
Write-Host "                           - Raccourci (alias)" -ForegroundColor DarkGray
Write-Host "     • " -NoNewline -ForegroundColor DarkGray
Write-Host "Get-Help PassDiali -Full" -NoNewline -ForegroundColor White
Write-Host "     - Documentation complète" -ForegroundColor DarkGray

Write-Host "`n  🚀 Exemples d'utilisation:" -ForegroundColor Yellow
Write-Host "     PassDiali" -ForegroundColor Cyan
Write-Host "     PassDiali -Length 32 -ExcludeAmbiguous" -ForegroundColor Cyan
Write-Host "     PassDiali -Type Passphrase -Words 5" -ForegroundColor Cyan
Write-Host "     PassDiali -Type PIN -Length 6" -ForegroundColor Cyan
Write-Host "     PassDiali -Analyze 'VotreMotDePasse123!'" -ForegroundColor Cyan

Write-Host "`n  🌐 Plus d'infos:" -ForegroundColor Yellow
Write-Host "     Web: " -NoNewline -ForegroundColor DarkGray
Write-Host "https://passdiali.connectapps.org" -ForegroundColor Blue
Write-Host "     GitHub: " -NoNewline -ForegroundColor DarkGray
Write-Host "https://github.com/naoufalnajim01/PassDiali-CLI" -ForegroundColor Blue

Write-Host "`n  💡 Note: " -NoNewline -ForegroundColor Yellow
Write-Host "Redémarrez PowerShell si les commandes ne sont pas reconnues`n" -ForegroundColor DarkGray

# Tester l'installation
Write-Host "  🧪 Test de l'installation..." -ForegroundColor Cyan
try {
    PassDiali -Length 16 -ShowEntropy
    Write-Host "`n  ✅ Test réussi! PassDiali fonctionne correctement.`n" -ForegroundColor Green
}
catch {
    Write-Host "`n  ⚠️  Erreur lors du test: $_" -ForegroundColor Yellow
    Write-Host "     Veuillez redémarrer PowerShell et réessayer.`n" -ForegroundColor Yellow
}
