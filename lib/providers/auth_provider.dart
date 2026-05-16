import 'package:flutter/material.dart';
import '../models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _currentUser;

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
    // TODO: wire Firebase Auth stream
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    // TODO: Firebase signInWithEmailAndPassword
    _status = AuthStatus.authenticated;
    _currentUser = UserModel(
      id: 'demo_id',
      name: 'Demo Creator',
      username: 'democreator',
      email: email,
      bio: 'Content creator from Dar es Salaam 🇹🇿',
      followersCount: 1200,
      followingCount: 340,
      postsCount: 48,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> signUpWithEmail(String name, String username, String email, String password) async {
    // TODO: Firebase createUserWithEmailAndPassword
    _status = AuthStatus.authenticated;
    _currentUser = UserModel(
      id: 'new_user_id',
      name: name,
      username: username,
      email: email,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    // TODO: Firebase signOut
    _status = AuthStatus.unauthenticated;
    _currentUser = null;
    notifyListeners();
  }
}
