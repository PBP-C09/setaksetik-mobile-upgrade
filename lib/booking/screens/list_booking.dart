import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:setaksetikmobile/booking/screens/booking_home.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:provider/provider.dart';
import 'edit_booking.dart';

/// Fungsi untuk memformat tanggal
String formatBookingDate(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(dateTime);
  } catch (e) {
    print('Error formatting date: $e');
    return 'Invalid date';
  }
}

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late Future<List<dynamic>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);

    // Check if the user is logged in
    if (request.jsonData.isNotEmpty) {
      _bookingsFuture = fetchBookings(request);
    } else {
      // If user is not logged in, return an error future
      _bookingsFuture = Future.error('User not logged in.');
    }
  }

  // Fetch list bookingnya
  Future<List<dynamic>> fetchBookings(CookieRequest request) async {
    try {
      final response = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/booking/json/all/');
      
      if (response == null || response.isEmpty) {
        return [];
      }

      final menuResponse = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');
      final menus = menuResponse != null ? 
        menuResponse.map((item) => MenuList.fromJson(item)).toList() : 
        <MenuList>[];

      final menuMap = {
        for (var menu in menus) 
        menu.pk: menu
      };

      return response.map((item) {
        final fields = item['fields'];
        final menuId = fields['menu_items'];
        final menu = menuMap[menuId];
        
        return {
          'id': item['pk'],
          'booking_date': fields['booking_date'],
          'number_of_people': fields['number_of_people'],
          'menu_items': fields['menu_items'],
          'menu_image': menu?.fields.image ?? '', // Get image from menu
          'restaurant_name': menu?.fields.restaurantName ?? 'Unknown Restaurant',
          'status': fields['status'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  /// Delete a booking by ID
  Future<void> deleteBooking(int bookingId) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    try {

      final url = 'https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/booking/delete_flutter/$bookingId/';

      await request.post(
        url,
        {}, // Empty body
      );

      // Refresh daftar booking setelah berhasil dihapus
      setState(() {
        _bookingsFuture = fetchBookings(request);
      });

      ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
                backgroundColor: Color(0xFF3E2723),
                content:
                    Text('Booking deleted successfully!')),
          );
    } catch (e) {
      print('Error deleting booking: $e');
      ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
                backgroundColor: Color(0xFF3E2723),
                content:
                    Text('Failed to delete booking')),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: const Text('Your Bookings'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Color(0xFF842323)),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Text(
                            'No bookings found :O, please make a booking :D',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFF5F5DC),
                              fontFamily: 'Playfair Display',
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 166, 143, 140),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const BookingPage(),
                                    ),
                                );
                            },
                            child: const Text('Booking'),
                        ),
                    ],
                ),
            );
          }

          final bookings = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 16,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final formattedDate = formatBookingDate(booking['booking_date']);

              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFF5F5DC),
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
                            booking['menu_image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              List<String> placeholderImages = [
                                "assets/images/placeholder-image-1.png",
                                "assets/images/placeholder-image-2.png",
                                "assets/images/placeholder-image-3.png",
                                "assets/images/placeholder-image-4.png",
                                "assets/images/placeholder-image-5.png",
                              ];

                              int index = booking['id'] % placeholderImages.length;

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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['restaurant_name'],
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20, color: Color(0xFF3E2723)),
                              const SizedBox(width: 12),
                              Text(
                                formattedDate,
                                style: const TextStyle(fontSize: 14, color: Color(0xFF3E2723)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.people, size: 20, color: Color(0xFF3E2723)),
                              const SizedBox(width: 12),
                              Text(
                                '${booking['number_of_people']} people',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF3E2723)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: booking['status'] == 'waiting' 
                                      ? const Color(0xFF842323) 
                                      : const Color(0xFFFFD54F), // Conditional color
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  booking['status'],
                                  style: TextStyle(
                                    color: booking['status'] == 'waiting' 
                                      ? const Color(0xFFF5F5DC) 
                                      : const Color(0xFF3E2723),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (booking['status'] == 'waiting')
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Color(0xFF6D4C41)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditBookingPage(
                                              bookingId: booking['id'],
                                              restaurantName: booking['restaurant_name'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Color(0xFF842323)),
                                      onPressed: () => deleteBooking(booking['id']),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}