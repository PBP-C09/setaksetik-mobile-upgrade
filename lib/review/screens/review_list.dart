import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/review/screens/review_entry.dart';  // Import the new review entry page

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<MenuList> menus = [];  // Daftar menu yang di-fetch dari API

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchMenus(request);  // Panggil fungsi untuk fetch menu
  }

  // Fetch menus dari API Django
  Future<void> fetchMenus(CookieRequest request) async {
    try {
      final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');
      if (response != null) { // Pastikan response tidak null
        setState(() {
          menus = menuListFromJson(jsonEncode(response)); // Konversi JSON sesuai format
        });
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load menus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        centerTitle: true,
      ),
      body: menus.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text with italic and cream background color, centered
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Center(
                        child: Text(
                          'Ingin review menu apa?',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Playfair Display',
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFF5F5DC),
                          ),
                        ),
                      ),
                    ),
                    // GridView with 2 cards per row
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 cards per row
                        crossAxisSpacing: 16, // Horizontal space between cards
                        mainAxisSpacing: 16, // Vertical space between cards
                        childAspectRatio: 0.75, // Adjust aspect ratio for each card
                      ),
                      shrinkWrap: true, // Make the grid take only the required space
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          color: const Color(0xFFF5F5DC), // Cream background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,  // Ensure column hugs its content
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image at the top with error handling and AspectRatio
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      menu.fields.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // List of placeholder images
                                        List<String> placeholderImages = [
                                          "assets/images/placeholder-image-1.png",
                                          "assets/images/placeholder-image-2.png",
                                          "assets/images/placeholder-image-3.png",
                                          "assets/images/placeholder-image-4.png",
                                          "assets/images/placeholder-image-5.png",
                                        ];

                                        int index = menu.pk % placeholderImages.length;

                                        return Image.asset(
                                          placeholderImages[index],
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Shrink menu name font size
                                Text(
                                  menu.fields.menu,
                                  style: const TextStyle(
                                    fontSize: 16, // Reduced font size
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Playfair Display',
                                    color: Color(0xFF3E2723),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                // Restaurant name under the menu name, centered
                                Text(
                                  menu.fields.restaurantName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF3E2723),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),  // Push the button to the bottom of the card
                                // "Tambah Review" Button, centered with yellow color
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to the review entry page when the button is tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewEntryFormPage(menu: menu),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, 
                                    backgroundColor: const Color(0xFFF7B32B), // Yellow button
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    minimumSize: const Size(double.infinity, 48),  // Button fills the width of the card
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Tambah Review',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
