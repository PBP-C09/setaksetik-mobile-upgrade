import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:setaksetikmobile/review/models/review.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

class ReviewAdmin extends StatefulWidget {
  const ReviewAdmin({super.key});

  @override
  _ReviewAdminState createState() => _ReviewAdminState();
}

class _ReviewAdminState extends State<ReviewAdmin> {
  List<ReviewList> reviews = [];

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchReviews(request);
  }

  Future<void> deleteReview(String reviewId) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
        'https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/review/delete-review-flutter/',
        // 'http://127.0.0.1:8000/review/delete-review-flutter/',
        jsonEncode({'review_id': reviewId}),
      );

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

  Future<void> fetchReviews(CookieRequest request) async {
    try {
      final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/review/get_review/');

      if (response != null) {
        setState(() {
          reviews = reviewListFromJson(response);
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
        title: const Text('Admin Reviews'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: reviews.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    color: const Color(0xFFF5F5DC), // Cream background
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  review.fields.menu,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
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
                              const SizedBox(width: 8),
                              Text(
                                '${review.fields.rating}/5',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await deleteReview(review.pk.toString());
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            review.fields.description,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          if (review.fields.ownerReply != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Owner Reply: ${review.fields.ownerReply}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
