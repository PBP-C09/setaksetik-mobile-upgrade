import 'dart:convert';

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

  /// Function to display date picker and set selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100), 
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitBooking() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final userId = request.jsonData['user_id'];

    final data = {
      'user_id': userId.toString(), 
      'booking_date': "${_dateController.text}T00:00:00", 
      'number_of_people': _peopleController.text, 
    };

    try {
      final response = await request.postJson(
        'http://127.0.0.1:8000/booking/add_flutter/${widget.menuId}/',
        jsonEncode(data),
      );

      if (response != null && response['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        Navigator.pop(context); 
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
      appBar: AppBar(
        title: const Text('Booking Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                readOnly: true, 
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Booking Date',
                  suffixIcon: Icon(Icons.calendar_today), 
                ),
                validator: (value) => value!.isEmpty ? 'Please select a booking date' : null,
              ),
              TextFormField(
                controller: _peopleController,
                decoration: const InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter number of people' : null,
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
