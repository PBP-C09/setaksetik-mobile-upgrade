import 'package:flutter/material.dart';

import 'package:setaksetikmobile/screens/login.dart';
import 'package:setaksetikmobile/explore/screens/steak_lover.dart';
import 'package:setaksetikmobile/spinthewheel/screens/spin.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';
import 'package:setaksetikmobile/meatup/screens/meatup.dart';
import 'package:setaksetikmobile/explore/screens/steak_lover.dart';
import 'package:setaksetikmobile/screens/login.dart';
import 'package:setaksetikmobile/booking/screens/booking_home.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String fullName;
  const HomePage({super.key, required this.fullName});

  @override
  Widget build(BuildContext context) { 
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello,',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 36.0,
              ),
            ),
            Text(
              fullName,
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 48.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 32.0),
            _buildButton(context, 'Explore', const MenuPage(), const Color(0xFF3E2723), const Color(0xFFF5F5DC)),
            SizedBox(height: 16.0),
            _buildButton(context, 'Spin', const SpinPage(), const Color(0xFF6D4C41), const Color(0xFFF5F5DC)),
            SizedBox(height: 16.0),
            _buildButton(context, 'Review', const ReviewPage(), const Color(0xFF842323), const Color(0xFFF5F5DC)),
            SizedBox(height: 16.0),
            _buildButton(context, 'Meat Up', const MeatUpPage(), const Color(0xFF3E2723), const Color(0xFFF5F5DC)),
            SizedBox(height: 16.0),
            // Empty menuList as placeholder 
            _buildButton(context, 'Booking', const BookingPage(), const Color(0xFF6D4C41), const Color(0xFFF5F5DC)),
            SizedBox(height: 32.0),
            _logoutButton(context, 'Logout', const Color(0xFFF5F5DC), const Color(0xFF842323)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Widget page, Color backgroundColor, Color textColor) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        textStyle: const TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontStyle: FontStyle.italic),
      ),
      child: Text(
        label,
        style: TextStyle(fontFamily: 'Playfair Display', color: textColor),
      ),
    );
  }

  Widget _logoutButton(BuildContext context, String label, Color backgroundColor, Color textColor) {
    final request = context.watch<CookieRequest>();
    return ElevatedButton(
      onPressed: () async {
        final response = await request.logout(
                "http://127.0.0.1:8000/logout-mobile/");
            String message = response["message"];
            if (context.mounted) {
                if (response['status']) {
                    String uname = response["username"];
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("$message Sampai jumpa, $uname."),
                    ));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(message),
                        ),
                    );
                }
            }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        textStyle: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontStyle: FontStyle.italic),
      ),
      child: Text(
        label,
        style: TextStyle(fontFamily: 'Playfair Display', color: textColor),
      ),
    );
  }
}
