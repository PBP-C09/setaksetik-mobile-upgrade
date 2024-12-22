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
      final response = await request.get('http://127.0.0.1:8000/explore/get_menu/');
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

  void sortMenus(bool ascending) {
    setState(() {
      filteredMenus.sort((a, b) => ascending
          ? a.fields.menu.toLowerCase().compareTo(b.fields.menu.toLowerCase())
          : b.fields.menu.toLowerCase().compareTo(a.fields.menu.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Menu to Review'),
        centerTitle: true,
      ),
      body: menus.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar and Filter Buttons
                  Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5DC),
                            borderRadius: BorderRadius.circular(30),
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
                                color: Color(0xFF8D6E63),
                              ),
                              prefixIcon: const Icon(Icons.search, color: Color(0xFF8D6E63)),
                              filled: true,
                              fillColor: const Color(0xFFF5F5DC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Filter Buttons
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => sortMenus(true),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: const Color(0xFFF7B32B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('A to Z'),
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () => sortMenus(false),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF8D6E63),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Z to A'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Menu Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7, // Adjusted for better card proportions
                      ),
                      itemCount: filteredMenus.length,
                      itemBuilder: (context, index) {
                        final menu = filteredMenus[index];
                        return Card(
                          elevation: 4,
                          color: const Color(0xFFF5F5DC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Image Container with fixed height
                              SizedBox(
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)
                                  ),
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
                              // Content Container
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Text content
                                      Column(
                                        children: [
                                          Text(
                                            menu.fields.menu,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Playfair Display',
                                              color: Color(0xFF3E2723),
                                              height: 1.2,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            menu.fields.restaurantName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF3E2723),
                                              height: 1.2,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      // Button at the bottom
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
                                          minimumSize: const Size(double.infinity, 36),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Add Review',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
