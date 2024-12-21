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
      {}, // Empty payload
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
                style: TextStyle(fontSize: 18),
              ),
            );
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
            return const Center(
              child: Text(
                'No bookings available yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Owned Restaurant:',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$restaurantName - $city',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person, color: Colors.blue, size: 20),
                                const SizedBox(width: 8),
                                Text('User: ${booking.user}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.restaurant_menu, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Text('Menu: ${booking.menu}', style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.date_range, color: Colors.orange, size: 20),
                                const SizedBox(width: 8),
                                Text('Date: ${booking.bookingDate}', style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.group, color: Colors.purple, size: 20),
                                const SizedBox(width: 8),
                                Text('People: ${booking.numberOfPeople}', style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: booking.status == 'waiting'
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        final request = Provider.of<CookieRequest>(context, listen: false);
                                        final success = await approveBooking(request, booking.id);
                                        if (success) {
                                          setState(() {
                                            booking.status = 'approved';
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Booking approved successfully!')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Failed to approve booking')),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Approve'),
                                    )
                                  : const Text(
                                      'Approved',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                            ),
                          ],
                        ),
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
