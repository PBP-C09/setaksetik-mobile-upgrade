import 'package:flutter/material.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
      ),
      drawer: LeftDrawer(),
      body: const Center(
        child: Text('Ini adalah halaman Review'),
      ),
    );
  }
}
