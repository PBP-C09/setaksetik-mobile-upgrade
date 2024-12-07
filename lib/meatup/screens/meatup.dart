import 'package:flutter/material.dart';

class MeatUpPage extends StatefulWidget {
  const MeatUpPage({super.key}); 

  @override
  MeatUpPageState createState() => MeatUpPageState();
}

class MeatUpPageState extends State<MeatUpPage> {
  List<Map<String, String>> receivedMessages = [];
  List<Map<String, String>> sentMessages = [];

  void _showCreateMessageForm() {
    // Navigate to create message form
    Navigator.pushNamed(context, '/create-message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723), // Dark brown background
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
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Create Message Button
                ElevatedButton(
                  onPressed: _showCreateMessageForm, // This will navigate to the form
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
                      fontFamily: 'Inter',
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

  // Helper method to display messages in grid view
  Widget _buildMessagesSection({
    required String title,
    required List<Map<String, String>> messages,
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
            fontFamily: 'Inter',
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

  // Helper method to build individual message cards
  Widget _buildMessageCard(Map<String, String> message, bool isReceived) {
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
                  isReceived ? 'From: ${message['sender']}' : 'To: ${message['receiver']}',
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
                  message['timestamp']!,
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
                    message['title']!,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFFF5F5DC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message['content']!,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      color: Color(0xFFF5F5DC),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Button (Delete or Cancel)
            ElevatedButton(
              onPressed: () {
                // Implement delete/cancel functionality
                _deleteMessage(message, isReceived);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF842323),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isReceived ? 'Reject Meat Up' : 'Cancel Meat Up',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMessage(Map<String, String> message, bool isReceived) {
    setState(() {
      if (isReceived) {
        receivedMessages.remove(message);
      } else {
        sentMessages.remove(message);
      }
    });
  }
}