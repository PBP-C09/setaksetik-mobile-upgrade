import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>?> fetchBookings(CookieRequest request) async {
  try {
    final response = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/booking/pantau_flutter/');
    final menuResponse = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');

    if (response != null && menuResponse != null) {
      // menuResponse jadi object menu
      final menus = menuResponse.map((item) => MenuList.fromJson(item)).toList();
      
      final restaurant = response['restaurant'];
      final matchingMenu = menus.firstWhere(
        (menu) => menu.fields.restaurantName == restaurant['restaurant_name'],
        orElse: () => MenuList(pk: 0, model: Model.EXPLORE_MENU, fields: Fields(
          menu: '', category: '', restaurantName: '', image: '', 
          city: City.CENTRAL_JAKARTA, price: 0, rating: 0.0, 
          specialized: '', takeaway: false, delivery: false, 
          outdoor: false, smokingArea: false, wifi: false, claimedBy: ''
        )),
      );

      // Update data restaurant dengan image_url dari matchingMenu
      response['restaurant'] = {
        ...restaurant,
        'image_url': matchingMenu.fields.image,
      };

      return response;
    }
    return null;
  } catch (e) {
    print('Error fetching bookings: $e');
    return null;
  }
}

Future<bool> approveBooking(CookieRequest request, int bookingId) async {
  try {
    final response = await request.post(
      'https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/booking/approve_flutter/$bookingId/',
      {}, 
    );
    if (response['status'] == 'success') {
      return true;
    } else {
      print('Failed to approve booking: ${response["message"]}');
      return false;
    }
  } catch (e) {
    print('Error approving booking: $e');
    return false;
  }
}

String formatBookingDate(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(dateTime);
  } catch (e) {
    print('Error formatting date: $e');
    return 'Invalid date';
  }
}

class PantauBookingPage extends StatefulWidget {
  const PantauBookingPage({super.key});

  @override
  State<PantauBookingPage> createState() => _PantauBookingPageState();
}

class _PantauBookingPageState extends State<PantauBookingPage> {
  late Future<Map<String, dynamic>?> _futureBookings;

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _futureBookings = fetchBookings(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: const Text('Monitor Bookings'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'No bookings available yet!',
                style: TextStyle(fontSize: 20, color: Color(0xFFF5F5DC), fontFamily: "Playfair Display", fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
              ),
            );
          }

          final restaurant = snapshot.data!['restaurant'] ?? {};
          final restaurantName = restaurant['restaurant_name'] ?? 'Unknown Restaurant';
          final city = restaurant['city'] ?? 'Unknown City';

          final bookings = snapshot.data!.containsKey('bookings')
              ? (snapshot.data!['bookings'] as List)
                  .map((booking) => booking as Map<String, dynamic>)
                  .toList()
              : [];

          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                'No bookings available yet!',
                style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "Playfair Display", fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5DC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: AspectRatio(
                          aspectRatio: 2.0,
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              restaurant['image_url'] ?? 'https://via.placeholder.com/150',
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                List<String> placeholderImages = [
                                  "assets/images/placeholder-image-1.png",
                                  "assets/images/placeholder-image-2.png",
                                  "assets/images/placeholder-image-3.png",
                                  "assets/images/placeholder-image-4.png",
                                  "assets/images/placeholder-image-5.png",
                                ];

                                int index = restaurant['id'] % placeholderImages.length;

                                return Image.asset(
                                  placeholderImages[index],
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Owned Restaurant:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E2723),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$restaurantName - $city',
                              style: const TextStyle(fontSize: 16, color: Color(0xFF3E2723)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final formattedDate = formatBookingDate(booking['booking_date']);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5DC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person, color: Color(0xFF3E2723), size: 20),
                                    const SizedBox(width: 8),
                                    Text('User: ${booking['user']}',
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.date_range, color: Color(0xFF842323), size: 20),
                                    const SizedBox(width: 8),
                                    Text('Date: $formattedDate',
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.group, color: Color(0xFF6D4C41), size: 20),
                                    const SizedBox(width: 8),
                                    Text('People: ${booking['number_of_people']}',
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                booking['status'] == 'waiting'
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          final request =
                                              Provider.of<CookieRequest>(context, listen: false);
                                          final success =
                                              await approveBooking(request, booking['id']);
                                          if (success) {
                                            setState(() {
                                              booking['status'] = 'approved';
                                            });
                                            ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                  backgroundColor: Color(0xFF3E2723),
                                                  content:
                                                      Text('Booking approved successfully!')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content: Text('Failed to approve booking')),
                                            );
                                            ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                  backgroundColor: Color(0xFF3E2723),
                                                  content:
                                                      Text('Failed to approve booking')),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFFFD54F),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.w600),),
                                      )
                                    : const Text(
                                        'Approved',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFF6D4C41),
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
        },
      ),
    );
  }
}
