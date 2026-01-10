<#
.SYNOPSIS
    PassDiali CLI - Générateur de mots de passe sécurisé

.DESCRIPTION
    Générateur de mots de passe cryptographiquement sécurisé pour PowerShell.
    100% local, aucune donnée ne quitte votre machine.

.PARAMETER Length
    Longueur du mot de passe (8-128). Par défaut : 20

.PARAMETER Type
    Type de génération : Password, Passphrase, PIN, Encryption. Par défaut : Password

.PARAMETER Count
    Nombre de mots de passe à générer. Par défaut : 1

.PARAMETER NoSymbols
    Exclure les symboles

.PARAMETER NoNumbers
    Exclure les chiffres

.PARAMETER NoUppercase
    Exclure les majuscules

.PARAMETER NoLowercase
    Exclure les minuscules

.PARAMETER ExcludeAmbiguous
    Exclure les caractères ambigus (0, O, l, 1, I)

.PARAMETER Words
    Nombre de mots pour une passphrase (3-10). Par défaut : 4

.PARAMETER Separator
    Séparateur pour passphrase. Par défaut : -

.PARAMETER Capitalize
    Capitaliser les mots de la passphrase

.PARAMETER IncludeNumbers
    Ajouter des chiffres à la passphrase

.PARAMETER Format
    Format pour clé de cryptage : Hex, Base64, Base32. Par défaut : Hex

.PARAMETER KeySize
    Taille de la clé en bits : 128, 256, 512. Par défaut : 256

.PARAMETER Analyze
    Analyser la force d'un mot de passe existant

.PARAMETER ShowEntropy
    Afficher l'entropie du mot de passe généré

.EXAMPLE
    PassDiali
    Génère un mot de passe par défaut (20 caractères)

.EXAMPLE
    PassDiali -Length 32 -ExcludeAmbiguous
    Génère un mot de passe de 32 caractères sans caractères ambigus

.EXAMPLE
    PassDiali -Type Passphrase -Words 5 -Capitalize
    Génère une phrase secrète de 5 mots capitalisés

.EXAMPLE
    PassDiali -Type PIN -Length 6
    Génère un code PIN de 6 chiffres

.EXAMPLE
    PassDiali -Analyze "MonMotDePasse123!"
    Analyse la force d'un mot de passe

.NOTES
    Auteur: Naoufal Najim
    Version: 1.0.0
    Site Web: https://passdiali.connectapps.org
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateRange(8, 128)]
    [int]$Length = 20,

    [Parameter()]
    [ValidateSet('Password', 'Passphrase', 'PIN', 'Encryption')]
    [string]$Type = 'Password',

    [Parameter()]
    [ValidateRange(1, 100)]
    [int]$Count = 1,

    [Parameter()]
    [switch]$NoSymbols,

    [Parameter()]
    [switch]$NoNumbers,

    [Parameter()]
    [switch]$NoUppercase,

    [Parameter()]
    [switch]$NoLowercase,

    [Parameter()]
    [switch]$ExcludeAmbiguous,

    [Parameter()]
    [ValidateRange(3, 10)]
    [int]$Words = 4,

    [Parameter()]
    [string]$Separator = '-',

    [Parameter()]
    [switch]$Capitalize,

    [Parameter()]
    [switch]$IncludeNumbers,

    [Parameter()]
    [ValidateSet('Hex', 'Base64', 'Base32')]
    [string]$Format = 'Hex',

    [Parameter()]
    [ValidateSet(128, 256, 512)]
    [int]$KeySize = 256,

    [Parameter()]
    [string]$Analyze,

    [Parameter()]
    [switch]$ShowEntropy
)

# Fonction pour générer des nombres aléatoires cryptographiquement sécurisés
function Get-SecureRandom {
    param([int]$Max)
    
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[] 4
    $rng.GetBytes($bytes)
    $value = [BitConverter]::ToUInt32($bytes, 0)
    $rng.Dispose()
    
    return $value % $Max
}

# Fonction pour calculer l'entropie
function Get-PasswordEntropy {
    param([string]$Password)
    
    $charsetSize = 0
    
    if ($Password -cmatch '[a-z]') { $charsetSize += 26 }
    if ($Password -cmatch '[A-Z]') { $charsetSize += 26 }
    if ($Password -match '\d') { $charsetSize += 10 }
    if ($Password -match '[^a-zA-Z0-9]') { $charsetSize += 32 }
    
    $entropy = $Password.Length * [Math]::Log($charsetSize, 2)
    
    return [Math]::Round($entropy, 1)
}

