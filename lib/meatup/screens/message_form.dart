import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class MessageFormPage extends StatefulWidget {
  final Map<String, dynamic>? messageToEdit;
  const MessageFormPage({super.key, this.messageToEdit});

  @override
  State<MessageFormPage> createState() => _MessageFormPageState();
}

class _MessageFormPageState extends State<MessageFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedReceiver;
  String _title = "";
  String _content = "";
  bool _isLoading = true;
  List<Map<String, dynamic>> receiverList = [];

  @override
  void initState() {
    super.initState();
    fetchReceivers();

    if (widget.messageToEdit != null) {
      setState(() {
        _title = widget.messageToEdit!['title'];
        _content = widget.messageToEdit!['content'];
        selectedReceiver = widget.messageToEdit!['receiver'].toString();
      });
    }
  }

  Future<void> fetchReceivers() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://127.0.0.1:8000/meatup/flutter/get-receivers/');
      if (mounted) {
        setState(() {
          receiverList = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load receivers"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
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
                            decoration: _inputDecoration("Select Receiver"),
                            items: receiverList.map((receiver) {
                              return DropdownMenuItem<String>(
                                value: receiver['username'],
                                child: Text(receiver['full_name']),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedReceiver = value!;
                              });
                            },
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
                          initialValue: _title,
                          decoration: _inputDecoration("Message Title"),
                          onChanged: (String? value) {
                            setState(() {
                              _title = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Title cannot be empty!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _content,
                          decoration: _inputDecoration("Message Content"),
                          onChanged: (String? value) {
                            setState(() {
                              _content = value!;
                            });
                          },
                          maxLines: 5,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Content cannot be empty!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Determine the URL based on whether we're editing or creating
                                  final String url = widget.messageToEdit != null
                                      ? 'http://127.0.0.1:8000/meatup/flutter/edit/${widget.messageToEdit!['id']}/'
                                      : 'http://127.0.0.1:8000/meatup/create-flutter/';

                                  final response = await request.postJson(
                                    url,
                                    jsonEncode({
                                      'receiver': selectedReceiver,
                                      'title': _title,
                                      'content': _content,
                                    }),
                                  );

                                  if (context.mounted) {
                                    if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            widget.messageToEdit != null
                                                ? "Message updated successfully!"
                                                : "Message created successfully!",
                                          ),
                                          backgroundColor: Color(0xFF3E2723),
                                        ),
                                      );
                                      Navigator.pop(context, true);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("An error occurred"),
                                          backgroundColor: Color(0xFF3E2723),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF6D4C41),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                widget.messageToEdit != null ? 'Update' : 'Send',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
}