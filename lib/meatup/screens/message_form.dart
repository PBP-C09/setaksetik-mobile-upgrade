import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class MessageFormPage extends StatefulWidget {
  final Map<String, dynamic>? messageToEdit; // Add this to handle editing
  const MessageFormPage({super.key, this.messageToEdit});

  @override
  MessageFormPageState createState() => MessageFormPageState();
}

class MessageFormPageState extends State<MessageFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String? selectedReceiver;
  bool _isSubmitting = false;
  List<Map<String, String>> receiverList = [
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Bob Johnson'},
  ]; // Hardcoded receivers for now

  @override
  void initState() {
    super.initState();
    // If editing, populate the form with existing message data
    if (widget.messageToEdit != null) {
      titleController.text = widget.messageToEdit!['title'];
      contentController.text = widget.messageToEdit!['content'];
      selectedReceiver = widget.messageToEdit!['receiver'].toString();
    }
  }

  Future<void> _submitMessage() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _isSubmitting = true;
  });

  final request = context.read<CookieRequest>();

  try {
    // Using the exact URLs from your original code
    final url = widget.messageToEdit != null 
        ? "http://127.0.0.1:8000/meatup/edit-flutter/${widget.messageToEdit!['id']}/"
        : "http://127.0.0.1:8000/meatup/create-flutter/";  // This matches your original URL

    // Debug print to verify the URL and data
    print("Sending request to: $url");
    print("Data being sent: {" +
        "'receiver': $selectedReceiver, " +
        "'title': ${titleController.text.trim()}, " +
        "'content': ${contentController.text.trim()}" +
        "}");

    final response = await request.postJson(
      url,
      jsonEncode({
        'receiver': selectedReceiver,
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
      }),
    );

    print("Response received: $response"); // Debug print to see response

    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.messageToEdit != null 
                ? "Message updated successfully!"
                : "Message sent successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Operation failed."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    print("Error occurred: $e"); // Detailed error logging
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: Text(
          widget.messageToEdit != null ? 'Edit Message' : 'New Message',
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            color: Color(0xFFF5F5DC),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF5F5DC)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5DC),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.messageToEdit == null) ...[
                        DropdownButtonFormField<String>(
                          value: selectedReceiver,
                          onChanged: (value) {
                            setState(() {
                              selectedReceiver = value;
                            });
                          },
                          items: receiverList
                              .map((receiver) => DropdownMenuItem<String>(
                                    value: receiver['id'],
                                    child: Text(receiver['name']!),
                                  ))
                              .toList(),
                          decoration: _inputDecoration('Select Receiver'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a receiver';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      TextFormField(
                        controller: titleController,
                        decoration: _inputDecoration('Message Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter message title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: contentController,
                        decoration: _inputDecoration('Message Content'),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter message content';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[500],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: _isSubmitting ? null : _submitMessage,
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF6D4C41),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : Text(
                                    widget.messageToEdit != null ? 'Update' : 'Send',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6D4C41)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6D4C41)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6D4C41), width: 2),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}