# Fonction pour évaluer la force
function Get-PasswordStrength {
    param([double]$Entropy)
    
    if ($Entropy -lt 28) { return 'Très Faible', 'Red' }
    elseif ($Entropy -lt 36) { return 'Faible', 'DarkYellow' }
    elseif ($Entropy -lt 60) { return 'Moyen', 'Yellow' }
    elseif ($Entropy -lt 128) { return 'Fort', 'Green' }
    else { return 'Très Fort', 'Cyan' }
}

# Fonction pour estimer le temps de crack
function Get-CrackTime {
    param([double]$Entropy)
    
    $combinations = [Math]::Pow(2, $Entropy)
    $guessesPerSecond = 1e10  # 10 milliards de tentatives/seconde
    $seconds = $combinations / $guessesPerSecond
    
    if ($seconds -lt 60) { return "Secondes" }
    elseif ($seconds -lt 3600) { return "Minutes" }
    elseif ($seconds -lt 86400) { return "Heures" }
    elseif ($seconds -lt 31536000) { return "Jours" }
    elseif ($seconds -lt 31536000 * 100) { return "Années" }
    elseif ($seconds -lt 31536000 * 1000000) { return "Siècles" }
    else { return "Millions d'années" }
}

# Fonction d'analyse
function Invoke-PasswordAnalysis {
    param([string]$Password)
    
    Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║     ANALYSE DE SÉCURITÉ - PassDiali      ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝`n" -ForegroundColor Cyan
    
    $entropy = Get-PasswordEntropy -Password $Password
    $strength, $color = Get-PasswordStrength -Entropy $entropy
    $crackTime = Get-CrackTime -Entropy $entropy
    
    Write-Host "  Mot de passe : " -NoNewline
    Write-Host $Password -ForegroundColor White
    Write-Host "  Longueur     : " -NoNewline
    Write-Host "$($Password.Length) caractères" -ForegroundColor White
    Write-Host "  Entropie     : " -NoNewline
    Write-Host "$entropy bits" -ForegroundColor White
    Write-Host "  Force        : " -NoNewline
    Write-Host $strength -ForegroundColor $color
    Write-Host "  Temps crack  : " -NoNewline
    Write-Host $crackTime -ForegroundColor White
    Write-Host ""
}

# Liste de mots pour passphrase (français)
$wordList = @(
    'soleil', 'montagne', 'riviere', 'foret', 'ocean', 'nuage', 'etoile', 'lune',
    'arbre', 'fleur', 'jardin', 'maison', 'route', 'pont', 'ville', 'pays',
    'livre', 'musique', 'danse', 'art', 'science', 'nature', 'temps', 'espace',
    'lumiere', 'ombre', 'couleur', 'forme', 'ligne', 'point', 'cercle', 'carre',
    'triangle', 'sphere', 'cube', 'pyramide', 'cristal', 'diamant', 'perle', 'or',
    'argent', 'bronze', 'fer', 'acier', 'verre', 'pierre', 'sable', 'terre',
    'feu', 'eau', 'air', 'vent', 'pluie', 'neige', 'glace', 'brume',
    'aurore', 'crepuscule', 'midi', 'minuit', 'aube', 'soir', 'jour', 'nuit'
)

# Mode Analyse
if ($Analyze) {
    Invoke-PasswordAnalysis -Password $Analyze
    return
}

# Génération selon le type
switch ($Type) {
    'Password' {
        $uppercase = 'ABCDEFGHJKLMNPQRSTUVWXYZ'
        $lowercase = 'abcdefghijkmnopqrstuvwxyz'
        $numbers = '23456789'
        $symbols = '!@#$%^&*()-_=+[]{}|;:,.<>?'
        
        if ($ExcludeAmbiguous) {
            $uppercase = $uppercase -replace '[O]', ''
            $lowercase = $lowercase -replace '[l]', ''
            $numbers = $numbers -replace '[01]', ''
        }
        
        $charset = ''
        if (-not $NoUppercase) { $charset += $uppercase }
        if (-not $NoLowercase) { $charset += $lowercase }
        if (-not $NoNumbers) { $charset += $numbers }
        if (-not $NoSymbols) { $charset += $symbols }
        
        if ($charset.Length -eq 0) {
            Write-Error "Au moins un type de caractère doit être activé!"
            return
        }
        
        Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║       GÉNÉRATEUR - PassDiali CLI         ║" -ForegroundColor Cyan
        Write-Host "╚════════════════════════════════════════════╝`n" -ForegroundColor Cyan
        
        for ($i = 1; $i -le $Count; $i++) {
            $password = -join (1..$Length | ForEach-Object {
                    $charset[(Get-SecureRandom -Max $charset.Length)]
                })
            
            Write-Host "  [$i] " -NoNewline -ForegroundColor DarkGray
            Write-Host $password -ForegroundColor Green
            
            if ($ShowEntropy) {
                $entropy = Get-PasswordEntropy -Password $password
                $strength, $color = Get-PasswordStrength -Entropy $entropy
                Write-Host "      → Entropie: $entropy bits | Force: " -NoNewline -ForegroundColor DarkGray
                Write-Host $strength -ForegroundColor $color
            }
        }
        Write-Host ""
    }
    
    'Passphrase' {
        Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║      PHRASE SECRÈTE - PassDiali CLI      ║" -ForegroundColor Cyan
        Write-Host "╚════════════════════════════════════════════╝`n" -ForegroundColor Cyan
        
        for ($i = 1; $i -le $Count; $i++) {
            $selectedWords = 1..$Words | ForEach-Object {
                $word = $wordList[(Get-SecureRandom -Max $wordList.Count)]
                if ($Capitalize) { 
                    $word = $word.Substring(0, 1).ToUpper() + $word.Substring(1) 
                }
                $word
            }
            
            $passphrase = $selectedWords -join $Separator
            
            if ($IncludeNumbers) {
                $passphrase += $Separator + (Get-SecureRandom -Max 9999).ToString().PadLeft(4, '0')
            }
            
            Write-Host "  [$i] " -NoNewline -ForegroundColor DarkGray
            Write-Host $passphrase -ForegroundColor Green
            
            if ($ShowEntropy) {
                $entropy = Get-PasswordEntropy -Password $passphrase
                Write-Host "      → Entropie: $entropy bits" -ForegroundColor DarkGray
            }
        }
        Write-Host ""
    }
    
    'PIN' {
        Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║        CODE PIN - PassDiali CLI          ║" -ForegroundColor Cyan
        Write-Host "╚════════════════════════════════════════════╝`n" -ForegroundColor Cyan
        
        for ($i = 1; $i -le $Count; $i++) {
            $pin = -join (1..$Length | ForEach-Object {
                    (Get-SecureRandom -Max 10).ToString()
                })
            
            Write-Host "  [$i] " -NoNewline -ForegroundColor DarkGray
            Write-Host $pin -ForegroundColor Green
        }
        Write-Host ""
    }
    
    'Encryption' {
        Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║    CLÉ DE CRYPTAGE - PassDiali CLI       ║" -ForegroundColor Cyan
        Write-Host "╚════════════════════════════════════════════╝`n" -ForegroundColor Cyan
        
        $bytes = New-Object byte[] ($KeySize / 8)
        $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
        
        for ($i = 1; $i -le $Count; $i++) {
            $rng.GetBytes($bytes)
            
            $key = switch ($Format) {
                'Hex' { ($bytes | ForEach-Object { $_.ToString('X2') }) -join '' }
                'Base64' { [Convert]::ToBase64String($bytes) }
                'Base32' { 
                    # Implémentation Base32 simplifiée
                    $base32 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'
                    $result = ''
                    foreach ($byte in $bytes) {
                        $result += $base32[$byte % 32]
                    }
                    $result
                }
            }
            
            Write-Host "  [$i] " -NoNewline -ForegroundColor DarkGray
            Write-Host $key -ForegroundColor Green
            Write-Host "      → Format: $Format | Taille: $KeySize bits" -ForegroundColor DarkGray
        }
        
        $rng.Dispose()
        Write-Host ""
    }
}

# Footer
Write-Host "  🔐 PassDiali CLI v1.0.0 | " -NoNewline -ForegroundColor DarkGray
Write-Host "https://passdiali.connectapps.org" -ForegroundColor Blue
Write-Host "  💡 Astuce: Utilisez " -NoNewline -ForegroundColor DarkGray
Write-Host "Get-Help PassDiali -Full" -NoNewline -ForegroundColor Yellow
Write-Host " pour plus d'options`n" -ForegroundColor DarkGray
