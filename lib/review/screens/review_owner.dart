import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:setaksetikmobile/review/models/review.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

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

  Future<void> submitReply(CookieRequest request, String review_id, String reply_text) async {
    try {
      if (review_id.isNotEmpty && reply_text.isNotEmpty) {
        final response = await request.post(
          'https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/review/submit-reply-flutter/',
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
          'https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/review/update-reply-flutter/',
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
        title: const Text('Owner Reviews'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
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
                                        review.fields.menu,
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
                                if (review.fields.ownerReply != null &&
                                    review.fields.ownerReply!.isNotEmpty)
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
                                                review.fields.ownerReply!,
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
                                                color: Colors.blue, // Blue color for the edit icon
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
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Write your reply here',
          fillColor: Colors.brown[50],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.brown),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
