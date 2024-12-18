import 'package:flutter/material.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/booking/screens/booking_form.dart';
import 'package:setaksetikmobile/booking/screens/list_booking.dart';

// Add the fetchMenu function here
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

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _menuFuture = fetchMenu(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Restaurant'),
      ),
      drawer: LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const Center(
              child: Column(
                children: [
                  Text(
                    'Book a Restaurant',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6F4E37), // brown color
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Choose your favorite restaurant and make your reservation now!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6F4E37), // brown color
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // "Atur Booking" Button
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Atur Booking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Menu Grid Display
            const Text(
              'Restaurant Menus',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Fetch and Display Menu Data
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
                      return RestaurantCard(menu: menu);
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

  const RestaurantCard({required this.menu, Key? key}) : super(key: key);

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
                  menu.fields.menu,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6F4E37), // brown color
                  ),
                ),
                Text('Category: ${menu.fields.category}'),
                Text('Price: Rp ${menu.fields.price}'),
                Text('City: ${menu.fields.city.name}'),
                Text('Rating: ${menu.fields.rating}'),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingFormPage(menuId: menu.pk),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107), // yellow color
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Select Restaurant'),
            ),
          ),
        ],
      ),
    );
  }
}
