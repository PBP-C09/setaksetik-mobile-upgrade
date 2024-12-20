import 'package:flutter/material.dart';
import 'package:setaksetikmobile/booking/screens/pantau_booking.dart';
import 'package:setaksetikmobile/claim/screens/claim_home.dart';
import 'package:setaksetikmobile/claim/screens/manage_ownership.dart';
import 'package:setaksetikmobile/claim/screens/owned_restaurant.dart';

import 'package:setaksetikmobile/main.dart';
import 'package:setaksetikmobile/review/screens/review_owner.dart';
import 'package:setaksetikmobile/screens/root_page.dart';
import 'package:setaksetikmobile/explore/screens/menu_admin.dart';
import 'package:setaksetikmobile/explore/screens/steak_lover.dart';
import 'package:setaksetikmobile/spinthewheel/screens/spin.dart';
import 'package:setaksetikmobile/review/screens/user_review.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';
import 'package:setaksetikmobile/meatup/screens/meatup.dart';
import 'package:setaksetikmobile/booking/screens/booking_home.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  List<Widget> _buildRoleSpecificListTiles(BuildContext context) {
    final role = UserProfile.data["role"];
    final claim = UserProfile.data["claim"];
    final tiles = <Widget>[];

    // Always add Home ListTile for all roles
    tiles.add(
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text('Home'),
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
        ListTile(
          leading: const Icon(Icons.menu_book),
          title: const Text('Manage Menus'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExploreAdmin()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.rate_review),
          title: const Text('Manage Reviews'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SpinPage()), // TODO: Replace with AdminReviewPage
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.admin_panel_settings),
          title: const Text('Manage Ownership'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ManageOwnershipPage()),
            );
          },
        ),
      ]);
    } else if (role == "steakhouse owner") {
      if (claim == 0){
        tiles.addAll([
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Claim a Steakhouse'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ClaimPage()),
              );
            },
          ),
        ]);
      } else {
        tiles.addAll([
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text('My Restaurant'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OwnedRestaurantPage()),
              );
            },
          ),
        ]);
      }
      tiles.addAll([
        ListTile(
          leading: const Icon(Icons.rate_review),
          title: const Text('Pantau Review'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReviewOwner()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.book_online),
          title: const Text('Pantau Booking'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PantauBookingPage()),
            );
          },
        ),
      ]);
    } else {
      // Regular user
      tiles.addAll([
        ListTile(
          leading: const Icon(Icons.find_in_page),
          title: const Text('Explore'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.casino),
          title: const Text('Spin'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SpinPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat),
          title: const Text('Review'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReviewMainPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.call),
          title: const Text('Meat Up'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MeatUpPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.restaurant),
          title: const Text('Booking'),
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
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'SetakSetik',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Specially Curated™",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ..._buildRoleSpecificListTiles(context),
        ],
      ),
    );
  }
}