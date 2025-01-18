import 'package:flutter/material.dart';
import 'package:setaksetikmobile/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/screens/welcome_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF6D4C41),
              child: Icon(
                Icons.person,
                size: 50,
                color: Color(0xFFF5F5DC),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileInfo('You are', UserProfile.data["full_name"]),
            SizedBox(height: 10),
            _buildProfileInfo('Your username is', UserProfile.data["username"]),
            SizedBox(height: 10),
            _buildProfileInfo('You\'re here as', toTitleCase(UserProfile.data["role"])),
            SizedBox(height: 40),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6D4C41),
              fontFamily: 'Raleway',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF3E2723),
              fontFamily: 'Playfair Display',
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return ElevatedButton(
      onPressed: () async {
        final response = await request.logout(
          "http://127.0.0.1:8000/logout-mobile/");

        String message = response["message"];
        if (context.mounted) {
          if (response['status']) {
            String uname = response["username"];
            UserProfile.logout();
            ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    backgroundColor: Color(0xFF3E2723),
                                    content:
                                    Text("See you again, $uname!")),
                                    );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePage()),
            );
          } else {
            ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    backgroundColor: Color(0xFF3E2723),
                                    content:
                                    Text(message)),
                                    );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF842323),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      ),
      child: Text(
        'Logout',
        style: TextStyle(
          color: Color(0xFFF5F5DC),
          fontFamily: 'Playfair Display',
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  String toTitleCase(String s) {
    if (s == null || s.isEmpty) {
      return '';
    }
    
    return s.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

