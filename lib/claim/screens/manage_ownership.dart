import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

/// Fetch all claimed restaurants
Future<List<Map<String, dynamic>>> fetchClaimedRestaurants(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/claim/manage_flutter/');
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

/// Revoke ownership of a restaurant
Future<bool> revokeOwnership(CookieRequest request, int menuId) async {
  try {
    final response = await request.post('http://127.0.0.1:8000/claim/revoke_flutter/', {
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
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
            itemCount: claimedRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = claimedRestaurants[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Restaurant: ${restaurant['restaurant_name']}'),
                  subtitle: Text('Owner: ${restaurant['claimed_by']}'),
                  trailing: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Revoke'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
