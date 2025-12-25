import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isDemoMode = false;
  String? _token;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  bool get isDemoMode => _isDemoMode;
  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  // Hardcoded demo user for offline login
  static const String DEMO_EMAIL = 'user@demo.com';
  static const String DEMO_PASSWORD = 'demo123';
  static const String DEMO_NAME = 'John Doe';

  // Demo data workouts
  static final List<Map<String, dynamic>> DEMO_WORKOUTS = [
    {
      'id': '1',
      'title': 'Chest & Triceps',
      'exercises': ['Push-ups', 'Bench Press', 'Tricep Dips'],
      'date': DateTime.now().subtract(Duration(days: 3)),
    },
    {
      'id': '2',
      'title': 'Back & Biceps',
      'exercises': ['Pull-ups', 'Barbell Rows', 'Curls'],
      'date': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': '3',
      'title': 'Legs',
      'exercises': ['Squats', 'Lunges', 'Leg Press'],
      'date': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'id': '4',
      'title': 'Cardio Session',
      'exercises': ['Running', 'Jump Rope', 'Burpees'],
      'date': DateTime.now(),
    },
  ];

  // ---------------- DEMO LOGIN (OFFLINE) ----------------
  void demoLogin() {
    _isLoggedIn = true;
    _isDemoMode = true;
    _token = 'demo_token_offline';
    _userName = 'Demo User';
    _userEmail = 'demo@fitsync.app';
    notifyListeners();
  }

  // ---------------- LOGIN ----------------
  Future<bool> login(String email, String password) async {
    try {
      // Check hardcoded demo user first (offline login)
      if (email == DEMO_EMAIL && password == DEMO_PASSWORD) {
        _isLoggedIn = true;
        _isDemoMode = true;
        _token = 'demo_token_hardcoded';
        _userName = DEMO_NAME;
        _userEmail = email;
        notifyListeners();
        return true;
      }

      // If not demo user, try API login
      final res = await ApiService.login(email, password);
      if (res['token'] != null) {
        _token = res['token'];
        ApiService.token = _token; // set token for API calls
        _userName = res['user']['name'];
        _userEmail = res['user']['email'];
        _isLoggedIn = true;
        _isDemoMode = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ---------------- REGISTER ----------------
  Future<bool> register(String name, String email, String password) async {
    try {
      final res = await ApiService.register(name, email, password);
      if (res['token'] != null) {
        _token = res['token'];
        ApiService.token = _token;
        _userName = res['user']['name'];
        _userEmail = res['user']['email'];
        _isLoggedIn = true;
        _isDemoMode = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ---------------- LOGOUT ----------------
  void logout() {
    _isLoggedIn = false;
    _isDemoMode = false;
    _token = null;
    _userName = null;
    _userEmail = null;
    ApiService.token = null;
    notifyListeners();
  }
}
