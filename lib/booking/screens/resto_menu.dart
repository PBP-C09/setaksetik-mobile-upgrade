import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class RestoMenuPage extends StatefulWidget {
  final int menuId;

  const RestoMenuPage({Key? key, required this.menuId}) : super(key: key);

  @override
  _RestoMenuPageState createState() => _RestoMenuPageState();
}

class _RestoMenuPageState extends State<RestoMenuPage> {
  Future<List<MenuList>> fetchMenus() async {
    final response = await http.get(

      Uri.parse('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/booking/resto_menu_flutter/${widget.menuId}/'),

    );

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      
      if (decodedResponse is Map) {
        List<dynamic> jsonResponse = decodedResponse['menus'] ?? [];
        return jsonResponse.map((data) => MenuList.fromJson(data)).toList();
      } else if (decodedResponse is List) {
        return decodedResponse.map((data) => MenuList.fromJson(data)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load menus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Color(0xFF3E2723),
          onPressed: () => Navigator.pop(context),
        ),
        title: FutureBuilder<List<MenuList>>(
          future: fetchMenus(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Text(snapshot.data![0].fields.restaurantName);
            }
            return const Text('Restaurant Menu');
          },
        ),
        backgroundColor: const Color(0xFFF5F5DC),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF3E2723),
      body: FutureBuilder<List<MenuList>>(
        future: fetchMenus(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final menu = snapshot.data![index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: const Color(0xFFF5F5DC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:5,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                          child: Image.network(
                            menu.fields.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image, size: 50),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menu.fields.menu,
                                style: const TextStyle(
                                  fontFamily: 'Playfair Display',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_offer_outlined,
                                    size: 20,
                                    color: Color(0xFF3E2723),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    menu.fields.category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF3E2723),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    size: 20,
                                    color: Color(0xFF3E2723),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Rp ${menu.fields.price}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF3E2723),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_outline,
                                    size: 20,
                                    color: Color(0xFF3E2723),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${menu.fields.rating} / 5',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF3E2723),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),                   ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}