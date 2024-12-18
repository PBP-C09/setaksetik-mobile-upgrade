import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/booking/models/booking_entry.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({Key? key}) : super(key: key);

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late Future<List<dynamic>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _bookingsFuture = fetchBookings(request);
  }

  Future<List<dynamic>> fetchBookings(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/booking/show_booking_json/');

      if (response == null || response.isEmpty) {
        return [];
      }

      // Properly parse the JSON
      return response.map((item) {
        final fields = item['fields'];
        return {
          'id': item['pk'], // Get the primary key
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

  Future<void> deleteBooking(int bookingId) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    await request.post(
      'http://127.0.0.1:8000/booking/delete_booking/$bookingId/',
      {}, // Add an empty map as the second argument for the body
    );
    setState(() {
      _bookingsFuture = fetchBookings(request);
    });
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
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load bookings.'));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteBooking(booking['id']),
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
