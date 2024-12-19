import 'package:flutter/material.dart';

import 'package:setaksetikmobile/main.dart';
import 'package:setaksetikmobile/explore/screens/steak_lover.dart';
import 'package:setaksetikmobile/spinthewheel/screens/spin.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';
import 'package:setaksetikmobile/review/screens/user_review.dart';

import 'package:setaksetikmobile/meatup/screens/meatup.dart';
import 'package:setaksetikmobile/explore/screens/steak_lover.dart';
import 'package:setaksetikmobile/screens/login.dart';
import 'package:setaksetikmobile/booking/screens/booking_home.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String fullName;
  const HomePage({super.key, required this.fullName});

  void _showFeatureDescription(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          backgroundColor: Color(0xFFF5F5DC),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: TextStyle(color: Color(0xFF842323))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonWithInfo(BuildContext context, String label, Widget page,
      Color backgroundColor, Color textColor, String description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            textStyle: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontStyle: FontStyle.italic),
          ),
          child: Text(
            label,
            style: TextStyle(fontFamily: 'Playfair Display', color: textColor),
          ),
        ),
        IconButton(
          icon: Icon(Icons.info_outline, color: Color(0xFF842323)),
          onPressed: () {
            _showFeatureDescription(context, label, description);
          },
        ),
      ],
    );
  }

  List<Widget> _buildRoleSpecificButtons(BuildContext context) {
    final role = UserProfile.data["role"];
    final buttons = <Widget>[];

    if (role == "admin") {
      buttons.addAll([
        _buildButtonWithInfo(
          context,
          'Manage Menus - blm diubah',
          // TODO: EXPLORE ADMIN
          const SpinPage(),
          const Color(0xFF3E2723),
          const Color(0xFFF5F5DC),
          'Manage steakhouse listings and menus.',
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Mange Reviews - blm diubah',
          // TODO: REVIEW ADMIN
          const SpinPage(),
          const Color(0xFF842323),
          const Color(0xFFF5F5DC),
          'Manage customer reviews.',
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Manage Ownership - blm diubah',
          // TODO: BOOKING ADMIN
          const SpinPage(),
          const Color(0xFF6D4C41),
          const Color(0xFFF5F5DC),
          'Manage the ownership of each restaurants, revoke an ownership if necessary!',
        ),
      ]);
    } else if (role == "steakhouse owner") {
      buttons.addAll([
        _buildButtonWithInfo(
          context,
          'Claim a Steakhouse - blm diubah',
          // TODO: CLAIM OWNER
          const SpinPage(),
          const Color(0xFF3E2723),
          const Color(0xFFF5F5DC),
          'Claim a steakhouse!',
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Pantau Review - blm diubah',
          // TODO: REVIEW OWNER
          const SpinPage(),
          const Color(0xFF842323),
          const Color(0xFFF5F5DC),
          'View customer reviews and answer them',
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Pantau Booking - blm diubah',
          // TODO: BOOKING OWNER
          const SpinPage(),
          const Color(0xFF6D4C41),
          const Color(0xFFF5F5DC),
          'Pantau booking di restoranmu!',
        ),
      ]);
    } else {
      buttons.addAll([
        _buildButtonWithInfo(
          context,
          'Explore',
          const MenuPage(),
          const Color(0xFF3E2723),
          const Color(0xFFF5F5DC),
          'Discover various steakhouse options and their menus.',
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Spin',
          const SpinPage(),
          const Color(0xFF6D4C41),
          const Color(0xFFF5F5DC),
          'Spin the wheel to get random steak recommendations!',
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Review',
          const ReviewMainPage(),
          const Color(0xFF842323),
          const Color(0xFFF5F5DC),
          'Share and read reviews from other steak lovers.',
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Meat Up',
          const MeatUpPage(),
          const Color(0xFF3E2723),
          const Color(0xFFF5F5DC),
          'Connect with fellow steak enthusiasts!',
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Booking',
          const BookingPage(),
          const Color(0xFF6D4C41),
          const Color(0xFFF5F5DC),
          'Make reservations at your favorite steakhouse.',
        ),
      ]);
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
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
            ..._buildRoleSpecificButtons(context),
          ],
        ),
      ),
    );
  }
}