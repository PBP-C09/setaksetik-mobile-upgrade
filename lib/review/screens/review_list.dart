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
      final response = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');
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
                              hintText: "Search menu",
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: (filteredMenus.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RestaurantCard(
                                  menu: filteredMenus[index * 2],
                                  onReview: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewEntryFormPage(menu: filteredMenus[index * 2]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (index * 2 + 1 < filteredMenus.length)
                                Expanded(
                                  child: RestaurantCard(
                                    menu: filteredMenus[index * 2 + 1],
                                    onReview: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReviewEntryFormPage(menu: filteredMenus[index * 2 + 1]),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                Expanded(child: Container()),
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

class RestaurantCard extends StatelessWidget {
  final MenuList menu;
  final VoidCallback onReview;

  const RestaurantCard({required this.menu, required this.onReview, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            
            // Restaurant Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    menu.fields.menu,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6F4E37),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    menu.fields.restaurantName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6F4E37),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.food_bank, size: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Category: ${menu.fields.category}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'City: ${menu.fields.city.name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        menu.fields.rating.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Review Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ElevatedButton(
                onPressed: onReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Review',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
