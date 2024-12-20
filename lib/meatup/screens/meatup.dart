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
          SnackBar(
            content: Text('Error loading messages: $e'),
            backgroundColor: Color(0xFF3E2723),
          ),
        );
      }
    }
  }

  Future<void> _deleteMessage(CookieRequest request, int messageId) async {
    try {
      request.get('http://127.0.0.1:8000/meatup/flutter/delete/$messageId/');
      setState(() {
        fetchMessages();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesan berhasil dihapus'),
          backgroundColor: Color(0xFF3E2723),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Color(0xFF3E2723),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessageFormPage(),
                      ),
                    );
                    if (result == true) {
                      fetchMessages();
                    }
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
                  request: request,
                  title: 'Received Meat Up Request',
                  messages: receivedMessages,
                  isReceived: true,
                ),
                const SizedBox(height: 24),

                // Sent Messages Section
                _buildMessagesSection(
                  request: request,
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
    required request,
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
                  return _buildMessageCard(message, isReceived, request);
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

  Widget _buildMessageCard(Map<String, dynamic> message, bool isReceived, CookieRequest request) {
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
              // onPressed: () => _deleteMessage(request, messageId),
              onPressed: () async {
                _deleteMessage(request, messageId);
                setState(() {
                  fetchMessages();
                });
              },
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