import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';
import 'package:setaksetikmobile/review/screens/review_home.dart';


class ReviewEntryFormPage extends StatefulWidget {
  final MenuList menu;

  const ReviewEntryFormPage({super.key, required this.menu});

  @override
  _ReviewEntryFormPageState createState() => _ReviewEntryFormPageState();
}

class _ReviewEntryFormPageState extends State<ReviewEntryFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<MenuList> menus = [];

  // Form variables
  String _place = "";
  double _rating = 3.0; // Changed to double for slider
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
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchMenus(request);
  }

    Future<void> fetchMenus(CookieRequest request) async {
    try {
      final response = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');
      if (response != null) {
        setState(() {
          menus = menuListFromJson(jsonEncode(response));
          // filteredMenus = menus;
        });
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load menus');
    }
  }

  void showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF3E3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Success
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF617A55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Title
                const Text(
                  'Review Berhasil Ditambahkan',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B3E39),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),

                // Description
                const Text(
                  'Terima kasih atas review Anda! Apa yang ingin Anda lakukan setelah ini?',
                  style: TextStyle(
                    color: Color(0xFF5B3E39),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B3E39),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Tutup dialog
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                      child: const Text('Kembali'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7B32B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Tutup dialog untuk tambah review lagi
                      },
                      child: const Text('Tambah Review'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Review'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF6D4C41),
        child: Center(
          child: Card(
            color: const Color(0xFFF5F5DC),
            elevation: 8, // Increased elevation
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Menu Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.menu.fields.image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            int index = widget.menu.pk % placeholderImages.length;
                            return Image.asset(
                              placeholderImages[index],
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Menu Name
                      Text(
                        widget.menu.fields.menu,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Restaurant Name
                      Text(
                        widget.menu.fields.restaurantName,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF6D4C41),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Rating Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Your Rating: ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E2723),
                                  ),
                                ),
                                Text(
                                  _rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6D4C41),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _rating,
                              min: 1.0,
                              max: 5.0,
                              divisions: 4,
                              activeColor: const Color(0xFF6D4C41),
                              inactiveColor: const Color(0xFF6D4C41).withOpacity(0.3),
                              onChanged: (double value) {
                                setState(() {
                                  _rating = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Review",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E2723),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Share your experience with this dish...",
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.brown.withOpacity(0.6),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: const TextStyle(color: Colors.black),
                              onChanged: (String? value) {
                                setState(() {
                                  _description = value!;
                                });
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Please share your thoughts about this dish";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D4C41),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final menuIdMapping = <int, int>{};
                              int index = 1;
                              for (var menu in menus) {
                                menuIdMapping[menu.pk] = index++;
                              }
                              int menuId = menuIdMapping[widget.menu.pk] ?? 0;

                              final payload = <String, dynamic>{
                                'menu': menuId,
                                'place': widget.menu.fields.restaurantName,
                                'rating': _rating.round(),
                                'description': _description,
                              };

                              final response = await request.postJson(
                                "https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/review/create-review-flutter/",
                                jsonEncode(payload),
                              );

                              if (response != null) {
                                showSuccessModal(context); // Tampilkan modal sukses
                              }
                            } catch (e) {
                              print('Error: $e');
                            }
                          }
                        },
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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