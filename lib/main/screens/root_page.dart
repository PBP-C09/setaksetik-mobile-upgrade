import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:setaksetikmobile/main/screens/home.dart';
import 'package:setaksetikmobile/main/screens/userprofile.dart';

class RootPage extends StatefulWidget {
  final String fullName;
  const RootPage({super.key, required this.fullName});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(fullName: widget.fullName),
      const UserProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        color: Color(0xFF6D4C41),
        buttonBackgroundColor: Color(0xFF842323),
        backgroundColor: Color(0xFFF5F5DC),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home_outlined, size: 30, color: Color(0xFFF5F5DC)),
          Icon(Icons.person, size: 30, color: Color(0xFFF5F5DC)),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _pages[_selectedIndex],
    );
  }
}