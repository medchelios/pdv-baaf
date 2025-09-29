# PDV BAAF – Flutter App

Ce dépôt contient l’application Flutter PDV BAAF.

## Prérequis

- Flutter 3.x (stable). Vérifier:
  ```bash
  flutter --version
  ```
- Xcode (dernière version) avec iOS Simulator installé.
- CocoaPods installé: `brew install cocoapods` (si nécessaire).

## Lancement rapide (iOS Simulator)

1) Accepter la licence Xcode (une seule fois):
```bash
sudo xcodebuild -license accept
```

2) Mettre à jour les dépendances Flutter:
```bash
flutter clean && flutter pub get
```

3) Vérifier les devices disponibles:
```bash
flutter devices
```

4) Démarrer le simulateur (si besoin):
```bash
open -a Simulator
```

5) Lancer l’app sur iOS (sans flavor/scheme):
```bash
flutter run -d ios
```

> Note: Ne pas utiliser `--flavor` car le projet iOS ne définit pas de schemes personnalisés. L’option provoque l’erreur: "The Xcode project does not define custom schemes."

## Résolution de problèmes (iOS)

- Erreur licence Xcode:
  ```bash
  sudo xcodebuild -license accept
  ```

- Erreur destination/simulator introuvable:
  ```bash
  xcrun simctl list devices | grep Booted -n
  open -a Simulator
  flutter run -d ios
  ```

- Composants iOS manquants (ex: "iOS 26.0 is not installed"):
  - Ouvrez Xcode > Settings > Components et installez la version d’iOS demandée par le simulateur.

- Pods/CocoaPods:
  ```bash
  cd ios && pod install && cd -
  ```

- Diagnostic Flutter général:
  ```bash
  flutter doctor -v
  ```

## Style & Thème

- Material 3 activé, thème clair et sombre (`ThemeMode.system`).
- Couleurs brand alignées avec le projet web (orange/bleu/blanc).

## Commandes utiles

```bash
flutter analyze
flutter test
flutter pub outdated
```
