import 'package:flutter/material.dart';
import 'package:setaksetikmobile/booking/screens/filter_widget.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/booking/screens/booking_form.dart';
import 'package:setaksetikmobile/booking/screens/list_booking.dart';

Future<List<MenuList>> fetchMenu(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/explore/get_menu/');

    if (response == null) {
      return [];
    }

    return response.map<MenuList>((menu) => MenuList.fromJson(menu)).toList();
  } catch (e) {
    print('Error fetching menu: $e');
    return [];
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late Future<List<MenuList>> _menuFuture;
  List<MenuList> _originalMenus = [];

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _menuFuture = fetchMenu(request);
    _menuFuture.then((menus) => _originalMenus = menus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Restaurant'),
        centerTitle: true,
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
                    'Book a Restaurant',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6F4E37),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Choose your favorite restaurant and make your reservation now!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6F4E37),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingListPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Atur Booking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Restaurant Menus',
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
                        hintText: 'Cari nama menu atau nama restoran',
                        hintStyle: TextStyle(fontSize: 14),
                        prefixIcon: Icon(Icons.search, size: 20),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _menuFuture = Future.value(_originalMenus.where((menu) {
                            return (menu.fields.menu.toLowerCase().contains(value.toLowerCase()) || menu.fields.restaurantName.toLowerCase().contains(value.toLowerCase()));
                          }).toList());
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        showDragHandle: true,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return FilterWidget(
                            onFilter: (filterOptions) {
                              setState(() {
                                _menuFuture = Future.value(_originalMenus.where((menu) {
                                  final hasActiveFilter = filterOptions['city'] != null ||
                                      filterOptions['takeaway'] == true ||
                                      filterOptions['delivery'] == true ||
                                      filterOptions['outdoor'] == true ||
                                      filterOptions['wifi'] == true;

                                  if (!hasActiveFilter) {
                                    return true;
                                  }

                                  final isCityMatch = filterOptions['city'] == null || 
                                      menu.fields.city.name == filterOptions['city'];
                                  final isTakeaway = filterOptions['takeaway'] == null || 
                                      filterOptions['takeaway'] == false || 
                                      menu.fields.takeaway;
                                  final isDelivery = filterOptions['delivery'] == null || 
                                      filterOptions['delivery'] == false || 
                                      menu.fields.delivery;
                                  final isOutdoor = filterOptions['outdoor'] == null || 
                                      filterOptions['outdoor'] == false || 
                                      menu.fields.outdoor;
                                  final isWifi = filterOptions['wifi'] == null || 
                                      filterOptions['wifi'] == false || 
                                      menu.fields.wifi;

                                  return isCityMatch && isTakeaway && isDelivery && 
                                      isOutdoor && isWifi;
                                }).toList());
                              });
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.filter_alt_outlined),
                    label: const Text('Filter'),
                  ),
                ),
              ],
            ),

            FutureBuilder<List<MenuList>>(
              future: _menuFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading menus.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No menus available.'));
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
                        onSelect: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingFormPage(menuId: menu.pk),
                            ),
                          );
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
  final VoidCallback onSelect;

  const RestaurantCard({required this.menu, required this.onSelect, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  menu.fields.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Placeholder images
                    List<String> placeholderImages = [
                      "assets/images/placeholder-image-1.png",
                      "assets/images/placeholder-image-2.png",
                      "assets/images/placeholder-image-3.png",
                      "assets/images/placeholder-image-4.png",
                      "assets/images/placeholder-image-5.png",
                    ];

                    // Select placeholder image based on `menu.pk`
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.fields.restaurantName,
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
                    children: [
                      const Icon(Icons.restaurant, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Menu: ${menu.fields.menu}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.food_bank, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Category: ${menu.fields.category}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'City: ${menu.fields.city.name}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        menu.fields.rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: Rp ${menu.fields.price}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            // Select Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Select Restaurant',
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
