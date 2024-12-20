import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/review/models/review.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';
// import 'package:setaksetikmobile/review/screens/review_form.dart';

class ReviewAdmin extends StatefulWidget {
  const ReviewAdmin({super.key});

  @override
  _ReviewAdminState createState() => _ReviewAdminState();
}

class _ReviewAdminState extends State<ReviewAdmin> {
  List<ReviewList> reviews = [];  // Daftar review yang di-fetch dari API

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchReviews(request);  // Panggil fungsi untuk fetch reviews
  }
  Future<void> deleteReview(String reviewId) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/review/delete-review-flutter/',
        jsonEncode({'review_id': reviewId}),
      );

      // Handle response
      if (response['status'] == 'success') {
        setState(() {
          reviews.removeWhere((review) => review.pk == reviewId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete review: $e')),
      );
    }
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
                                Row(
                                  children: List.generate(
                                    review.fields.rating,
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  review.fields.description,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
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
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await deleteReview(review.pk.toString());
                              },
                            ),
                            onTap: () {
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
