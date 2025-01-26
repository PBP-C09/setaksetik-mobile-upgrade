import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/booking/screens/pantau_booking.dart';
import 'package:setaksetikmobile/claim/screens/add_menu_owner.dart';
import 'package:setaksetikmobile/claim/screens/edit_owner.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/explore/screens/admin_detail.dart';
import 'package:setaksetikmobile/main.dart';
import 'package:setaksetikmobile/main/screens/root_page.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

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
  Future<List<MenuList>?> _ownedRestaurantFuture = Future.value(null);

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    final request = Provider.of<CookieRequest>(context, listen: false);
    setState(() {
      _ownedRestaurantFuture = fetchOwnedRestaurant(request);
    });
  }
  Future<List<MenuList>?> fetchOwnedRestaurant(CookieRequest request) async {    
    try {
      final response = await request.get('http://127.0.0.1:8000/claim/owned_flutter/');

      if (response == null || response['status'] == 'failed') {
        return null;
      }

      if (response['status'] == 'success') {
        // Parse list menu dari response
        List<MenuList> menus = (response['menus'] as List)
            .map((menu) => MenuList.fromJson(menu))
            .toList();
        return menus;
      }
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
      body: FutureBuilder<List<MenuList>?>(
        future: _ownedRestaurantFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading owned restaurant.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('You do not own any restaurant.'));
          } else {
            final menus = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                  child: OwnershipCard(
                  ownerName: UserProfile.data["full_name"],
                  restaurantName: menus[0].fields.restaurantName,
                  onDisown: () async {
                    final success = await deleteOwnership(request, menus[0].pk);
                    if (success) {
                      UserProfile.data["claim"] = 0;
                      ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                            backgroundColor: Color(0xFF3E2723),
                            content:
                                Text("Restaurant disowned!")),
                      );
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RootPage(fullName: UserProfile.data["full_name"]),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to delete ownership.')),
                      );
                    }
                  },
                  onSeeBookings: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantauBookingPage(),
                      ),
                    );
                  },
                ),
                ),

                const SizedBox(height: 48),
                Center(
                  child: Text(
                    'Restaurant Menu',
                    style: TextStyle(
                      color: const Color(0xFFF5F5DC),
                      fontSize: 30,
                      fontFamily: 'Playfair Display',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Tombol Add Menu
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddMenuOwner()),
                        );
                        
                        if (result == true) {
                          _refreshData(); // Refresh data when new menu is added
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF842323),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add Menu',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                  const SizedBox(height: 24),
                  // Menu List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: menus.length,
                    itemBuilder: (context, index) {
                      final menu = menus[index];
                      return Card(
                        elevation: 4,
                        // margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.zero,
                                    bottomRight: Radius.zero,
                                  ),
                                  child: Image.network(
                                    menu.fields.image,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Tampilkan placeholder image jika gagal memuat gambar
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
                                    }
                                  ),
                                ),
                                // Edit and Delete Buttons
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFD54F),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.white),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditMenuOwnerPage(menuToEdit: menu),
                                              ),
                                            ).then((_) => _refreshData());
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF842323),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.white),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Delete Menu'),
                                                  content: const Text('Are you sure you want to delete this menu?'),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('Cancel'),
                                                      onPressed: () => Navigator.of(context).pop(),
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(color: Color(0xFF842323)),
                                                      ),
                                                      onPressed: () async {
                                                         await _deleteMenu(request, menu.pk);
                                                         setState(() {
                                                          _refreshData();
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                  child: Text(
                                    menu.fields.menu,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Playfair Display',
                                      fontStyle: FontStyle.italic
                                    ),
                                  ),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                  child: Text('Category: ${menu.fields.category}'),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                  child: Text('Price: ${menu.fields.price}'),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                  child: Text('Rating: ${menu.fields.rating}'),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AdminDetail(menuList: menu),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6D4C41),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Details',
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
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }


  // Fungsi untuk menghapus menu
  Future<void> _deleteMenu(CookieRequest request, int pk) async {
    try{
    await request.get('http://127.0.0.1:8000/explore/delete/$pk');
    } catch (e) {
    }
  }
}

class OwnershipCard extends StatelessWidget {
  final String ownerName;
  final String restaurantName;
  final VoidCallback onDisown;
  final VoidCallback onSeeBookings;

  const OwnershipCard({
    Key? key,
    required this.ownerName,
    required this.restaurantName,
    required this.onDisown,
    required this.onSeeBookings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.95, end: 1.0),
          duration: const Duration(milliseconds: 300),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5DC), // Beige background
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E2723), // Brown background
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Card of Ownership',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF5F5DC), // Beige text
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                
                // Body part wrapped in Container
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Verified Owner Section
                      _buildSection(
                        title: 'Verified Owner',
                        content: ownerName,
                      ),
                      const SizedBox(height: 20),

                      // Restaurant Section
                      _buildSection(
                        title: 'Restaurant',
                        content: restaurantName,
                      ),
                      const SizedBox(height: 30),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                              label: 'View Bookings',
                              color: const Color(0xFFFFD54F), // Yellow background
                              textColor: const Color(0xFF3E2723), // Brown text
                              onPressed: onSeeBookings,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildButton(
                              label: 'Disown',
                              color: const Color(0xFF842323), // Red background
                              textColor: const Color(0xFFF5F5DC), // Beige text
                              onPressed: onDisown,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6D4C41), // Lighter brown text
            fontSize: 14,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(
            color: Color(0xFF3E2723), // Brown text
            fontSize: 24,
            fontFamily: 'Playfair Display',
            fontStyle: FontStyle.italic,
          ),
        ),
        Divider(
          color: const Color(0xFF3E2723), // Brown line
          thickness: 2,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontFamily: 'Playfair Display',
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

}