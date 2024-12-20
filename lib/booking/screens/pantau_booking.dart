import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/booking/models/booking_entry.dart';

Future<Map<String, dynamic>?> fetchBookings(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/booking/pantau_flutter/');
    print("Raw response data: $response"); // Debug print
    if (response != null && response['status'] == 'success') {
      print("Response received successfully");
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

          final restaurant = snapshot.data!['restaurant'] ?? {};
          final restaurantName = restaurant['restaurant_name'] ?? 'Unknown Restaurant';
          final city = restaurant['city'] ?? 'Unknown City';

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
                  'Owned Restaurant: $restaurantName - $city',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...bookings.map((booking) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('User: ${booking.user}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Menu: ${booking.menu}'),
                        Text('Date: ${booking.bookingDate.toString()}'),
                        Text('People: ${booking.numberOfPeople}'),
                        Text('Status: ${booking.status}'),
                      ],
                    ),
                    trailing: booking.status == 'waiting'
                        ? ElevatedButton(
                            onPressed: () {
                              print('Approve button clicked for booking ID ${booking.id}');
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