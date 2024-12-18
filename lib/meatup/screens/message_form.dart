import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class MessageFormPage extends StatefulWidget {
  const MessageFormPage({super.key});

  @override
  MessageFormPageState createState() => MessageFormPageState();
}

class MessageFormPageState extends State<MessageFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: const Text(
          'Meat Up',
          style: TextStyle(
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
          child: Column(
            children: [
              const Text(
                'Mau meat up sama siapa?',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 32,
                  color: Color(0xFFF5F5DC),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormField(
                        controller: receiverController,
                        label: 'Receiver Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter receiver name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        controller: titleController,
                        label: 'Message Title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter message title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        controller: contentController,
                        label: 'Message Content',
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
                              backgroundColor: _isSubmitting ? Colors.grey[300] : Colors.grey[500],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Playfair Display',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: _isSubmitting ? null : _submitMessage,
                            style: TextButton.styleFrom(
                              backgroundColor: _isSubmitting ? Colors.grey[300] : const Color(0xFF6D4C41),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: _isSubmitting 
                              ? const SizedBox(
                                  width: 20, 
                                  height: 20, 
                                  child: CircularProgressIndicator(color: Colors.white)
                                )
                              : const Text(
                                  'Send',
                                  style: TextStyle(
                                    fontFamily: 'Playfair Display',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            color: Color(0xFF6D4C41),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            color: Color(0xFF6D4C41),
          ),
          validator: validator,
        ),
      ],
    );
  }

  

  Future<void> _submitMessage() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isSubmitting = true);

  final request = context.read<CookieRequest>();
  
  try {
    final response = await request.post(
      'http://127.0.0.1:8000/meatup/create/',
      {
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
        'receiver': receiverController.text.trim(),
      },
    );

    // More robust response handling
    dynamic parsedResponse;
    try {
      // Check if response is already a map (pbp_django_auth might do this)
      if (response is Map) {
        parsedResponse = response;
      } else if (response is String) {
        // Try parsing as JSON, with extra checks
        if (response.trim().toLowerCase().startsWith('<!doctype') || 
            response.trim().toLowerCase().startsWith('<html')) {
          throw Exception('Received HTML instead of JSON');
        }
        parsedResponse = jsonDecode(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      debugPrint('Response parsing error: $e');
      _showSnackBar('Error processing server response', isError: true);
      return;
    }

    // Check response status
    if (parsedResponse['status'] == 'success') {
      if (mounted) {
        _showSnackBar('Message sent successfully!', isError: false);
        Navigator.pop(context);
      }
    } else {
      final errorMessage = parsedResponse['message'] ?? 'Unknown error occurred';
      _showSnackBar('Failed to send message: $errorMessage', isError: true);
    }
  } catch (e) {
    debugPrint('Submission error: $e');
    
    String errorMessage = 'Error sending message';
    
    // More specific error handling
    if (e.toString().contains('SocketException')) {
      errorMessage = 'Cannot connect to server. Check your connection.';
    } else if (e.toString().contains('HTML')) {
      errorMessage = 'Server returned an unexpected response. Check server logs.';
    }
    
    if (mounted) {
      _showSnackBar(errorMessage, isError: true);
    }
  } finally {
    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }
}

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    receiverController.dispose();
    super.dispose();
  }
}