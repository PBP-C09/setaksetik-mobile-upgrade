import 'package:flutter/material.dart';
import 'package:setaksetikmobile/main.dart';

import 'package:setaksetikmobile/claim/screens/claim_home.dart';
import 'package:setaksetikmobile/claim/screens/manage_ownership.dart';
import 'package:setaksetikmobile/explore/screens/menu_admin.dart';
import 'package:setaksetikmobile/claim/screens/owned_restaurant.dart';

import 'package:setaksetikmobile/explore/screens/menu_home.dart';
import 'package:setaksetikmobile/spinthewheel/screens/spin.dart';
import 'package:setaksetikmobile/review/screens/review_admin.dart';
import 'package:setaksetikmobile/review/screens/review_owner.dart';
import 'package:setaksetikmobile/review/screens/review_home.dart';
import 'package:setaksetikmobile/meatup/screens/meatup.dart';
import 'package:setaksetikmobile/booking/screens/booking_home.dart';
import 'package:setaksetikmobile/booking/screens/pantau_booking.dart';

class HomePage extends StatelessWidget {
  final String fullName;
  const HomePage({super.key, required this.fullName});

  void _showFeatureDescription(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0xFF3E2723).withOpacity(0.8),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5DC),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: const Color(0xFF6D4C41),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3E2723).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6D4C41),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3E2723),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF842323),
                    foregroundColor: const Color(0xFFF5F5DC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonWithInfo(BuildContext context, String label, Widget page,
      Color backgroundColor, Color textColor, String description, IconData icon, bool odd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (odd)
        IconButton(
          icon: Icon(icon, color: backgroundColor),
          onPressed: () {
            _showFeatureDescription(context, label, description);
          },
        ),
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
        if (!odd)
        IconButton(
          icon: Icon(icon, color: backgroundColor),
          onPressed: () {
            _showFeatureDescription(context, label, description);
          },
        ),
      ],
    );
  }

  List<Widget> _buildRoleSpecificButtons(BuildContext context) {
    final role = UserProfile.data["role"];
    final claim = UserProfile.data["claim"];
    final buttons = <Widget>[];

    if (role == "admin") {
      buttons.addAll([
        _buildButtonWithInfo(
          context,
          'Manage Menus',
          const ExploreAdmin(),
          const Color(0xFF3E2723),
          const Color(0xFFF5F5DC),
          'Manage steakhouse listings and menus.',
          Icons.menu_book,
          true
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Manage Reviews',
          const ReviewAdmin(),
          const Color(0xFF842323),
          const Color(0xFFF5F5DC),
          'Manage customer reviews.',
          Icons.rate_review,
          false
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Manage Ownership',
          const ManageOwnershipPage(),
          const Color(0xFF6D4C41),
          const Color(0xFFF5F5DC),
          'Manage the ownership of each restaurants, revoke an ownership if necessary!',
          Icons.admin_panel_settings,
          true
        ),
      ]);
    } else if (role == "steakhouse owner") {
      if (claim == 0) {
        buttons.addAll([
          // Tombol untuk claim restoran
          _buildButtonWithInfo(
            context,
            'Claim a Steakhouse',
            const ClaimPage(),
            const Color(0xFF3E2723),
            const Color(0xFFF5F5DC),
            'Claim a steakhouse if it\'s yours!',
            Icons.store,
            false,
          ),
          SizedBox(height: 16.0),
        ]);
      } else {
        buttons.addAll([
          // Tombol untuk melihat restoran yang dimiliki
          _buildButtonWithInfo(
            context,
            'My Restaurant',
            const OwnedRestaurantPage(),
            const Color(0xFF3E2723),
            const Color(0xFFF5F5DC),
            'See the restaurant you own!',
            Icons.restaurant,
            false,
          ),
          SizedBox(height: 16.0),
        ]);
      }

      buttons.addAll([
        // Tombol untuk memantau review
        _buildButtonWithInfo(
          context,
          'Monitor Review',
          const ReviewOwner(),
          const Color(0xFF842323),
          const Color(0xFFF5F5DC),
          'View customer reviews and answer them',
          Icons.rate_review,
          true,
        ),
        SizedBox(height: 16.0),

        // Tombol untuk memantau booking
        _buildButtonWithInfo(
          context,
          'Monitor Booking',
          const PantauBookingPage(),
          const Color(0xFF6D4C41),
          const Color(0xFFF5F5DC),
          'Monitor bookings made in your restaurant',
          Icons.book_online,
          false,
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
          Icons.find_in_page,
        true
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Spin',
          const SpinPage(),
          const Color(0xFF6D4C41),
          const Color(0xFFF5F5DC),
          'Spin the wheel to get random steak recommendations!',
          Icons.casino,
          false
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Review',
          const ReviewMainPage(),
          const Color(0xFF842323),
          const Color(0xFFF5F5DC),
          'Share and read reviews from other steak lovers.',
          Icons.rate_review,
          true
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Meat Up',
          const MeatUpPage(),
          const Color(0xFF3E2723),
          const Color(0xFFF5F5DC),
          'Connect with fellow steak enthusiasts!',
          Icons.people,
          false
        ),
        SizedBox(height: 16.0),
        _buildButtonWithInfo(
          context,
          'Booking',
          const BookingPage(),
          const Color(0xFF6D4C41),
          const Color(0xFFF5F5DC),
          'Make reservations at your favorite steakhouse.',
          Icons.restaurant,
          true
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
            Image.asset(
              'assets/images/setaksetik-bg.png',
              height: 140,
              width: 140,
            ),
            const Text(
              'SetakSetik Says Hi,',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24.0,
              ),
            ),
            Text(
              fullName,
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 24.0,
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