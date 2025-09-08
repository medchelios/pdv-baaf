import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/mobile/agent';
  String? _token;
  Map<String, dynamic>? _user;

  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Initialiser le service au démarrage de l'app
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      _user = jsonDecode(userJson);
    }
  }

  // Sauvegarder les données d'authentification
  Future<void> _saveAuthData(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', jsonEncode(user));
    _token = token;
    _user = user;
  }

  // Effacer les données d'authentification
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    _token = null;
    _user = null;
  }

  // Connexion avec email/mot de passe (agents normaux)
  Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    try {
      print('🔐 Tentative de connexion avec email: $email');
      print('🌐 URL: $baseUrl/auth/login');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📡 Headers: ${response.headers}');
      print('📡 Body: ${response.body}');

      final result = jsonDecode(response.body);
      
      if (result['success'] == true) {
        print('✅ Connexion réussie');
        await _saveAuthData(
          result['data']['token'],
          result['data']['user'],
        );
      } else {
        print('❌ Échec de connexion: ${result['message']}');
      }
      
      return result;
    } catch (e) {
      print('💥 Erreur lors de la connexion: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  // Connexion avec mot de passe 4 chiffres (agents PDV)
  Future<Map<String, dynamic>> loginWithPin(String pin) async {
    try {
      print('🔐 Tentative de connexion PDV avec PIN: $pin');
      print('🌐 URL: $baseUrl/auth/login-pdv');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login-pdv'),
        headers: _headers,
        body: jsonEncode({
          'pin': pin,
        }),
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📡 Headers: ${response.headers}');
      print('📡 Body: ${response.body}');

      final result = jsonDecode(response.body);
      
      if (result['success'] == true) {
        print('✅ Connexion PDV réussie');
        await _saveAuthData(
          result['data']['token'],
          result['data']['user'],
        );
      } else {
        print('❌ Échec de connexion PDV: ${result['message']}');
      }
      
      return result;
    } catch (e) {
      print('💥 Erreur lors de la connexion PDV: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  // Déconnexion
  Future<Map<String, dynamic>> logout() async {
    try {
      if (_token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: _headers,
        );
        await _clearAuthData();
        return jsonDecode(response.body);
      }
      return {'success': true, 'message': 'Déconnexion réussie'};
    } catch (e) {
      await _clearAuthData();
      return {
        'success': false,
        'message': 'Erreur de déconnexion: $e',
      };
    }
  }

  // Vérifier si l'utilisateur est un agent PDV
  bool get isPdvAgent {
    return _user?['role'] == 'point_vente' || _user?['role'] == 'pdv';
  }

  // Vérifier si l'utilisateur est un agent normal
  bool get isNormalAgent {
    return !isPdvAgent && _user != null;
  }
}
