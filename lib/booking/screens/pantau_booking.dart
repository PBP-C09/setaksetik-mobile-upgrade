import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/booking/models/booking_entry.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

Future<Map<String, dynamic>?> fetchBookings(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/booking/pantau_flutter/');
    if (response != null && response['status'] == 'success') {
      return response;
    }
    print('Failed to fetch bookings: ${response['message']}');
    return null;
  } catch (e) {
    print('Error fetching bookings: $e');
    return null;
  }
}

Future<bool> approveBooking(CookieRequest request, int bookingId) async {
  try {
    final response = await request.post(
      'http://127.0.0.1:8000/booking/approve_flutter/$bookingId/',
      {}, // Kirim data kosong jika tidak diperlukan
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
        title: const Text('Pantau Booking'),
        centerTitle: true,
      ),
      drawer: LeftDrawer(),
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
            return const Center(child: Text('No bookings available yet!', style: TextStyle(color: Color(0xFFF5F5DC)),));
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
            return const Center(child: Text('No bookings available yet!', style: TextStyle(color: Color(0xFFF5F5DC)),));
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
                            onPressed: () async {
                              final request = Provider.of<CookieRequest>(context, listen: false);
                              final success = await approveBooking(request, booking.id);
                              if (success) {
                                setState(() {
                                  booking.status = 'approved';
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to approve booking')),
                                );
                              }
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
