import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/review/models/review.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';
// import 'package:setaksetikmobile/review/screens/review_form.dart';

class ReviewMainPage extends StatefulWidget {
  const ReviewMainPage({super.key});

  @override
  _ReviewMainPageState createState() => _ReviewMainPageState();
}

class _ReviewMainPageState extends State<ReviewMainPage> {
  List<ReviewList> reviews = [];  // Daftar review yang di-fetch dari API

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchReviews(request);  // Panggil fungsi untuk fetch reviews
  }

  // Fetch reviews dari API Django
  Future<void> fetchReviews(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/review/get_review/');
      
      // Cek apakah response-nya tidak null
      if (response != null) {
        setState(() {
          reviews = reviewListFromJson(response);  // Asumsi response sudah berupa List JSON
        });
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Review',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: reviews.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Add the text before the review list
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Apa kata mereka?',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                                                    const SizedBox(height: 16.0),
                          Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                          const SizedBox(height: 16.0),

                          const SizedBox(height: 8.0),
                          Text(
                            'Dengar cerita dan rekomendasi dari steak enthusiasts di seluruh penjuru',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),

                        ],
                      ),
                    ),
                    // Now display the reviews
                    Column(
                      children: reviews.map((review) {
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              review.fields.menu,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Rating
                                Row(
                                  children: List.generate(
                                    review.fields.rating, // assuming rating is an integer from 1 to 5
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Review text
                                Text(
                                  review.fields.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Owner reply
                                if (review.fields.ownerReply != null)
                                  Text(
                                    'Owner Reply: ${review.fields.ownerReply}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              // Navigate to review form for the selected menu
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPage(),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
      // FloatingActionButton for adding a review (Original position)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to review form
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReviewPage(), // Review form page
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
    );
  }
}

