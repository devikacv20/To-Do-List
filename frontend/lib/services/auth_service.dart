import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['profile', 'email'],
  );
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) throw Exception('Failed to get ID token');

      final result = await _apiService.googleAuth(idToken);
      
      // Store user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', result['email']);
      await prefs.setString('user_name', result['name']);
      await prefs.setInt('user_id', result['user_id']);

      return result;
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_email');
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final name = prefs.getString('user_name');
    final userId = prefs.getInt('user_id');

    if (email != null && name != null && userId != null) {
      return {
        'email': email,
        'name': name,
        'user_id': userId,
      };
    }
    return null;
  }
}