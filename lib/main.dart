import 'package:flutter/material.dart';
import 'package:trellis_flutter_two/services/auth/auth_gate.dart';
//import 'theme_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; //supabase import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //supabase init
  await Supabase.initialize(
    url: 'https://qkqwswkiymuyutxmdhag.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrcXdzd2tpeW11eXV0eG1kaGFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI5NzI5MTUsImV4cCI6MjA2ODU0ODkxNX0.Za304dYP_2BS4Egg_XQhm9YqQ3jUwbZ1PA_Pck9ekko',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate());
  }
}
