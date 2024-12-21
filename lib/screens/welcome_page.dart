import 'package:flutter/material.dart';
import 'package:setaksetikmobile/screens/login.dart';
import 'package:setaksetikmobile/screens/register.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentFeatureIndex = 0;
  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Explore',
      'description': 'Discover various steakhouse options and their menus',
      'color': Color(0xFF3E2723),
      'icon': Icons.find_in_page
    },
    {
      'title': 'Spin',
      'description': 'Get random steak recommendations!',
      'color': Color(0xFF6D4C41),
      'icon': Icons.casino
    },
    {
      'title': 'Review',
      'description': 'Share and read reviews from other steak lovers',
      'color': Color(0xFF842323),
      'icon': Icons.chat
    },
    {
      'title': 'Booking',
      'description': 'Make reservations at your favorite steakhouse',
      'color': Color(0xFF3E2723),
      'icon': Icons.restaurant
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(Duration(seconds: 2), () {
      _startFeatureRotation();
    });
  }

  void _startFeatureRotation() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 2));
      if (!mounted) return false;
      setState(() {
        _currentFeatureIndex = (_currentFeatureIndex + 1) % _features.length;
      });
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 32,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  Text(
                    'SetakSetik',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF842323),
                    ),
                  ),
                ],
              ),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/setaksetik.png',
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),

              // Animated Feature Showcase
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _features[_currentFeatureIndex]['color'],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _features[_currentFeatureIndex]['icon'],
                          color: Color(0xFFF5F5DC),
                          size: 24 + (_controller.value * 4),
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _features[_currentFeatureIndex]['title'],
                                style: TextStyle(
                                  color: Color(0xFFF5F5DC),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Playfair Display',
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                _features[_currentFeatureIndex]['description'],
                                style: TextStyle(
                                  color: Color(0xFFF5F5DC),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Login and Register Buttons
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFF5F5DC),
                      backgroundColor: Color(0xFF842323),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF842323),
                      side: BorderSide(color: Color(0xFF842323)),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}