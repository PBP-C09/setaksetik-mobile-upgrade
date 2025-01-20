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
  List<Map<String, dynamic>> acceptedMessages = [];
  List<Map<String, dynamic>> rejectedMessages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://127.0.0.1:8000/meatup/get-messages-json/');
      if (mounted) {
        setState(() {
          receivedMessages = List<Map<String, dynamic>>.from(response['received_messages']);
          sentMessages = List<Map<String, dynamic>>.from(response['sent_messages']);
          acceptedMessages = List<Map<String, dynamic>>.from(response['accepted_messages']);
          rejectedMessages = List<Map<String, dynamic>>.from(response['rejected_messages']);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error details: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF3E2723),
              content: Text("Error loading messages")
            ),
          );
      }
    }
  }

  Future<void> _deleteMessage(CookieRequest request, int messageId) async {
    try {
      await request.get('http://127.0.0.1:8000/meatup/delete/$messageId/');
      fetchMessages();
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF3E2723),
              content: Text("Message deleted successfully")
            ),
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

  Future<void> _acceptMessage(CookieRequest request, int messageId) async {
    try {
      await request.post(
        'http://127.0.0.1:8000/meatup/accept/$messageId/',
        {},
      );
      fetchMessages();
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF3E2723),
              content: Text("Message accepted successfully")
            ),
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

  Future<void> _rejectMessage(CookieRequest request, int messageId) async {
    try {
      await request.post(
        'http://127.0.0.1:8000/meatup/reject/$messageId/',
        {},
      );
      fetchMessages();
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF3E2723),
              content: Text("Message rejected successfully")
            ),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Meat Up',
                          style: TextStyle(
                            color: Color(0xFFF5F5DC),
                            fontSize: 42,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Playfair Display',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'dengan Steak Lover lainnya!',
                          style: TextStyle(
                            color: Color(0xFFF5F5DC),
                            fontSize: 42,
                            fontFamily: 'Playfair Display',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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
                        backgroundColor: const Color(0xFFFFD700),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Kirim Pesan Meat Up',
                        style: TextStyle(
                          color: Color(0xFF3E2723),
                          fontSize: 18,
                          fontFamily: 'Playfair Display',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildSection('Received Meat Up Request', receivedMessages, isReceived: true, request: request),
                  const SizedBox(height: 48),
                  _buildSection('Sent Meat Up Request', sentMessages, isReceived: false, request: request),
                  const SizedBox(height: 48),
                  _buildSection('Accepted Meat Up Request', acceptedMessages, isReceived: false, request: request, isAccepted: true),
                  const SizedBox(height: 48),
                  _buildSection('Rejected Meat Up Request', rejectedMessages, isReceived: false, request: request, isRejected: true),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(
    String title, 
    List<Map<String, dynamic>> messages, 
    {required bool isReceived, 
    required CookieRequest request, 
    bool isAccepted = false,
    bool isRejected = false}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
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
                  'No ${title.toLowerCase()} yet',
                  style: const TextStyle(
                    color: Color(0xFFF5F5DC),
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: messages.map((message) => 
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 600 
                      ? (MediaQuery.of(context).size.width - 88) / 2 
                      : MediaQuery.of(context).size.width - 48,
                    child: _buildCard(
                      message, 
                      isReceived, 
                      request,
                      isAccepted: isAccepted,
                      isRejected: isRejected,
                    ),
                  )
                ).toList(),
              ),
      ],
    );
  }

  Widget _buildCard(
    Map<String, dynamic> message, 
    bool isReceived, 
    CookieRequest request,
    {bool isAccepted = false,
    bool isRejected = false}
  ) {
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
                color: Color(0xFF3E2723),
              ),
            ),
            Text(
              message['timestamp'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const Divider(height: 24, thickness: 1, color: Color(0xFF3E2723)),
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
            if (!isAccepted && !isRejected) ...[
              const SizedBox(height: 16),
              if (isReceived) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _acceptMessage(request, message['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Accept Meat Up'),
                    ),
                    ElevatedButton(
                      onPressed: () => _rejectMessage(request, message['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF842323),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Reject Meat Up'),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                    ElevatedButton(
                      onPressed: () => _deleteMessage(request, message['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF842323),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Cancel Meat Up'),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}