import 'package:flutter/material.dart';
import 'package:ticket_wise/Pages/event_page.dart';
// import 'package:ticket_wise/screens/add_event_screen.dart';
import 'package:ticket_wise/screens/home_screen.dart';
import 'package:ticket_wise/screens/profile_screen.dart';
import 'package:ticket_wise/screens/ticket_screen.dart';
import 'package:ticket_wise/widgets/bottom_nav.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _buildScreen() {
    return [
      const HomeScreen(),
      const Eventpage(),
      // const AddEventScreen(),
      TicketScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen()[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
