import 'package:flutter/material.dart';
import 'package:setaksetikmobile/claim/screens/owned_restaurant.dart';
import 'package:setaksetikmobile/main.dart';
import 'package:setaksetikmobile/screens/root_page.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

Future<List<MenuList>> fetchClaimResto(CookieRequest request) async {
  try {
    final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/claim/json/');

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
    'https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/claim/claim_flutter/$menuId/',
    {},
  );

  if (response['status'] == 'success') {
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Color(0xFF3E2723),
        content:
        Text("Successfully claimed the restaurant!", style: TextStyle(color: Color(0xFFF5F5DC)),)),
        );
    UserProfile.data["claim"] = 1;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => RootPage(fullName: UserProfile.data["full_name"],),
      ),
      (Route<dynamic> route) => false,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OwnedRestaurantPage(),
      ),
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
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  Text(
                    'Find a restaurant to claim and become its owner!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFF5F5DC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3E2723),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search restaurant',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFF5F5DC),),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    hintStyle: TextStyle(color: Colors.grey[100]),
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

            const SizedBox(height: 16),

            FutureBuilder<List<MenuList>>(
              future: _claimFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error loading restaurants: ${snapshot.error}',
                        style: const TextStyle(color: Color(0xFF842323)),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No restaurants available for claim.'),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (snapshot.data!.length / 2).ceil(),
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RestaurantCard(
                                  menu: snapshot.data![index * 2],
                                  onClaim: () async {
                                    final request = Provider.of<CookieRequest>(context, listen: false);
                                    await claimRestaurant(context, request, snapshot.data![index * 2].pk);
                                    setState(() {
                                      _claimFuture = fetchClaimResto(request);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (index * 2 + 1 < snapshot.data!.length)
                                Expanded(
                                  child: RestaurantCard(
                                    menu: snapshot.data![index * 2 + 1],
                                    onClaim: () async {
                                      final request = Provider.of<CookieRequest>(context, listen: false);
                                      await claimRestaurant(context, request, snapshot.data![index * 2 + 1].pk);
                                      setState(() {
                                        _claimFuture = fetchClaimResto(request);
                                      });
                                    },
                                  ),
                                )
                              else
                                Expanded(child: Container()),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
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
                    menu.fields.restaurantName,
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
            
            // Claim Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ElevatedButton(
                onPressed: onClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Claim',
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