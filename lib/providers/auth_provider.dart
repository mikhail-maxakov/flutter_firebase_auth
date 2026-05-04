import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.userStream.listen((newUser) {
      _user = newUser;
      notifyListeners();
    });
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.register(email, password);
    
    _isLoading = false;
    if (!result['success']) {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
    
    notifyListeners();
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.signIn(email, password);
    
    _isLoading = false;
    if (!result['success']) {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
    
    notifyListeners();
    return true;
  }

  Future<bool> signOut() async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.signOut();
    
    _isLoading = false;
    notifyListeners();
    return result['success'];
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}