import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'edit_booking.dart'; // Import halaman edit_booking

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
      final response = await request.get('http://127.0.0.1:8000/booking/json/all/');
      
      // Debug the response
      print('Response received: $response');

      if (response == null || response.isEmpty) {
        return [];
      }

      // Ensure we're getting JSON data
      if (response is! List && response is! Map) {
        throw FormatException('Invalid response format: Expected JSON but got ${response.runtimeType}');
      }

      return response.map((item) {
        final fields = item['fields'];
        return {
          'id': item['pk'],
          'booking_date': fields['booking_date'],
          'number_of_people': fields['number_of_people'],
          'menu_items': fields['menu_items'],
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
      // Gunakan string interpolasi untuk memasukkan bookingId ke URL
      final url = 'http://127.0.0.1:8000/booking/delete_flutter/$bookingId/';
      await request.post(
        url,
        {}, // Empty body
      );

      // Refresh daftar booking setelah berhasil dihapus
      setState(() {
        _bookingsFuture = fetchBookings(request);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete booking.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Bookings')),
      body: FutureBuilder<List<dynamic>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors such as not logged in or server issues
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show message when there are no bookings
            return const Center(
              child: Text('No bookings found. Please log in or add a booking.'),
            );
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Date: ${booking['booking_date']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('People: ${booking['number_of_people']}'),
                      Text('Status: ${booking['status']}'),
                      Text('Menu ID: ${booking['menu_items']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookingPage(bookingId: booking['id']),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteBooking(booking['id']),
                      ),
                    ],
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
