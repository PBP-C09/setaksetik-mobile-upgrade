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

class MeatUpPageState extends State<MeatUpPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> receivedMessages = [];
  List<Map<String, dynamic>> sentMessages = [];
  List<Map<String, dynamic>> acceptedMessages = [];
  List<Map<String, dynamic>> rejectedMessages = [];
  bool isLoading = true;
  int currentSlide = 0;
  bool showWelcome = true;
  late TabController _tabController;
  final PageController _welcomePageController = PageController();

  final List<Map<String, dynamic>> welcomeSlides = [
    {
      'emoji': '👥',
      'title': 'Connect with Steak Lovers',
      'description': 'Find and connect with fellow steak enthusiasts in your area!'
    },
    {
      'emoji': '💌',
      'title': 'Send Meat Up Requests',
      'description': 'Easily send and manage your meet-up invitations!'
    },
    {
      'emoji': '🥩',
      'title': 'Enjoy Great Company',
      'description': 'Share your passion for steak with new friends!'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchMessages();
    
    if (showWelcome) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && showWelcome) {
          _welcomePageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _welcomePageController.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
          'https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/meatup/flutter/get-messages-json/');
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF3E2723),
            content: Text("Error loading messages"),
          ),
        );
      }
    }
  }

  Widget buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text(
            'Welcome to Meat Up!',
            style: TextStyle(
              color: Color(0xFFF5F5DC),
              fontSize: 42,
              fontFamily: 'Playfair Display',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _welcomePageController,
              itemCount: welcomeSlides.length,
              onPageChanged: (index) {
                setState(() {
                  currentSlide = index;
                });
              },
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: currentSlide == index ? 1.0 : 0.0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5DC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          welcomeSlides[index]['emoji'],
                          style: const TextStyle(fontSize: 72),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          welcomeSlides[index]['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          welcomeSlides[index]['description'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF6D4C41),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              welcomeSlides.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentSlide == index
                      ? const Color(0xFFF7B32B)
                      : const Color(0xFF3E2723).withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showWelcome = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF7B32B),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Start Your Meat Up Journey!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Playfair Display',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageCard(Map<String, dynamic> message, bool isReceived, {String? status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            if (status != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'Accepted'
                      ? const Color(0xFF34D399)
                      : status == 'Rejected'
                          ? const Color(0xFFF87171)
                          : const Color(0xFFFCD34D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Accepted'
                        ? const Color(0xFF065F46)
                        : status == 'Rejected'
                            ? const Color(0xFF991B1B)
                            : const Color(0xFF92400E),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 12),
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
            const Divider(
              height: 24,
              thickness: 1,
              color: Color(0xFF3E2723),
            ),
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
            if (status == null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isReceived) ...[
                    ElevatedButton(
                      onPressed: () => handleMessageAction('accept', message['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accept'),
                    ),
                    ElevatedButton(
                      onPressed: () => handleMessageAction('reject', message['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF842323),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reject'),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MessageFormPage(messageToEdit: message),
                          ),
                        );
                        if (result == true) fetchMessages();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7B32B),
                        foregroundColor: const Color(0xFF3E2723),
                      ),
                      child: const Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () => handleMessageAction('delete', message['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF842323),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> handleMessageAction(String action, int messageId) async {
    try {
      final request = context.read<CookieRequest>();
      await request.get(
          'https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/meatup/flutter/$action/$messageId/');
      fetchMessages();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF3E2723),
            content: Text("Message ${action}ed successfully"),
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
    return Scaffold(
      appBar: showWelcome
          ? AppBar(
              title: const Text('Meat Up'),
              centerTitle: true,
            )
          : AppBar(
              title: const Text('Meat Up'),
              centerTitle: true,
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Received (${receivedMessages.length})'),
                  Tab(text: 'Sent (${sentMessages.length})'),
                  Tab(text: 'Accepted (${acceptedMessages.length})'),
                  Tab(text: 'Rejected (${rejectedMessages.length})'),
                ],
              ),
            ),
      drawer: const LeftDrawer(),
      floatingActionButton: showWelcome
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessageFormPage()),
                );
                if (result == true) fetchMessages();
              },
              backgroundColor: const Color(0xFFF7B32B),
              child: const Icon(Icons.add, color: Colors.white),
            ),
      body: showWelcome
          ? buildWelcomeSection()
          : TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: receivedMessages.isEmpty
                      ? [
                          const Center(
                            child: Text(
                              'No received messages yet',
                              style: TextStyle(
                                color: Color(0xFFF5F5DC),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        ]
                      : receivedMessages
                          .map((msg) => buildMessageCard(msg, true))
                          .toList(),
                ),

                ListView(
                  padding: const EdgeInsets.all(16),
                  children: sentMessages.isEmpty
                      ? [
                          const Center(
                            child: Text(
                              'No sent messages yet',
                              style: TextStyle(
                                color: Color(0xFFF5F5DC),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        ]
                      : sentMessages
                          .map((msg) => buildMessageCard(msg, false))
                          .toList(),
                ),

                ListView(
                  padding: const EdgeInsets.all(16),
                  children: acceptedMessages.isEmpty
                      ? [
                          const Center(
                            child: Text(
                              'No accepted messages yet',
                              style: TextStyle(
                                color: Color(0xFFF5F5DC),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        ]
                      : acceptedMessages
                          .map((msg) => buildMessageCard(msg, msg['receiver'] != msg['current_user'], status: 'Accepted'))
                          .toList(),
                ),

                ListView(
                  padding: const EdgeInsets.all(16),
                  children: rejectedMessages.isEmpty
                      ? [
                          const Center(
                            child: Text(
                              'No rejected messages yet',
                              style: TextStyle(
                                color: Color(0xFFF5F5DC),
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        ]
                      : rejectedMessages
                          .map((msg) => buildMessageCard(msg, msg['receiver'] != msg['current_user'], status: 'Rejected'))
                          .toList(),
                ),
              ],
            ),
      backgroundColor: const Color(0xFF3E2723),
    );
  }
}