import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar review statis untuk tampilan
    final List<Map<String, String>> reviews = [
      {'author': 'John Doe', 'text': 'This is a great book! Really enjoyed it.'},
      {'author': 'Jane Smith', 'text': 'The story was a bit slow at first, but it picked up.'},
      {'author': 'Michael Brown', 'text': 'Loved the characters, but the plot was predictable.'},
      {'author': 'Emily White', 'text': 'An amazing book. Couldn\'t put it down!'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                review['author']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(review['text']!),
            ),
          );
        },
      ),
    );
  }
}
