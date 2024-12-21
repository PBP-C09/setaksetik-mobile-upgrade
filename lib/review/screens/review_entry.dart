import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';
import 'package:setaksetikmobile/review/screens/user_review.dart';

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
        title: const Text('Form Tambah Review'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF6D4C41), // Brown background color
        child: Center(
          child: Card(
            color: const Color(0xFFF5F5DC), // Beige card color
            elevation: 5,
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menu details header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image widget with error handling
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.menu.fields.image,
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  int index = widget.menu.pk % placeholderImages.length;
                                  return Image.asset(
                                    placeholderImages[index],
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.menu.fields.menu,
                                    style: const TextStyle(
                                      fontSize: 18.0, // Smaller font size
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3E2723),
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.menu.fields.restaurantName,
                                    style: const TextStyle(
                                      fontSize: 14.0, // Smaller font size
                                      color: Color(0xFF6D4C41),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Rating Field
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Rating (1-5):",
                          style: TextStyle(
                            fontSize: 14.0, // Smaller font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Masukkan rating antara 1-5",
                            hintStyle: const TextStyle(
                              fontSize: 12.0, // Smaller hint text size
                            ),
                            labelText: "Rating",
                            labelStyle: const TextStyle(
                              fontSize: 14.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          style: const TextStyle(color: Colors.black),
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Review Description:",
                          style: TextStyle(
                            fontSize: 14.0, // Smaller font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Tuliskan deskripsi review Anda",
                            hintStyle: const TextStyle(
                              fontSize: 12.0, // Smaller hint text size
                            ),
                            labelText: "Description",
                            labelStyle: const TextStyle(
                              fontSize: 14.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          style: const TextStyle(color: Colors.black),
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
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Less rounded
                              ),
                            ),
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
                                    MaterialPageRoute(
                                        builder: (context) => ReviewMainPage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Gagal menyimpan review. Coba lagi.")),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}