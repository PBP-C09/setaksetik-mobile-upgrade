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
    final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');

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
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: const Text('Book a Restaurant'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<MenuList>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading menus.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildSearchAndFilterSection(),
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.sentiment_dissatisfied,
                    size: 80,
                    color: Color(0xFFF5F5DC),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No menus available.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFF5F5DC),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final menus = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menus.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildSearchAndFilterSection();
                } else {
                  final menu = menus[index - 1];
                  return _buildMenuCard(menu);
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      color: const Color(0xFF3E2723),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 42,
                  fontFamily: 'Playfair Display',
                  color: Color(0xFFF5F5DC),
                ),
                children: const [
                  TextSpan(text: 'Book a '),
                  TextSpan(
                    text: 'Restaurant',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
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
                    decoration: InputDecoration(
                      hintText: 'Search menu or restaurant',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _menuFuture = Future.value(_originalMenus);
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _menuFuture = Future.value(_originalMenus.where((menu) {
                          return (menu.fields.menu.toLowerCase().contains(value.toLowerCase()) ||
                              menu.fields.restaurantName.toLowerCase().contains(value.toLowerCase()));
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

                                return isCityMatch && isTakeaway && isDelivery && isOutdoor && isWifi;
                              }).toList());
                            });
                          },
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.tune, color: Colors.black),
                  label: const Text(
                    'Filter',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Add spacing between filter and button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingListPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D4C41),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Your Bookings',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(MenuList menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingFormPage(menuId: menu.pk, restaurantName: menu.fields.restaurantName),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: const Color(0xFFF5F5DC),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 2.0,
              child: SizedBox(
                width: double.infinity,
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
                      fontFamily: 'Playfair Display',
                      color: Color(0xFF3E2723),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant,
                        size: 16,
                        color: Color(0xFF3E2723),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${menu.fields.menu}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Color(0xFF3E2723),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${menu.fields.city.name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF3E2723),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Color(0xFF3E2723),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${menu.fields.rating} / 5',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        size: 16,
                        color: Color(0xFF3E2723),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp ${menu.fields.price}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7B32B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          menu.fields.category,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingFormPage(menuId: menu.pk, restaurantName: menu.fields.restaurantName),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D4C41),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
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
    );
  }
}