import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState({this.studentId});
  final String? studentId;
  bool get isLoggedIn => studentId != null && studentId!.isNotEmpty;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void login(String studentId) {
    state = AuthState(studentId: studentId.trim());
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
