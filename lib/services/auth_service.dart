import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      isEmailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
    );
  }

  Stream<AppUser?> get userStream {
    return _auth.authStateChanges().map((User? user) {
      if (user == null) return null;
      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        isEmailVerified: user.emailVerified,
        createdAt: user.metadata.creationTime,
      );
    });
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return {'success': false, 'message': 'Заполните все поля'};
      }
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return {'success': true, 'message': 'Регистрация успешна!'};
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Этот email уже используется';
          break;
        case 'invalid-email':
          message = 'Неверный формат email';
          break;
        case 'weak-password':
          message = 'Пароль должен быть не менее 6 символов';
          break;
        default:
          message = e.message ?? 'Ошибка регистрации';
      }
      return {'success': false, 'message': message};
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return {'success': false, 'message': 'Заполните все поля'};
      }
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return {'success': true, 'message': 'Вход выполнен!'};
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Пользователь не найден';
          break;
        case 'wrong-password':
          message = 'Неверный пароль';
          break;
        case 'invalid-email':
          message = 'Неверный формат email';
          break;
        default:
          message = e.message ?? 'Ошибка входа';
      }
      return {'success': false, 'message': message};
    }
  }

  Future<Map<String, dynamic>> signOut() async {
    try {
      await _auth.signOut();
      return {'success': true, 'message': 'Вы вышли из аккаунта'};
    } catch (e) {
      return {'success': false, 'message': 'Ошибка выхода: $e'};
    }
  }
}