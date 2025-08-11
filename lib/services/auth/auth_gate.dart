/*
AUTH GATE - continously listesn for auth state changes

--------------------------------

unauthenticated -> Login Page
authenticated -> Main Page
*/

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trellis_flutter_two/pages/SUS_page.dart';
import 'package:trellis_flutter_two/pages/startup_pages/login_page.dart';
import 'package:trellis_flutter_two/pages/startup_pages/signup_flow.dart';
import 'package:trellis_flutter_two/services/supabase/user_profile_funcs.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,

      builder: (context, snapshot) {
        //loading current status - is there a user logged in?
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        //if there is a session, return the home page
        if (session != null) {
          // Use FutureBuilder to check signup flow completion
          return FutureBuilder<bool>(
            future: loadUserProfileSignUpFlowCompleted(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData) {
                if (snapshot.data == false) {
                  return const SignupFlowPage();
                } else {
                  return const SUSPage();
                }
              }

              // Default to login page if there's an error
              //TODO: add error handling
              return const LoginPage();
            },
          );
        }

        //if there is no session, return the login page
        return const LoginPage();
      },
    );
  }
}
