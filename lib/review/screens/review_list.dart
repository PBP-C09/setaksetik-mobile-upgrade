import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/review/screens/review_entry.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<MenuList> menus = [];
  List<MenuList> filteredMenus = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchMenus(request);
  }

  Future<void> fetchMenus(CookieRequest request) async {
    try {
      final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');
      if (response != null) {
        setState(() {
          menus = menuListFromJson(jsonEncode(response));
          filteredMenus = menus;
        });
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load menus');
    }
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredMenus = menus
          .where((menu) => menu.fields.menu.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        centerTitle: true,
      ),
      body: menus.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5DC), // Cream background
                      borderRadius: BorderRadius.circular(30), // Fully rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: updateSearch,
                      decoration: InputDecoration(
                        hintText: "Cari menu...",
                        hintStyle: const TextStyle(
                          color: Color(0xFF8D6E63), // Warna placeholder coklat lembut
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF8D6E63)),
                        filled: true,
                        fillColor: const Color(0xFFF5F5DC), // Latar belakang cream
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Sudut bulat penuh
                          borderSide: BorderSide.none, // Hilangkan garis border
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      style: const TextStyle(
                        color: Colors.black, // Warna font hitam untuk teks input
                        fontSize: 16, // Ukuran font teks input
                      ),
                    )

                  ),
                  const SizedBox(height: 16),
                  // Menu Grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredMenus.length,
                        itemBuilder: (context, index) {
                          final menu = filteredMenus[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            color: const Color(0xFFF5F5DC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        menu.fields.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
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
                                  Flexible(
                                    child: Text(
                                      menu.fields.menu,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Playfair Display',
                                        color: Color(0xFF3E2723),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2, // Batas maksimum 2 baris
                                      overflow: TextOverflow.ellipsis, // Elipsis jika melebihi batas
                                      softWrap: true,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Flexible(
                                    child: Text(
                                      menu.fields.restaurantName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF3E2723),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2, // Batas maksimum 2 baris
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReviewEntryFormPage(menu: menu),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFFF7B32B),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      minimumSize: const Size(double.infinity, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Tambah Review',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),


                ],
              ),
            ),
    );
  }
}
