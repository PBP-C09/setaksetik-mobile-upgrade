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
      final response = await request.get('http://127.0.0.1:8000/explore/get_menu/');
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
        title: const Text(
          'Add Review',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(),
      body: menus.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add the text above the menu list
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Ingin review menu apa?',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[700],
                        ),
                      ),
                    ),
                    // Now list the menus
                    Column(
                      children: menus.map((menu) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Image.network(menu.fields.image), // Menampilkan gambar
                            title: Text(menu.fields.restaurantName),
                            subtitle: Text(menu.fields.menu),
                            onTap: () {
                              // Navigate to the review entry page when a menu is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewEntryFormPage(menu: menu),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
