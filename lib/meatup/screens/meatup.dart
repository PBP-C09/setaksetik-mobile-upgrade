import 'package:flutter/material.dart';
import 'package:setaksetikmobile/meatup/screens/message_form.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

class MeatUpPage extends StatefulWidget {
  const MeatUpPage({super.key});

  @override
  MeatUpPageState createState() => MeatUpPageState();
}

class MeatUpPageState extends State<MeatUpPage> {
  List<Map<String, dynamic>> receivedMessages = [];
  List<Map<String, dynamic>> sentMessages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://127.0.0.1:8000/meatup/flutter/get-messages-json/');
      if (mounted) {
        setState(() {
          receivedMessages = List<Map<String, dynamic>>.from(response['received_messages']);
          sentMessages = List<Map<String, dynamic>>.from(response['sent_messages']);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading messages')),
        );
      }
    }
  }

  Future<void> _deleteMessage(CookieRequest request, int messageId) async {
    try {
      await request.get('http://127.0.0.1:8000/meatup/flutter/delete/$messageId/');
      fetchMessages();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meat Up'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mau meat up sama siapa?',
              style: TextStyle(
                color: Color(0xFFF5F5DC),
                fontSize: 42,
                fontStyle: FontStyle.italic,
                fontFamily: 'Playfair Display',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MessageFormPage()),
                  );
                  if (result == true) fetchMessages();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E2723),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Send New Meat Up Request',
                  style: TextStyle(
                    color: Color(0xFFF5F5DC),
                    fontSize: 18,
                    fontFamily: 'Playfair Display',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            _buildSection('Received Meat Up Request', receivedMessages, true, request),
            const SizedBox(height: 48),
            _buildSection('Sent Meat Up Request', sentMessages, false, request),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> messages, bool isReceived, CookieRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 28,
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        messages.isEmpty
            ? Center(
                child: Text(
                  isReceived ? 'No received messages yet' : 'No sent messages yet',
                  style: const TextStyle(
                    color: Color(0xFFF5F5DC),
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 40) / 2;
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: messages.map((message) => 
                      SizedBox(
                        width: cardWidth,
                        child: _buildCard(message, isReceived, request),
                      )
                    ).toList(),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> message, bool isReceived, CookieRequest request) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isReceived ? 'From: ${message['sender']}' : 'To: ${message['receiver']}',
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              message['timestamp'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const Divider(height: 24, thickness: 1, color: Color(0xFF3E2723),),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3E2723),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['title'],
                    style: const TextStyle(
                      color: Color(0xFFF5F5DC),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message['content'],
                    style: const TextStyle(
                      color: Color(0xFFF5F5DC),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!isReceived) 
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageFormPage(messageToEdit: message),
                    ),
                  );
                  if (result == true) fetchMessages();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF3E2723),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Edit'),
              ),
            if (!isReceived) 
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _deleteMessage(request, message['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF842323),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(isReceived ? 'Reject Meat Up' : 'Cancel Meat Up'),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     if (!isReceived)
            //       ElevatedButton(
            //         onPressed: () async {
            //           final result = await Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => MessageFormPage(messageToEdit: message),
            //             ),
            //           );
            //           if (result == true) fetchMessages();
            //         },
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: const Color(0xFFFFD700),
            //           foregroundColor: const Color(0xFF3E2723),
            //           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //         ),
            //         child: const Text('Edit'),
            //       ),
            //     ElevatedButton(
            //       onPressed: () => _deleteMessage(request, message['id']),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFF842323),
            //         foregroundColor: Colors.white,
            //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //       ),
            //       child: Text(isReceived ? 'Reject Meat Up' : 'Cancel Meat Up'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}