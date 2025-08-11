import 'package:flutter/material.dart';
import '../services/page_transitions.dart';
import '../pages/SUS_page.dart';
import '../pages/SUS_received_page.dart';
import '../pages/matches_page.dart';
import '../pages/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({super.key, this.currentIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return; // Don't navigate if already on the page

    setState(() {
      _currentIndex = index;
    });

    // Navigate to the corresponding page using PageTransitions
    switch (index) {
      case 0:
        PageTransitions.replaceWith(context, const SUSPage());
        break;
      case 1:
        PageTransitions.replaceWith(context, const SUSReceivedPage());
        break;
      case 2:
        PageTransitions.replaceWith(context, const MatchesPage());
        break;
      case 3:
        PageTransitions.replaceWith(context, const ProfilePage());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border), // Cupid bow representation
          activeIcon: Icon(Icons.favorite),
          label: 'Send SUS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline), // Heart icon
          activeIcon: Icon(Icons.favorite),
          label: 'Received',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail_outline), // Mail with heart
          activeIcon: Icon(Icons.mail),
          label: 'Matches',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline), // User icon
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
