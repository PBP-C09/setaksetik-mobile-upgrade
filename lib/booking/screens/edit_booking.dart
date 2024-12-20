import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditBookingPage extends StatefulWidget {
  final int bookingId;

  const EditBookingPage({required this.bookingId, Key? key}) : super(key: key);

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();

  Future<void> _submitEdit() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final data = {
      'booking_date': _dateController.text, 
      'number_of_people': _peopleController.text, 
    };

    try {
      final response = await request.postJson(
        'http://127.0.0.1:8000/booking/edit_flutter/${widget.bookingId}/',
        jsonEncode(data),
      );

      if (response != null && response['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])), 
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to edit booking. Please try again.')),
        );
      }
    } catch (e) {
      print('Error editing booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Booking'),
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
              ),
              TextFormField(
                controller: _peopleController,
                decoration: const InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitEdit();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}
