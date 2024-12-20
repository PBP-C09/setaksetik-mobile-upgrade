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

  // Fetch reviews dari API Django
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

  // Fungsi untuk mengirim balasan ke API
  Future<void> submitReply(CookieRequest request, String review_id, String reply_text) async {
    try {
      print('Review ID: $review_id');  // Debug print untuk memastikan pk tidak null
      print('Reply Text: $reply_text');  // Debug print untuk memastikan reply tidak null

      if (review_id.isNotEmpty && reply_text.isNotEmpty) {
        final response = await request.post(
          'http://127.0.0.1:8000/review/submit-reply-flutter/',
          jsonEncode({'review_id': review_id, 'reply_text': reply_text}),
        );
        if (response['status'] == 'success') {
          fetchReviews(request); // Refresh daftar ulasan
        } else {
          throw Exception('Failed to submit reply');
        }
      } else {
        print('Error: Review ID or reply text is empty');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateReplyFlutter(CookieRequest request, String review_id, String reply_text) async {
    try {
      if (review_id.isNotEmpty && reply_text.isNotEmpty) {
        final response = await request.post(
          'http://127.0.0.1:8000/review/update-reply-flutter/',  // Use the Django endpoint
          jsonEncode({'review_id': review_id, 'reply_text': reply_text}),
        );
        if (response['status'] == 'success') {
          // Handle success (e.g., refresh the reviews or show a success message)
          fetchReviews(request);
          print('Reply updated successfully');
        } else {
          throw Exception('Failed to update reply');
        }
      } else {
        print('Error: Review ID or reply text is empty');
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
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Cek apakah ownerReply masih "No reply yet"
                            if (review.fields.ownerReply == 'No reply yet' || review.fields.ownerReply == "") 
                              ElevatedButton(
                                onPressed: () async {
                                  final reply = await showDialog<String>(
                                    context: context,
                                    builder: (context) => _ReplyDialog(),
                                  );
                                  print('Reply from dialog: $reply');  // Debug print untuk melihat balasan dari dialog
                                  if (reply != null && reply.isNotEmpty) {
                                    await submitReply(request, review.pk.toString(), reply);
                                  }
                                },
                                child: const Text('Reply'),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Owner Reply: ${review.fields.ownerReply}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Buka dialog untuk mengedit balasan
                                      final updatedReply = await showDialog<String>(
                                        context: context,
                                        builder: (context) => _ReplyDialog(
                                          initialText: review.fields.ownerReply, // Kirim teks balasan yang ada ke dialog
                                        ),
                                      );
                                      print('Updated Reply from dialog: $updatedReply'); // Debug untuk melihat teks baru
                                      if (updatedReply != null && updatedReply.isNotEmpty) {
                                        print("masuk sini ya");
                                        await updateReplyFlutter(request, review.pk.toString(), updatedReply);
                                        setState(() {}); // Refresh UI setelah mengedit
                                      }
                                    },
                                    child: const Text('Edit Reply'),
                                  ),
                                ],
                              )
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

// Dialog untuk memasukkan balasan
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
        decoration: const InputDecoration(hintText: 'Write your reply here'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog tanpa mengirim balasan
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_controller.text); // Kirim balasan
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

