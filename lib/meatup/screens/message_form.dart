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
            backgroundColor: Color(0xFF3E2723),
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
          widget.messageToEdit != null ? 'Edit Meat Up Request' : 'Mau meat up sama siapa?',
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            color: Colors.white,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5DC),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.messageToEdit == null) ...[
                          const Text(
                            'Receiver',
                            style: TextStyle(
                              color: Color(0xFF3E2723),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Playfair Display',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF3E2723),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedReceiver,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              items: receiverList.map((receiver) {
                                return DropdownMenuItem<String>(
                                  value: receiver['username'],
                                  child: Text(
                                    receiver['full_name'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
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
                              dropdownColor: const Color(0xFF3E2723),
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        const Text(
                          'Title',
                          style: TextStyle(
                            color: Color(0xFF3E2723),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E2723),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            initialValue: _title,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
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
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Message',
                          style: TextStyle(
                            color: Color(0xFF3E2723),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E2723),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            initialValue: _content,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            maxLines: 5,
                            onChanged: (String? value) {
                              setState(() {
                                _content = value!;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Message cannot be empty!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String url = widget.messageToEdit != null
                                      ? 'http://127.0.0.1:8000/meatup/flutter/edit/${widget.messageToEdit!['id']}/'
                                      : 'http://127.0.0.1:8000/meatup/create-flutter/';

                                  try {
                                    final response = await request.postJson(
                                      url,
                                      jsonEncode({
                                        'receiver': selectedReceiver ?? widget.messageToEdit!['receiver'],
                                        'title': _title,
                                        'content': _content,
                                      }),
                                    );

                                    if (mounted) {
                                      if (response['status'] == 'success') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              widget.messageToEdit != null
                                                  ? "Message updated successfully!"
                                                  : "Message sent successfully!",
                                            ),
                                            backgroundColor: const Color(0xFF3E2723),
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
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Error: $e"),
                                          backgroundColor: const Color(0xFF3E2723),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E2723),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                widget.messageToEdit != null ? 'Update' : 'Send',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
              ),
            ),
    );
  }
}