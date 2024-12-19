import 'package:flutter/material.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

Future<List<MenuList>> fetchClaimResto(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/claim/json/');

    if (response == null) {
      return [];
    }

    return response.map<MenuList>((menu) => MenuList.fromJson(menu)).toList();
  } catch (e) {
    print('Error fetching claimable restaurants: $e');
    return [];
  }
}

Future<void> claimRestaurant(BuildContext context, CookieRequest request, int menuId) async {
  final response = await request.post(
    'http://127.0.0.1:8000/claim/claim_flutter/$menuId/',
    {}, // Body kosong karena hanya perlu menu_id
  );

  if (response['status'] == 'success') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully claimed the restaurant!')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'] ?? 'Failed to claim the restaurant.')),
    );
  }
}

class ClaimPage extends StatefulWidget {
  const ClaimPage({super.key});

  @override
  State<ClaimPage> createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> {
  late Future<List<MenuList>> _claimFuture;
  List<MenuList> _originalMenus = [];

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _claimFuture = fetchClaimResto(request);
    _claimFuture.then((menus) => _originalMenus = menus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim a Restaurant'),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    'Claim a Restaurant',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6F4E37),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Find a restaurant to claim and become its owner!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6F4E37),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Available Restaurants',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search restaurant',
                        hintStyle: TextStyle(fontSize: 14),
                        prefixIcon: Icon(Icons.search, size: 20),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _claimFuture = Future.value(_originalMenus.where((menu) {
                            return menu.fields.restaurantName.toLowerCase().contains(value.toLowerCase());
                          }).toList());
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            FutureBuilder<List<MenuList>>(
              future: _claimFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading claimable restaurants.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No restaurants available for claim.'));
                } else {
                  final menus = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: menus.length,
                    itemBuilder: (context, index) {
                      final menu = menus[index];
                      return RestaurantCard(
                        menu: menu,
                        onClaim: () async {
                          final request = Provider.of<CookieRequest>(context, listen: false);
                          await claimRestaurant(context, request, menu.pk);
                          setState(() {
                            _claimFuture = fetchClaimResto(request);
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final MenuList menu;
  final VoidCallback onClaim;

  const RestaurantCard({required this.menu, required this.onClaim, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              menu.fields.image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png",
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.fields.restaurantName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6F4E37),
                  ),
                ),
                Text('Category: ${menu.fields.category}'),
                Text('City: ${menu.fields.city.name}'),
                Text('Rating: ${menu.fields.rating}'),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: onClaim,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Claim Restaurant'),
            ),
          ),
        ],
      ),
    );
  }
}
