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
      final response = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/meatup/flutter/get-messages-json/');
      if (mounted) {
        setState(() {
          final allReceivedMessages = List<Map<String, dynamic>>.from(response['received_messages']);
          final allSentMessages = List<Map<String, dynamic>>.from(response['sent_messages']);

          receivedMessages = allReceivedMessages
              .where((msg) => msg['status'] == null || msg['status'] == 'PENDING')
              .toList();

          sentMessages = allSentMessages
              .where((msg) => msg['status'] == null || msg['status'] == 'PENDING')
              .toList();

          acceptedMessages = [
            ...allReceivedMessages.where((msg) => msg['status'] == 'ACCEPTED'),
            ...allSentMessages.where((msg) => msg['status'] == 'ACCEPTED')
          ];

          rejectedMessages = [
            ...allReceivedMessages.where((msg) => msg['status'] == 'REJECTED'),
            ...allSentMessages.where((msg) => msg['status'] == 'REJECTED')
          ];

          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF3E2723),
              content: Text("Error loading messages")),
          );
      }
    }
  }

  Future<void> _deleteMessage(CookieRequest request, int messageId) async {
    try {
      final response = await request.post(
        'https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/meatup/flutter/delete/$messageId/',
        {},
      );
      
      if (response['status'] == 'success') {
        await fetchMessages();  
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFF3E2723),
                content: Text("Message deleted successfully")),
            );
        }
      } else {
        throw Exception('Failed to delete message');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Error: $e'),
            ),
          );
      }
    }
  }

Future<void> _acceptMessage(CookieRequest request, int messageId) async {
    try {
      final response = await request.post(
        'https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/meatup/flutter/accept/$messageId/',
        {},
      );
      
      if (response['status'] == 'success') {
        await fetchMessages();
        
        if (mounted) {
          final acceptedMsg = [...receivedMessages, ...sentMessages]
              .firstWhere((msg) => msg['id'] == messageId, orElse: () => {});
          
          if (acceptedMsg.isNotEmpty) {
            setState(() {
              receivedMessages.removeWhere((msg) => msg['id'] == messageId);
              sentMessages.removeWhere((msg) => msg['id'] == messageId);
              
              acceptedMsg['status'] = 'ACCEPTED';
              acceptedMessages.add(acceptedMsg);
            });
          }
          
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFF3E2723),
                content: Text("Message accepted successfully")),
            );
        }
      } else {
        throw Exception('Failed to accept message');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Error: $e'),
            ),
          );
      }
    }
  }

  Future<void> _rejectMessage(CookieRequest request, int messageId) async {
    try {
      final response = await request.post(
        'https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/meatup/flutter/reject/$messageId/',
        {},
      );
      
      if (response['status'] == 'success') {
        await fetchMessages();
        
        if (mounted) {
          final rejectedMsg = [...receivedMessages, ...sentMessages]
              .firstWhere((msg) => msg['id'] == messageId, orElse: () => {});
          
          if (rejectedMsg.isNotEmpty) {
            setState(() {
              receivedMessages.removeWhere((msg) => msg['id'] == messageId);
              sentMessages.removeWhere((msg) => msg['id'] == messageId);
              
              rejectedMsg['status'] = 'REJECTED';
              rejectedMessages.add(rejectedMsg);
            });
          }
          
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFF3E2723),
                content: Text("Message rejected successfully")),
            );
        }
      } else {
        throw Exception('Failed to reject message');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Error: $e'),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Meat Up',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.pending_actions),   
                    const SizedBox(width: 8),
                    Text('Received (${receivedMessages.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.send),
                    const SizedBox(width: 8),
                    Text('Sent (${sentMessages.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.handshake),   
                    const SizedBox(width: 8),
                    Text('Accepted (${acceptedMessages.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.block),  
                    const SizedBox(width: 8),
                    Text('Rejected (${rejectedMessages.length})'),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: const LeftDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MessageFormPage()),
            );
            if (result == true) fetchMessages();
          },
          backgroundColor: const Color(0xFF3E2723),
          icon: const Icon(Icons.add, color: Color(0xFFF5F5DC)),
          label: const Text(
            'New Request',
            style: TextStyle(
              color: Color(0xFFF5F5DC),
              fontFamily: 'Playfair Display',
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildMessageList(receivedMessages, true, request),
                  _buildMessageList(sentMessages, false, request),
                  _buildMessageList(acceptedMessages, false, request, isAccepted: true),
                  _buildMessageList(rejectedMessages, false, request, isRejected: true),
                ],
              ),
      ),
    );
  }

  Widget _buildMessageList(
    List<Map<String, dynamic>> messages,
    bool isReceived,
    CookieRequest request, {
    bool isAccepted = false,
    bool isRejected = false,
  }) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isReceived ? Icons.pending_actions :
              isAccepted ? Icons.handshake :
              isRejected ? Icons.block : Icons.send_outlined,
              size: 64,
              color: const Color(0xFFF5F5DC),
            ),
            const SizedBox(height: 16),
            Text(
              isReceived ? 'No pending requests' :
              isAccepted ? 'No accepted requests' :
              isRejected ? 'No rejected requests' : 'No sent requests',
              style: const TextStyle(
                color: Color(0xFFF5F5DC),
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isAccepted ? const Color (0xFF307A48) :
                         isRejected ? const Color(0xFF842323) :
                         const Color(0xFF3E2723),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isReceived ? 'From: ${message['sender']}' : 'To: ${message['receiver']}',
                          style: const TextStyle(
                            color: Color(0xFFF5F5DC),
                            fontFamily: 'Playfair Display',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          message['timestamp'],
                          style: const TextStyle(
                            color: Color(0xFFF5F5DC),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message['title'],
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 20,
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message['content'],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              if (!isAccepted && !isRejected) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (isReceived) ...[
                        TextButton.icon(
                          onPressed: () => _acceptMessage(request, message['id']),
                          icon: const Icon(Icons.handshake, color: Colors.green),
                          label: const Text('Accept', style: TextStyle(color: Colors.green)),
                        ),
                        TextButton.icon(
                          onPressed: () => _rejectMessage(request, message['id']),
                          icon: const Icon(Icons.block, color: Colors.red),
                          label: const Text('Decline', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                      if (!isReceived)
                        TextButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessageFormPage(messageToEdit: message),
                              ),
                            );
                            if (result == true) fetchMessages();
                          },
                          icon: const Icon(Icons.edit, color: Color(0xFFFFD700)),
                          label: const Text('Edit', style: TextStyle(color: Color(0xFFFFD700))),
                        ),
                      TextButton.icon(
                        onPressed: () => _deleteMessage(request, message['id']),
                        icon: const Icon(Icons.delete, color: Color(0xFF842323)),
                        label: const Text('Delete', style: TextStyle(color: Color(0xFF842323))),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}