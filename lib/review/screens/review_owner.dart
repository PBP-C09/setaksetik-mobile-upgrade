import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:setaksetikmobile/review/models/review.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class ReviewOwner extends StatefulWidget {
  const ReviewOwner({super.key});

  @override
  _ReviewOwnerState createState() => _ReviewOwnerState();
}

class _ReviewOwnerState extends State<ReviewOwner> {
  List<ReviewList> reviews = [];
  List<MenuList> menus = [];
  List<ReviewList> filteredReviews = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchReviews(request);
    _searchController.addListener(() {
      filterReviews();
    });
  }
  

  Future<void> fetchMenus(CookieRequest request) async {
    try {
      final response = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');
      if (response != null) {
        setState(() {
          menus = menuListFromJson(jsonEncode(response));
        });
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load menus');
    }
  }
  Future<void> fetchReviews(CookieRequest request) async {
    try {
      final response = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/review/pantau-review-owner/');

      if (response is Map<String, dynamic> && response.containsKey('reviews')) {
        final reviewsData = response['reviews'];

        if (reviewsData is List) {
          final List<ReviewList> tempReviews = [];

          for (var review in reviewsData) {
            // Langsung parse JSON ke ReviewList
            final ReviewList reviewList = ReviewList.fromJson(review);
            tempReviews.add(reviewList);
          }

          setState(() {
            reviews = tempReviews;
            filteredReviews = reviews;
          });
        } else {
          throw Exception("Expected a list for 'reviews'");
        }
      } else {
        throw Exception("Unexpected response format or missing 'reviews' key");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load reviews');
    }
  }

  void filterReviews() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredReviews = reviews
          .where((review) =>
              review.fields.name.toLowerCase().contains(query) ||
              review.fields.place.toLowerCase().contains(query) ||
              review.fields.description.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> submitReply(CookieRequest request, String review_id, String reply_text) async {
    try {
      if (review_id.isNotEmpty && reply_text.isNotEmpty) {
        final response = await request.post(
          'https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/review/submit-reply-flutter/',
          jsonEncode({'review_id': review_id, 'reply_text': reply_text}),
        );
        if (response['status'] == 'success') {
          fetchReviews(request);
        } else {
          throw Exception('Failed to submit reply');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateReplyFlutter(CookieRequest request, String review_id, String reply_text) async {
    try {
      if (review_id.isNotEmpty && reply_text.isNotEmpty) {
        final response = await request.post(
          'https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/review/update-reply-flutter/',
          jsonEncode({'review_id': review_id, 'reply_text': reply_text}),
        );
        if (response['status'] == 'success') {
          fetchReviews(request);
        } else {
          throw Exception('Failed to update reply');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Review'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
                  'Reviews in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Playfair Display',
                    color: Color(0xFFF5F5DC),
                  ),
                ),
                Text(
                  'your restaurant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Playfair Display',
                    color: Color(0xFFF5F5DC),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search reviews...',
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Color(0xFFF5F5DC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                style: const TextStyle(color:Colors.black),
              ),
            ),
            // Display Reviews
            filteredReviews.isEmpty
                ? const Center(
                    child: Text(
                      "No reviews yet :(",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFF5F5DC),
                        fontFamily: 'Playfair Display',
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: filteredReviews.map((review) {
                          return Card(
                            color: const Color(0xFFF5F5DC),
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              review.fields.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: List.generate(
                                              review.fields.rating,
                                              (index) => const Icon(
                                                Icons.star,
                                                color: Color(0xFFFFD54F),
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
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.brown,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            review.fields.place,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.brown,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        review.fields.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      if (review.fields.ownerReply != "No reply yet")
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Balasan Anda:',
                                              style: TextStyle(
                                                color: Color(0xFFF5F5DC),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              color: Colors.white, // White background for the reply
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      review.fields.ownerReply,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Color(0xFF3E2723),
                                                    ),
                                                    onPressed: () async {
                                                      final updatedReply = await showDialog<String>(
                                                        context: context,
                                                        builder: (context) => _ReplyDialog(
                                                          initialText: review.fields.ownerReply,
                                                        ),
                                                      );
                                                      if (updatedReply != null && updatedReply.isNotEmpty) {
                                                        await updateReplyFlutter(
                                                          request, review.pk.toString(), updatedReply);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.brown,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            minimumSize: const Size(180, 45),
                                          ),
                                          onPressed: () async {
                                            final reply = await showDialog<String>(context: context, builder: (context) => _ReplyDialog());
                                            if (reply != null && reply.isNotEmpty) {
                                              await submitReply(request, review.pk.toString(), reply);
                                            }
                                          },
                                          child: const Text('Reply', style: TextStyle(color: Color(0xFFF5F5DC)),),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _ReplyDialog extends StatelessWidget {
  final TextEditingController _controller;
  final String? initialText;

  _ReplyDialog({super.key, this.initialText})
      : _controller = TextEditingController(text: initialText);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20.0),
      title: Center(
        child: Text(
          'Your Reply',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: Color(0xFF3E2723),
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter your reply',
          hintStyle: TextStyle(
            fontFamily: 'Raleway',
            color: Color(0xFFF5F5DC),
          ),
          filled: true,
          fillColor: Color(0xFF3E2723),
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontFamily: 'Raleway',
          color: Color(0xFFF5F5DC),
        ),
        maxLines: 3,
      ),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(_controller.text),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
