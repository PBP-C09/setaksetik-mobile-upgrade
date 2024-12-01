import 'package:flutter/material.dart';
import 'explore.dart';
import 'review.dart';
import 'spin.dart';
import 'meatup.dart';
import 'booking.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'Explore', const ExplorePage(), const Color(0xFF3E2723), const Color(0xFFF5F5DC)),
            SizedBox(height: 16.0),
            _buildButton(context, 'Spin', const SpinPage(), const Color(0xFF6D4C41), const Color(0xFFF5F5DC)),
            SizedBox(height: 16.0),
            _buildButton(context, 'Review', const ReviewPage(), const Color(0xFF842323), const Color(0xFFF5F5DC)),
            SizedBox(height: 16.0),
            _buildButton(context, 'Meat Up', const MeatUpPage(), const Color(0xFF3E2723), const Color(0xFFF5F5DC)),
            SizedBox(height: 16.0),
            _buildButton(context, 'Booking', const BookingPage(), const Color(0xFF6D4C41), const Color(0xFFF5F5DC)),
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
        // Belom berhasil aplikasiin font lmao
        textStyle: const TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontStyle: FontStyle.italic),
      ),
      child: Text(
        label,
        style: TextStyle(fontFamily: 'Playfair Display', color: textColor),
      ),
    );
  }
}
