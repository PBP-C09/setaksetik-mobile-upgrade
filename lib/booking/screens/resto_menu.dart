import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:setaksetikmobile/booking/screens/booking_detail.dart';
import 'dart:convert';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class RestoMenuPage extends StatelessWidget {
  final int menuId;

  const RestoMenuPage({Key? key, required this.menuId}) : super(key: key);

  Future<RestoMenuResponse> fetchRestoMenu() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/booking/resto_menu_flutter/$menuId/'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return RestoMenuResponse.fromJson(jsonData);
    } else {
      print("ayam");
      throw Exception('Failed to load restaurant menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
        backgroundColor: const Color(0xFF795548),
      ),
      backgroundColor: const Color(0xFF6D4C41),
      body: FutureBuilder<RestoMenuResponse>(
        future: fetchRestoMenu(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      snapshot.data!.restaurantName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: snapshot.data!.menus.length,
                      itemBuilder: (context, index) {
                        final menu = snapshot.data!.menus[index];
                        return Card(
                          color: const Color(0xFFF5F5DC),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                                child: Image.network(
                                  menu.fields.image,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menu.fields.menu,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Category: ${menu.fields.category}'),
                                    Text('Price: Rp.${menu.fields.price}'),
                                    Text('Rating: ${menu.fields.rating}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}', style: const TextStyle(color: Colors.white)),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}