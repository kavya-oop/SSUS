import 'package:flutter/material.dart';
import 'package:trellis_flutter_two/services/auth/auth_service.dart';
import 'package:trellis_flutter_two/pages/startup_pages/login_page.dart';
import 'package:trellis_flutter_two/services/supabase/user_profile_funcs.dart';
import 'package:trellis_flutter_two/services/page_transitions.dart';
import 'package:trellis_flutter_two/pages/startup_pages/signup_flow.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //get auth service
  final AuthService _authService = AuthService();

  //text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //login button is pressed
  void signUp() async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // check if passwords match
    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Passwords don't match")));
        return;
      }
    }

    // attempt to sign up user
    try {
      await _authService.signUpWithEmail(email, password);

      //create new row in user_profile table
      try {
        await createUserProfileRow();

        // if profile was created, pop the register page
        PageTransitions.replaceWith(context, SignupFlowPage());
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating user profile in database: $e'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing up: $e')));
      }
    }
  }

  //Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),

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

          //confirm password
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
          ),

          //sign up button
          ElevatedButton(onPressed: signUp, child: Text('Sign Up')),

          //go to login page
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ),

            child: Center(child: Text("Already have an account? Login")),
          ),
        ],
      ),
    );
  }
}
