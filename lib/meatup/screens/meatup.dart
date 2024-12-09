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
  // Sample data structure for testing
  final List<Map<String, dynamic>> receivedMessages = [
    {
      'sender': 'John Doe',
      'receiver': 'Me',
      'timestamp': '2024-03-09 14:30',
      'title': 'Steak Dinner',
      'content': 'Would you like to meet up for steak dinner?',
      'id': 1,
    },
    // Add more sample messages as needed
  ];

  final List<Map<String, dynamic>> sentMessages = [
    {
      'sender': 'Me',
      'receiver': 'Jane Smith',
      'timestamp': '2024-03-08 15:45',
      'title': 'BBQ Meetup',
      'content': 'Let\'s have a BBQ this weekend!',
      'id': 2,
    },
    // Add more sample messages as needed
  ];

  Future<void> _deleteMessage(int messageId) async {
    try {
      setState(() {
        receivedMessages.removeWhere((message) => message['id'] == messageId);
        sentMessages.removeWhere((message) => message['id'] == messageId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesan berhasil dihapus'),
          backgroundColor: Color(0xFFF7B32B),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: const Text('Meat Up'),
      ),
      drawer: LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Meat Up dengan Steak Lover lainnya!',
                  style: TextStyle(
                    color: const Color(0xFFF5F5DC),
                    fontSize: 42,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Playfair Display',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Create Message Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessageFormPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7B32B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Kirim Pesan Meat Up',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Received Messages Section
                _buildMessagesSection(
                  title: 'Received Meat Up Request',
                  messages: receivedMessages,
                  isReceived: true,
                ),
                const SizedBox(height: 24),

                // Sent Messages Section
                _buildMessagesSection(
                  title: 'Sent Meat Up Request',
                  messages: sentMessages,
                  isReceived: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesSection({
    required String title,
    required List<Map<String, dynamic>> messages,
    required bool isReceived,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFFD54F),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Playfair Display',
          ),
        ),
        const SizedBox(height: 16),
        messages.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageCard(message, isReceived);
                },
              )
            : Center(
                child: Text(
                  isReceived
                      ? 'Kamu belum menerima pesan Meat Up :('
                      : 'Kamu belum pernah mengirim pesan Meat Up. Kirim sekarang!',
                  style: const TextStyle(
                    color: Color(0xFFF5F5DC),
                    fontSize: 18,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message, bool isReceived) {
    final sender = message['sender'] as String;
    final receiver = message['receiver'] as String;
    final timestamp = message['timestamp'] as String;
    final title = message['title'] as String;
    final content = message['content'] as String;
    final messageId = message['id'] as int;

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Section with Sender/Receiver and Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReceived 
                    ? 'From: $sender' 
                    : 'To: $receiver',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: const Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFF3E2723),
                  ),
                ),
              ],
            ),

            const Divider(color: Color(0xFF3E2723), thickness: 1),

            // Message Content
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
                    title,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFFF5F5DC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      color: Color(0xFFF5F5DC),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Delete/Reject Button
            TextButton(
              onPressed: () => _deleteMessage(messageId),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF842323),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isReceived ? 'Reject Meat Up' : 'Cancel Meat Up',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}