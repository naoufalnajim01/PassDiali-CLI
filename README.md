# 🔐 PassDiali CLI

<p align="center">
  <img src="https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="PowerShell"/>
  <img src="https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Windows"/>
  <img src="https://img.shields.io/badge/Security-100%25_Local-success?style=for-the-badge" alt="100% Local"/>
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="MIT License"/>
</p>

<p align="center">
  <strong>Générateur de mots de passe sécurisé en ligne de commande PowerShell</strong><br>
  100% local • Aucune donnée transmise • Open Source
</p>

<p align="center">
  🌐 <a href="https://passdiali.connectapps.org">Version Web</a> • 
  📖 <a href="#installation">Installation</a> • 
  🚀 <a href="#utilisation">Utilisation</a> • 
  🔒 <a href="#sécurité">Sécurité</a>
</p>

---

## 📋 Table des Matières

- [À propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Exemples](#-exemples)
- [Sécurité](#-sécurité)
- [Contribution](#-contribution)
- [Licence](#-licence)
- [Auteur](#-auteur)

---

## 🎯 À propos

**PassDiali CLI** est un générateur de mots de passe puissant et sécurisé pour PowerShell, conçu pour les administrateurs système, développeurs et utilisateurs soucieux de leur sécurité.

### Pourquoi PassDiali CLI ?

- ✅ **100% Local** : Aucune donnée ne quitte votre machine
- ✅ **Cryptographiquement sécurisé** : Utilise `System.Security.Cryptography.RNGCryptoServiceProvider`
- ✅ **Flexible** : Mots de passe, phrases secrètes, codes PIN, clés de cryptage
- ✅ **Calcul d'entropie** : Évalue la force de vos mots de passe
- ✅ **Open Source** : Code transparent et auditable
- ✅ **Facile à utiliser** : Interface en ligne de commande intuitive

---

## ✨ Fonctionnalités

### 🔑 Génération de Mots de Passe
- Longueur personnalisable (8-128 caractères)
- Majuscules, minuscules, chiffres, symboles
- Exclusion des caractères ambigus (optionnel)
- Génération par lots

### 🗝️ Phrases Secrètes (Passphrase)
- Basées sur des listes de mots
- Séparateurs personnalisables
- Capitalisation optionnelle
- Ajout de chiffres

### 🔢 Codes PIN
- Longueur variable (4-16 chiffres)
- Génération cryptographiquement sécurisée

### 🔐 Clés de Cryptage
- Formats : Hex, Base64, Base32
- Longueurs standards : 128, 256, 512 bits

### 📊 Analyse de Sécurité
- Calcul d'entropie en bits
- Estimation du temps de crack
- Évaluation de la force (Faible/Moyen/Fort/Très Fort)

---

## 📥 Installation

### Méthode 1 : Installation Rapide (Recommandée)

```powershell
# Télécharger et installer en une seule commande
iwr -useb https://raw.githubusercontent.com/naoufalnajim01/PassDiali-CLI/main/install.ps1 | iex
```

### Méthode 2 : Installation Manuelle

```powershell
# Cloner le repository
git clone https://github.com/naoufalnajim01/PassDiali-CLI.git

# Naviguer dans le dossier
cd PassDiali-CLI

# Exécuter le script d'installation
.\install.ps1
```

### Méthode 3 : Utilisation Directe (Sans Installation)

```powershell
# Télécharger le script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/naoufalnajim01/PassDiali-CLI/main/passdiali.ps1" -OutFile "passdiali.ps1"

# Exécuter
.\passdiali.ps1
```

---

## 🚀 Utilisation

### Commandes de Base

```powershell
# Générer un mot de passe par défaut (20 caractères, tous types)
PassDiali

# Générer un mot de passe de 32 caractères
PassDiali -Length 32

# Mot de passe sans symboles
PassDiali -NoSymbols

# Mot de passe sans caractères ambigus
PassDiali -ExcludeAmbiguous

# Générer 5 mots de passe
PassDiali -Count 5
```

### Phrases Secrètes

```powershell
# Phrase secrète de 5 mots
PassDiali -Type Passphrase -Words 5

# Avec séparateur personnalisé
PassDiali -Type Passphrase -Words 6 -Separator "-"

# Avec capitalisation et chiffres
PassDiali -Type Passphrase -Capitalize -IncludeNumbers
```

### Codes PIN

```powershell
# PIN de 6 chiffres
PassDiali -Type PIN -Length 6

# PIN de 8 chiffres
PassDiali -Type PIN -Length 8
```

### Clés de Cryptage

```powershell
# Clé Hex de 256 bits
PassDiali -Type Encryption -Format Hex -KeySize 256

# Clé Base64 de 512 bits
PassDiali -Type Encryption -Format Base64 -KeySize 512
```

### Analyse de Sécurité

```powershell
# Analyser un mot de passe existant
PassDiali -Analyze "MonMotDePasse123!"

# Générer et analyser
PassDiali -Length 24 -ShowEntropy
```

---

## 📚 Exemples

### Exemple 1 : Mot de Passe pour Compte Utilisateur

```powershell
PassDiali -Length 16 -ExcludeAmbiguous
# Résultat : kR7#mN2pL9@xT4wB
# Entropie : 95.4 bits (Très Fort)
```

### Exemple 2 : Phrase Secrète Mémorable

```powershell
PassDiali -Type Passphrase -Words 4 -Capitalize -Separator "-"
# Résultat : Soleil-Montagne-Riviere-Foret
# Entropie : 51.7 bits (Fort)
```

### Exemple 3 : Clé API

```powershell
PassDiali -Type Encryption -Format Base64 -KeySize 256
# Résultat : 8kJ9mN2pL4xT7wB3qR6vY1zA5cF8hG0dS4eW9iO2uP7
```

### Exemple 4 : Génération par Lots

```powershell
PassDiali -Length 20 -Count 10 -ExcludeAmbiguous | Out-File passwords.txt
# Génère 10 mots de passe et les sauvegarde dans un fichier
```

---

## 🔒 Sécurité

### Principes de Sécurité

1. **Génération Locale** : Tout se passe sur votre machine, aucune connexion réseau
2. **Cryptographie Forte** : Utilise `RNGCryptoServiceProvider` de .NET
3. **Pas de Stockage** : Aucun mot de passe n'est sauvegardé automatiquement
4. **Open Source** : Code transparent et auditable par la communauté

### Bonnes Pratiques

- ✅ Utilisez des mots de passe d'au moins 16 caractères
- ✅ Activez tous les types de caractères (majuscules, minuscules, chiffres, symboles)
- ✅ Utilisez un gestionnaire de mots de passe pour stocker vos mots de passe
- ✅ Ne réutilisez jamais le même mot de passe
- ✅ Changez régulièrement vos mots de passe critiques

### Calcul d'Entropie

L'entropie mesure la force d'un mot de passe :

| Entropie (bits) | Force | Temps de Crack (estimation) |
|-----------------|-------|----------------------------|
| < 28 | Très Faible | Secondes |
| 28-35 | Faible | Minutes |
| 36-59 | Moyen | Jours à années |
| 60-127 | Fort | Siècles |
| ≥ 128 | Très Fort | Millions d'années |

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment participer :

1. **Fork** le projet
2. Créez une **branche** pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. **Committez** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une **Pull Request**

### Idées de Contribution

- 🌍 Traductions (EN, ES, AR, etc.)
- 🎨 Amélioration de l'interface CLI
- 🔧 Nouvelles fonctionnalités
- 📖 Documentation
- 🐛 Corrections de bugs

---

## 📄 Licence

Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👤 Auteur

**Naoufal Najim**

- 💼 Responsable Informatique | MLF Monde
- 🌍 Morocco 🇲🇦
- 📧 Email: [naoufal.najim19@gmail.com](mailto:naoufal.najim19@gmail.com)
- 🔗 LinkedIn: [Naoufal Najim](https://www.linkedin.com/in/naoufalnajim01/)
- 🐦 X/Twitter: [@naoufalnajim01](https://x.com/naoufalnajim01)
- 🌐 GitHub: [@naoufalnajim01](https://github.com/naoufalnajim01)

---

## 🌟 Support

Si vous trouvez ce projet utile, n'hésitez pas à :

- ⭐ **Star** le repository
- 🐛 Signaler des bugs via les [Issues](https://github.com/naoufalnajim01/PassDiali-CLI/issues)
- 💡 Proposer des améliorations
- 📢 Partager avec vos collègues

---

## 🔗 Liens Utiles

- 🌐 **Version Web** : [passdiali.connectapps.org](https://passdiali.connectapps.org)
- 📖 **Documentation** : [Wiki](https://github.com/naoufalnajim01/PassDiali-CLI/wiki)
- 🐛 **Issues** : [Bug Tracker](https://github.com/naoufalnajim01/PassDiali-CLI/issues)
- 💬 **Discussions** : [GitHub Discussions](https://github.com/naoufalnajim01/PassDiali-CLI/discussions)

---

<p align="center">
  <strong>Fait avec ❤️ au Maroc 🇲🇦</strong><br>
  <sub>© 2026 Naoufal Najim. Tous droits réservés.</sub>
</p>

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&height=100&section=footer" alt="Footer"/>
</p>
