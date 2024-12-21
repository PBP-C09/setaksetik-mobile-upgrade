import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/main.dart';
import 'package:setaksetikmobile/screens/root_page.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

class OwnedRestaurantPage extends StatefulWidget {
  const OwnedRestaurantPage({super.key});

  @override
  State<OwnedRestaurantPage> createState() => _OwnedRestaurantPageState();
}

Future<bool> deleteOwnership(CookieRequest request, int restaurantId) async {
  try {
    final response = await request.post(
      'https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/claim/delete_flutter/$restaurantId/',
      {}, // Tambahkan parameter data kosong
    );

    if (response['status'] == 'success') {
      return true; // Berhasil menghapus ownership
    } else {
      print('Error: ${response['message']}');
      return false;
    }
  } catch (e) {
    print('Error deleting ownership: $e');
    return false; // Gagal menghapus ownership
  }
}

class _OwnedRestaurantPageState extends State<OwnedRestaurantPage> {
  Future<MenuList?> fetchOwnedRestaurant(CookieRequest request) async {
    try {
      final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/claim/owned_flutter/');

      if (response == null || response['status'] == 'failed') {
        return null;
      }

      return MenuList.fromJson(response);
    } catch (e) {
      print('Error fetching owned restaurant: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owned Restaurant'),
        centerTitle: true,
      ),
      drawer: LeftDrawer(),
      body: FutureBuilder<MenuList?>(
        future: fetchOwnedRestaurant(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading owned restaurant.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('You do not own any restaurant.'));
          } else {
            final menu = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'You are the One True Owner of',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF5F5DC),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            menu.fields.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png",
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                menu.fields.restaurantName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Playfair Display',
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Category: ${menu.fields.category}'),
                              const SizedBox(height: 8),
                              Text('City: ${menu.fields.city.name}'),
                              const SizedBox(height: 8),
                              Text('Rating: ${menu.fields.rating}'),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final success = await deleteOwnership(request, menu.pk);
                                    if (success) {
                                      UserProfile.data["claim"] = 0;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Ownership deleted successfully.'),
                                        ),
                                      );
                                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RootPage(fullName:UserProfile.data["full_name"]),
                                      ));
                                      setState(() {}); // Refresh halaman
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Failed to delete ownership.'),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF842323), // Warna merah untuk tombol
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Disown Restaurant',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Playfair Display',
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFFF5F5DC) 
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
