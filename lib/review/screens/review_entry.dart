import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/review/models/review.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';

class ReviewEntryFormPage extends StatefulWidget {
  final MenuList menu;

  const ReviewEntryFormPage({super.key, required this.menu});

  @override
  _ReviewEntryFormPageState createState() => _ReviewEntryFormPageState();
}

class _ReviewEntryFormPageState extends State<ReviewEntryFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form variables
  String _place = "";
  int _rating = 0;
  String _description = "";
  String _ownerReply = "";

  // List of placeholder images
  List<String> placeholderImages = [
    "assets/images/placeholder-image-1.png",
    "assets/images/placeholder-image-2.png",
    "assets/images/placeholder-image-3.png",
    "assets/images/placeholder-image-4.png",
    "assets/images/placeholder-image-5.png",
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Form Tambah Review'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menu details header
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,  // Align text and image at the top
                  children: [
                    // Image widget with error handling
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.menu.fields.image,
                        width: 50,  // Set the width of the image (adjust as necessary)
                        height: 50,  // Set the height of the image (adjust as necessary)
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Return a placeholder image if image not found
                          int index = widget.menu.pk % placeholderImages.length;
                          return Image.asset(
                            placeholderImages[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),  // Space between the image and text
                    // Text widget
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menu name with larger font size and brown color
                          Text(
                            widget.menu.fields.menu,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),  // Brown color
                            ),
                            overflow: TextOverflow.ellipsis,  // Ensure text doesn't overflow
                          ),
                          const SizedBox(height: 4),
                          // Restaurant name in smaller size
                          Text(
                            widget.menu.fields.restaurantName,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF6D4C41),  // Slightly lighter brown
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Rating Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Rating (1-5)",
                    labelText: "Rating",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _rating = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Rating cannot be empty!";
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) > 5) {
                      return "Rating must be a number between 1 and 5!";
                    }
                    return null;
                  },
                ),
              ),

              // Description Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,  // Allow multiple lines for description
                  decoration: InputDecoration(
                    hintText: "Review Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),

              // Save Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final response = await request.postJson(
                            "http://127.0.0.1:8000/review/create-review-flutter/",
                            jsonEncode(<String, dynamic>{
                              'menu': widget.menu.fields.menu,
                              'place': widget.menu.fields.restaurantName,
                              'rating': _rating.toString(),
                              'description': _description,
                              'owner_reply': _ownerReply,
                            }),
                          );

                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Review berhasil disimpan!")),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ReviewPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal menyimpan review. Coba lagi.")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Terjadi kesalahan: $e")),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
