import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //sign in with email and password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //sign up with email and password
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  //sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  //get current user
  User? getCurrentUser() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user;
  }

  //get current user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  //get current user id
  String? getCurrentUserId() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }
}
