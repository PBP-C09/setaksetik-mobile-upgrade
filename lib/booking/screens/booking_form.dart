import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookingFormPage extends StatefulWidget {
  final int menuId;

  const BookingFormPage({required this.menuId, Key? key}) : super(key: key);

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();

  Future<void> _submitBooking() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final data = {
      'booking_date': _dateController.text,
      'number_of_people': int.tryParse(_peopleController.text) ?? 0, // Handle invalid numbers
    };

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/booking/booking_form/${widget.menuId}/',
        data,
      );

      if (response != null && response['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])), // Show success message from API
        );
        Navigator.pop(context); // Go back after successful booking
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit booking. Please try again.')),
        );
      }
    } catch (e) {
      print('Error submitting booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Form')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Booking Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a booking date' : null,
              ),
              TextFormField(
                controller: _peopleController,
                decoration:
                    const InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter number of people' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitBooking();
                  }
                },
                child: const Text('Submit Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
