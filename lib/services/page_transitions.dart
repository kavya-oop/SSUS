import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/startup_pages/login_page.dart';

class PageTransitions {
  // Generic function for instant navigation with push
  static void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
            ) {
              return page;
            },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  // Generic function for instant navigation with replace
  static void replaceWith(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
            ) {
              return page;
            },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  //logout function
  static void logout(BuildContext context) {
    Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }
}
