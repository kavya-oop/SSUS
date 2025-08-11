import 'package:flutter/material.dart';
import 'package:trellis_flutter_two/services/auth/auth_service.dart';
import 'package:trellis_flutter_two/pages/startup_pages/register_page.dart';
import 'package:trellis_flutter_two/services/page_transitions.dart';
import 'package:trellis_flutter_two/pages/SUS_page.dart';
import 'package:trellis_flutter_two/services/supabase/user_profile_funcs.dart';
import 'package:trellis_flutter_two/pages/startup_pages/signup_flow.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //get auth service
  final AuthService _authService = AuthService();

  //text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //login button is pressed
  void login(BuildContext context) async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    // attempt to log user in
    try {
      await _authService.signInWithEmail(email, password);

      //check if user has completed signup flow
      loadUserProfileSignUpFlowCompleted().then((value) {
        print('value: $value');
        if (!value) {
          PageTransitions.replaceWith(context, SignupFlowPage());
        } else {
          PageTransitions.replaceWith(context, SUSPage());
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error logging in: $e')));
      }
    }
  }

  //Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
        children: [
          //email
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),

          //password
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),

          //login button
          ElevatedButton(onPressed: () => login(context), child: Text('Login')),

          //go to register page
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            ),

            child: Center(child: Text("Don't have an account? Sign Up")),
          ),
        ],
      ),
    );
  }
}
