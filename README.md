# PassDiali CLI

Générateur de mots de passe sécurisé en ligne de commande pour PowerShell.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?logo=powershell)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Windows-blue?logo=windows)

## Pourquoi PassDiali CLI ?

J'ai créé cet outil parce que j'en avais marre de chercher des générateurs de mots de passe en ligne. Avec PassDiali CLI, tout se passe localement sur votre machine - aucune donnée ne part sur internet.

Version web disponible sur [passdiali.connectapps.org](https://passdiali.connectapps.org)

## Installation

### Installation rapide

```powershell
iwr -useb https://raw.githubusercontent.com/naoufalnajim01/PassDiali-CLI/main/install.ps1 | iex
```

### Installation manuelle

```powershell
git clone https://github.com/naoufalnajim01/PassDiali-CLI.git
cd PassDiali-CLI
.\install.ps1
```

## Utilisation

### Commandes de base

```powershell
# Générer un mot de passe simple
PassDiali

# Mot de passe de 32 caractères
PassDiali -Length 32

# Sans symboles
PassDiali -NoSymbols

# Sans caractères ambigus (0, O, l, 1, I)
PassDiali -ExcludeAmbiguous

# Générer plusieurs mots de passe
PassDiali -Count 5
```

### Phrases secrètes

```powershell
# Phrase de 5 mots
PassDiali -Type Passphrase -Words 5

# Avec séparateur personnalisé
PassDiali -Type Passphrase -Words 6 -Separator "-"

# Avec majuscules et chiffres
PassDiali -Type Passphrase -Capitalize -IncludeNumbers
```

### Codes PIN

```powershell
# PIN de 6 chiffres
PassDiali -Type PIN -Length 6
```

### Clés de cryptage

```powershell
# Clé Hex de 256 bits
PassDiali -Type Encryption -Format Hex -KeySize 256

# Clé Base64
PassDiali -Type Encryption -Format Base64 -KeySize 512
```

### Analyser un mot de passe

```powershell
PassDiali -Analyze "VotreMotDePasse123!"
```

## Exemples

Générer un mot de passe pour un compte utilisateur :
```powershell
PassDiali -Length 16 -ExcludeAmbiguous
```

Phrase secrète facile à retenir :
```powershell
PassDiali -Type Passphrase -Words 4 -Capitalize -Separator "-"
# Résultat : Soleil-Montagne-Riviere-Foret
```

Sauvegarder plusieurs mots de passe dans un fichier :
```powershell
PassDiali -Length 20 -Count 10 | Out-File passwords.txt
```

## Sécurité

Le script utilise `System.Security.Cryptography.RNGCryptoServiceProvider` pour générer des nombres aléatoires cryptographiquement sécurisés. Tout est généré localement, rien ne quitte votre machine.

### Calcul d'entropie

L'entropie mesure la force d'un mot de passe :

- Moins de 28 bits : Très faible
- 28-35 bits : Faible
- 36-59 bits : Moyen
- 60-127 bits : Fort
- 128+ bits : Très fort

## Contribution

Les contributions sont bienvenues ! N'hésitez pas à ouvrir une issue ou une pull request.

## Licence

MIT License - voir le fichier [LICENSE](LICENSE)

## Auteur

Naoufal Najim
- Email: naoufal.najim19@gmail.com
- LinkedIn: [Naoufal Najim](https://www.linkedin.com/in/naoufalnajim01/)
- Twitter: [@naoufalnajim01](https://x.com/naoufalnajim01)

---

Fait au Maroc avec PowerShell
