import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Review {
  final String author;
  final String text;

  Review({required this.author, required this.text});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReviewPage(), // Menampilkan screen review
    );
  }
}

class ReviewPage extends StatelessWidget {
  final List<Review> reviews = [
    Review(author: 'John Doe', text: 'This is a great book! Really enjoyed it.'),
    Review(author: 'Jane Smith', text: 'The story was a bit slow at first, but it picked up.'),
    Review(author: 'Michael Brown', text: 'Loved the characters, but the plot was predictable.'),
    Review(author: 'Emily White', text: 'An amazing book. Couldn\'t put it down!'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Reviews',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(review.author, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(review.text),
            ),
          );
        },
      ),
    );
  }
}
