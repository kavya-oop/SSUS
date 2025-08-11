import 'package:flutter/material.dart';
import '../services/page_transitions.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            onPressed: () async {
              PageTransitions.logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
