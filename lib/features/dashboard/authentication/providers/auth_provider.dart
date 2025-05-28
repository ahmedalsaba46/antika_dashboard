import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../repostory/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<UserModel?> build() async {
    // Check if user is stored in SharedPreferences
    return await _getUserFromPrefs();
  }

  Future<UserModel?> _getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? result = prefs.getString('user');

    if (result != null) {
      final value = jsonDecode(result);
      return UserModel.fromJson(value);
    }
    return null;
  }

  String? lastLoginError;

  Future<bool> login({required String email, required String password}) async {
    try {
      lastLoginError = null;
      final user = await AuthRepository.getUser(email: email);

      if (user == null) {
        lastLoginError = 'user_not_found';
        return false;
      }

      if (user.password != password) {
        lastLoginError = 'invalid_password';
        return false;
      }

      // Check if user is admin
      if (user.appRole != 'admin') {
        lastLoginError = 'not_admin';
        return false;
      }

      // Check if user status is active (0)
      if (user.status != 0) {
        if (user.status == 1) {
          lastLoginError = 'user_blocked';
        } else if (user.status == 2) {
          lastLoginError = 'user_pending';
        } else {
          lastLoginError = 'user_inactive';
        }
        return false;
      }

      // Admin user with active status can login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));
      ref.invalidateSelf();
      return true;
    } catch (e) {
      lastLoginError = 'system_error';
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    ref.invalidateSelf();
  }

  Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    ref.invalidateSelf();
  }
}

@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
}
