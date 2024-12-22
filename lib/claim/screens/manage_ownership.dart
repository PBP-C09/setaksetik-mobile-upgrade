import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

Future<List<Map<String, dynamic>>> fetchClaimedRestaurants(CookieRequest request) async {
  try {
    final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/claim/manage_flutter/');
    if (response != null && response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['claimed_restaurants']);
    }
    print('Failed to fetch claimed restaurants: ${response['message']}');
    return [];
  } catch (e) {
    print('Error fetching claimed restaurants: $e');
    return [];
  }
}

Future<bool> revokeOwnership(CookieRequest request, int menuId) async {
  try {
    final response = await request.post('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/claim/revoke_flutter/', {
      'menu_id': menuId.toString(),
    });
    if (response['status'] == 'success') {
      return true;
    }
    print('Failed to revoke ownership: ${response['message']}');
    return false;
  } catch (e) {
    print('Error revoking ownership: $e');
    return false;
  }
}

class ManageOwnershipPage extends StatefulWidget {
  const ManageOwnershipPage({super.key});

  @override
  State<ManageOwnershipPage> createState() => _ManageOwnershipPageState();
}

class _ManageOwnershipPageState extends State<ManageOwnershipPage> {
  late Future<List<Map<String, dynamic>>> _futureClaimedRestaurants;

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _futureClaimedRestaurants = fetchClaimedRestaurants(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Ownership',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: LeftDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF6D4C41),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureClaimedRestaurants,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF5F5DC),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error occurred: ${snapshot.error}',
                  style: const TextStyle(
                    color: Color(0xFFF5F5DC),
                    fontSize: 18,
                    fontFamily: 'Playfair Display',
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No claimed restaurants found!",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFF5F5DC),
                    fontFamily: 'Playfair Display',
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final claimedRestaurants = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: claimedRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = claimedRestaurants[index];
                return Card(
                  elevation: 8,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF5F5DC), Color(0xFFF5F5DC)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3E2723).withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6D4C41).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3E2723),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant,
                                    color: Color(0xFFF5F5DC),
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${restaurant['restaurant_name']}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF3E2723),
                                          fontFamily: 'Playfair Display',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6D4C41).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              size: 18,
                                              color: Color(0xFF6D4C41),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${restaurant['claimed_by']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF6D4C41),
                                                fontWeight: FontWeight.w500,
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
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final request = Provider.of<CookieRequest>(context, listen: false);
                                final success = await revokeOwnership(request, restaurant['id']);
                                if (success) {
                                  setState(() {
                                    claimedRestaurants.removeAt(index);
                                  });
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        backgroundColor: const Color(0xFF3E2723),
                                        content: const Text(
                                          "Ownership revoked successfully",
                                          style: TextStyle(color: Color(0xFFF5F5DC)),
                                        ),
                                      ),
                                    );
                                } else {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        backgroundColor: const Color(0xFF842323),
                                        content: const Text(
                                          "Failed to revoke ownership",
                                          style: TextStyle(color: Color(0xFFF5F5DC)),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                }
                              },
                              icon: const Icon(Icons.delete_forever, size: 24, color: Color(0xFFF5F5DC)),
                              label: const Text(
                                'Revoke Ownership',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF842323),
                                foregroundColor: const Color(0xFFF5F5DC),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}