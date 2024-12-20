import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/main.dart';
import 'package:setaksetikmobile/screens/home.dart';

class OwnedRestaurantPage extends StatefulWidget {
  const OwnedRestaurantPage({super.key});

  @override
  State<OwnedRestaurantPage> createState() => _OwnedRestaurantPageState();
}

Future<bool> deleteOwnership(CookieRequest request, int restaurantId) async {
  try {
    final response = await request.post(
      'http://127.0.0.1:8000/claim/delete_flutter/$restaurantId/',
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
      final response = await request.get('http://127.0.0.1:8000/claim/owned_flutter/');

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
      ),
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
                          'Owned Restaurant',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F4E37),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'You are the proud owner of this restaurant!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF6F4E37),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menu.fields.restaurantName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Category: ${menu.fields.category}'),
                              Text('City: ${menu.fields.city.name}'),
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
                                                HomePage(fullName:UserProfile.data["full_name"]),
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
                                    backgroundColor: const Color(0xFFFF0000), // Warna merah untuk tombol
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Delete Ownership',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
