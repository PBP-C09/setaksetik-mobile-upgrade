import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:setaksetikmobile/review/models/review.dart';

class ReviewOwner extends StatefulWidget {
  const ReviewOwner({super.key});

  @override
  _ReviewOwnerState createState() => _ReviewOwnerState();
}

class _ReviewOwnerState extends State<ReviewOwner> {
  List<ReviewList> reviews = [];

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchReviews(request);
  }

  Future<void> fetchReviews(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/review/get_review/');
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

  Future<void> submitReply(CookieRequest request, String review_id, String reply_text) async {
    try {
      if (review_id.isNotEmpty && reply_text.isNotEmpty) {
        final response = await request.post(
          'http://127.0.0.1:8000/review/submit-reply-flutter/',
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
          'http://127.0.0.1:8000/review/update-reply-flutter/',
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
        title: const Text(
          'Owner Reviews',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: reviews.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: reviews.map((review) {
                    return Card(
                      color: const Color(0xFFF5F5DC),
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
                            Text(
                              review.fields.menu,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                            Row(
                              children: [
                                Row(
                                  children: List.generate(
                                    review.fields.rating,
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Color(0xFFE5B700),
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
                            Text(
                              review.fields.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            if (review.fields.ownerReply != null &&
                                review.fields.ownerReply!.isNotEmpty)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 8.0),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Balasan Pemilik: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      review.fields.ownerReply!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.brown,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        minimumSize: Size(180, 45), // Make button longer
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
                                      child: const Text('Edit Reply'),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(180, 45), // Make button longer
                                ),
                                onPressed: () async {
                                  final reply = await showDialog<String>(
                                    context: context,
                                    builder: (context) => _ReplyDialog(),
                                  );
                                  if (reply != null && reply.isNotEmpty) {
                                    await submitReply(request, review.pk.toString(), reply);
                                  }
                                },
                                child: const Text('Reply'),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
      title: Text(initialText == null ? 'Add Reply' : 'Edit Reply'),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Write your reply here',
          fillColor: Colors.brown[50], // Brown background for input field
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Less rounded edges
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown, // Brown button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Less rounded edges
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
