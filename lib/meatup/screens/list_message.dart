import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Future<List<MeatupMessage>> fetchMessages(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/messages/');

    var data = response;

    List<MeatupMessage> messages = [];
    for (var d in data) {
      if (d != null) {
        messages.add(MeatupMessage.fromJson(d));
      }
    }
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message List'),
      ),
      // drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchMessages(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'No messages available.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data![index].sender}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].content}"),
                      const SizedBox(height: 10),
                      Text("Sent at: ${snapshot.data![index].createdAt}")
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
