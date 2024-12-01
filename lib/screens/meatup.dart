import 'package:flutter/material.dart';

class MeatUpPage extends StatelessWidget {
  const MeatUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeatUp'),
      ),
      body: const Center(
        child: Text('Ini adalah halaman MeatUp'),
      ),
    );
  }
}
