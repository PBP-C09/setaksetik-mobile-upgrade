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
        title: const Text('Manage Ownership'),
        centerTitle: true,
      ),
      drawer: LeftDrawer(),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF6D4C41),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureClaimedRestaurants,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error occurred: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No claimed restaurants found.'));
            }

            final claimedRestaurants = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: claimedRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = claimedRestaurants[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.grey.shade50],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.restaurant, 
                                color: Colors.grey[700],
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${restaurant['restaurant_name']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.person,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Owner: ${restaurant['claimed_by']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final request = Provider.of<CookieRequest>(context, listen: false);
                                final success = await revokeOwnership(request, restaurant['id']);
                                if (success) {
                                  setState(() {
                                    claimedRestaurants.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Ownership revoked successfully')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to revoke ownership')),
                                  );
                                }
                              },
                              label: const Text('Revoke Ownership',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF842323),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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