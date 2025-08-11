import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';

class SUSReceivedPage extends StatelessWidget {
  const SUSReceivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('SUS Received')),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
