import 'package:flutter/material.dart';
import 'package:setaksetikmobile/booking/screens/pantau_booking.dart';
import 'package:setaksetikmobile/claim/screens/claim_home.dart';
import 'package:setaksetikmobile/claim/screens/manage_ownership.dart';
import 'package:setaksetikmobile/claim/screens/owned_restaurant.dart';
import 'package:setaksetikmobile/main.dart';
import 'package:setaksetikmobile/review/screens/review_admin.dart';
import 'package:setaksetikmobile/review/screens/review_owner.dart';
import 'package:setaksetikmobile/screens/root_page.dart';
import 'package:setaksetikmobile/explore/screens/menu_admin.dart';
import 'package:setaksetikmobile/explore/screens/menu_home.dart';
import 'package:setaksetikmobile/spinthewheel/screens/spin.dart';
import 'package:setaksetikmobile/review/screens/review_home.dart';
import 'package:setaksetikmobile/meatup/screens/meatup.dart';
import 'package:setaksetikmobile/booking/screens/booking_home.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  List<Widget> _buildRoleSpecificListTiles(BuildContext context) {
    final role = UserProfile.data["role"];
    final claim = UserProfile.data["claim"];
    final tiles = <Widget>[];

    const List<Color> alternatingColors = [
      Color(0xFF3E2723),
      Color(0xFF6D4C41), 
      Color(0xFF842323),
    ];

    int colorIndex = 0;

    Widget createStyledListTile({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      Color textIconColor = alternatingColors[colorIndex];
      colorIndex = (colorIndex + 1) % alternatingColors.length;

      return ListTile(
        leading: Icon(icon, color: textIconColor, size: 26),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textIconColor,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      );
    }

    tiles.add(
      createStyledListTile(
        icon: Icons.home_outlined,
        title: 'Home',
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => RootPage(fullName: UserProfile.data["full_name"]),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
    );

    if (role == "admin") {
      tiles.addAll([
        createStyledListTile(
          icon: Icons.menu_book,
          title: 'Manage Menus',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExploreAdmin()),
            );
          },
        ),
        createStyledListTile(
          icon: Icons.rate_review,
          title: 'Manage Reviews',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReviewAdmin()),
            );
          },
        ),
        createStyledListTile(
          icon: Icons.admin_panel_settings,
          title: 'Manage Ownership',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ManageOwnershipPage()),
            );
          },
        ),
      ]);
    } else if (role == "steakhouse owner") {
      if (claim == 0) {
        tiles.add(
          createStyledListTile(
            icon: Icons.store,
            title: 'Claim a Steakhouse',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ClaimPage()),
              );
            },
          ),
        );
      } else {
        tiles.add(
          createStyledListTile(
            icon: Icons.restaurant,
            title: 'My Restaurant',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OwnedRestaurantPage()),
              );
            },
          ),
        );
      }
      tiles.addAll([
        createStyledListTile(
          icon: Icons.rate_review,
          title: 'Manage Review',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReviewOwner()),
            );
          },
        ),
        createStyledListTile(
          icon: Icons.book_online,
          title: 'Manage Booking',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PantauBookingPage()),
            );
          },
        ),
      ]);
    } else {
      // Steak Lover
      tiles.addAll([
        createStyledListTile(
          icon: Icons.find_in_page,
          title: 'Explore',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuPage()),
            );
          },
        ),
        createStyledListTile(
          icon: Icons.casino,
          title: 'Spin',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SpinPage()),
            );
          },
        ),
        createStyledListTile(
          icon: Icons.rate_review,
          title: 'Review',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReviewMainPage()),
            );
          },
        ),
        createStyledListTile(
          icon: Icons.people,
          title: 'Meat Up',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MeatUpPage()),
            );
          },
        ),
        createStyledListTile(
          icon: Icons.restaurant,
          title: 'Booking',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BookingPage()),
            );
          },
        ),
      ]);
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF5F5DC),
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SetakSetik',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF3E2723),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Specially Curated™",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3E2723),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF6D4C41),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildRoleSpecificListTiles(context),
            ),
          ),
        ],
      ),
    );
  }
}