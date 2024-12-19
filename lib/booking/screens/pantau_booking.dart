import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/booking/models/booking_entry.dart';

Future<Map<String, dynamic>?> fetchBookings(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/booking/pantau_flutter/');
    if (response != null && response['status'] == 'success') {
      print("ayam");
      return response;
    }
    print('Failed to fetch bookings: ${response['message']}');
    return null;
  } catch (e) {
    print('Error fetching bookings: $e');
    return null;
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
      appBar: AppBar(
        title: const Text('Pantau Booking Owner'),
      ),
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
            return const Center(child: Text('No bookings available.'));
          }

          final restaurant = snapshot.data!['restaurant'];
          final bookings = snapshot.data!.containsKey('bookings')
              ? (snapshot.data!['bookings'] as List)
                  .map((booking) => BookingEntry.fromJson(booking))
                  .toList()
              : [];

          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings available.'));
          }

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Owned Restaurant: ${restaurant['restaurant_name']} - ${restaurant['city']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...bookings.map((booking) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('User ID: ${booking.fields.user}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Menu ID: ${booking.menu}'),
                        Text('Date: ${booking.fields.bookingDate}'),
                        Text('People: ${booking.fields.numberOfPeople}'),
                        Text('Status: ${booking.fields.status}'),
                      ],
                    ),
                    trailing: booking.fields.status == 'waiting'
                        ? ElevatedButton(
                            onPressed: () {
                              // Tidak ada logika approve di sini, hanya tampilan tombol
                              print('Tombol approve diklik untuk booking ID ${booking.pk}');
                            },
                            child: const Text('Approve'),
                          )
                        : const Text('Approved'),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
