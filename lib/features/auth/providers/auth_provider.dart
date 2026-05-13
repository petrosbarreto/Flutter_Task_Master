import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_master/core/services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._service) {
    _currentUser = _service.currentUser;
    _subscription = _service.authStateChanges.listen((state) {
      _currentUser = state.session?.user;
      notifyListeners();
    });
  }

  final SupabaseService _service;
  StreamSubscription<AuthState>? _subscription;

  User? _currentUser;
  bool _isBusy = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isBusy => _isBusy;
  String get displayName {
    final metadataName = _currentUser?.userMetadata?['full_name'] as String?;
    if (metadataName != null && metadataName.trim().isNotEmpty) {
      return metadataName.trim();
    }
    final email = _currentUser?.email ?? '';
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return 'Usuario';
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    return _runAuthAction(() async {
      await _service.signInWithEmail(email: email, password: password);
    });
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return _runAuthAction(() async {
      await _service.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
    });
  }

  Future<String?> signOut() async {
    return _runAuthAction(() async {
      await _service.signOut();
    });
  }

  Future<String?> _runAuthAction(Future<void> Function() action) async {
    _isBusy = true;
    notifyListeners();

    try {
      await action();
      return null;
    } on AuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'Ocorreu um erro inesperado. Tente novamente.';
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
