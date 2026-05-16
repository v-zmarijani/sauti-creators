import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../supabase/supabase_client.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _currentUser;

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _init();
  }

  void _init() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      _status = AuthStatus.authenticated;
      _loadProfile(session.user.id);
    } else {
      _status = AuthStatus.unauthenticated;
    }

    supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _status = AuthStatus.authenticated;
        _loadProfile(session.user.id);
      } else {
        _status = AuthStatus.unauthenticated;
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadProfile(String userId) async {
    try {
      final data = await supabase.from('users').select().eq('id', userId).single();
      _currentUser = UserModel.fromMap(data);
    } catch (_) {
      // Profile not created yet — handled after signup
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    final res = await supabase.auth.signInWithPassword(email: email, password: password);
    if (res.user != null) await _loadProfile(res.user!.id);
  }

  Future<void> signUpWithEmail(String name, String username, String email, String password) async {
    final res = await supabase.auth.signUp(email: email, password: password);
    if (res.user == null) throw Exception('Sign up failed');

    final userId = res.user!.id;
    final now = DateTime.now().toIso8601String();

    await supabase.from('users').insert({
      'id': userId,
      'name': name,
      'username': username,
      'email': email,
      'followers_count': 0,
      'following_count': 0,
      'posts_count': 0,
      'total_earnings': 0.0,
      'is_verified': false,
      'created_at': now,
    });

    await _loadProfile(userId);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> updateProfile({String? name, String? bio, String? avatarUrl}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (bio != null) updates['bio'] = bio;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await supabase.from('users').update(updates).eq('id', userId);
    await _loadProfile(userId);
  }
}
