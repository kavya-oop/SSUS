import 'package:flutter/material.dart';
import 'package:trellis_flutter_two/services/auth/auth_service.dart';
import '../components/bottom_nav_bar.dart';

class SUSPage extends StatelessWidget {
  const SUSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUS'),
        //actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
