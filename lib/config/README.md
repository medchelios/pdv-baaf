# Configuration de l'API

## Changer l'URL de base de l'API

### Méthode 1 : Via le fichier de configuration (Recommandé)

1. Ouvrir `lib/config/environment.dart`
2. Modifier la méthode `baseUrl` selon l'environnement :

```dart
static String get baseUrl {
  switch (_current) {
    case Environment.development:
      return 'http://127.0.0.1:8000';  // ← Changer ici pour le dev
    case Environment.staging:
      return 'https://staging.baaf-payment-platform.com';
    case Environment.production:
      return 'https://api.baaf-payment-platform.com';
  }
}
```

3. Changer l'environnement dans `main.dart` :

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Changer l'environnement ici
  EnvironmentConfig.setEnvironment(Environment.development);
  
  await AuthService().initialize();
  runApp(const PdvBaafApp());
}
```

### Méthode 2 : Via les constantes (Simple)

1. Ouvrir `lib/config/api_config.dart`
2. Modifier directement :

```dart
static String get baseUrl => 'http://votre-nouvelle-url.com';
```

## Avantages de cette architecture

✅ **Centralisé** : Une seule place pour changer l'URL
✅ **Environnements** : Support dev/staging/production
✅ **Réutilisable** : Tous les services utilisent la même config
✅ **Maintenable** : Facile à modifier et déboguer

## Structure des fichiers

- `environment.dart` - Configuration des environnements
- `api_config.dart` - Configuration centralisée de l'API
- `api_service.dart` - Service HTTP générique
- `auth_service.dart` - Service d'authentification
- `uv_order_service.dart` - Service des commandes UV
