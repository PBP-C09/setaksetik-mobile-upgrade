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

  /// Fetch the list of bookings from the server
  Future<List<dynamic>> fetchBookings(CookieRequest request) async {
    try {
      // First fetch the bookings
      final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/booking/json/all/');
      
      if (response == null || response.isEmpty) {
        return [];
      }

      // Then fetch all menus
      final menuResponse = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');
      final menus = menuResponse != null ? 
        menuResponse.map((item) => MenuList.fromJson(item)).toList() : 
        <MenuList>[];

      // Create a map of menu ID to menu details for faster lookup
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
      final url = 'https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/booking/delete_flutter/$bookingId/';
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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
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
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          booking['menu_image'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey,
                              child: const Icon(Icons.error),
                            );
                          },
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['restaurant_name'], // Add this line
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Playfair Display',
                              color: Color(0xFF6F4E37),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: $formattedDate',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'People: ${booking['number_of_people']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${booking['status']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: booking['status'] == 'approved'
                                  ? Color(0xFF3E2723)
                                  : Color(0xFFF5F5DC ),
                              backgroundColor: booking['status'] == 'approved'
                                  ? Color(0xFFFFD54F)
                                  : Color(0xFF842323),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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