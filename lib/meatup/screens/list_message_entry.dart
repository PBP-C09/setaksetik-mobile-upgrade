import 'package:flutter/material.dart';
import '../models/message_entry.dart';
// import '../widgets/left_drawer.dart'; 
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MessageEntryPage extends StatefulWidget {
  const MessageEntryPage({super.key});

  @override
  State<MessageEntryPage> createState() => _MessageEntryPageState();
}

class _MessageEntryPageState extends State<MessageEntryPage> {
  Future<List<MessageEntry>> fetchMessages(CookieRequest request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://127.0.0.1:8000/api/messages/'); // Adjust URL to the correct endpoint

    // Decode response into JSON
    var data = response;

    // Convert the JSON data into MessageEntry objects
    List<MessageEntry> listMessages = [];
    for (var d in data) {
      if (d != null) {
        listMessages.add(MessageEntry.fromJson(d));
      }
    }
    return listMessages;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Entry List'),
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
                    'Belum ada data pesan pada MeatUp.',
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From: ${snapshot.data![index].fields.sender}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("To: ${snapshot.data![index].fields.receiver}"),
                      const SizedBox(height: 10),
                      Text("Message: ${snapshot.data![index].fields.content}"),
                      const SizedBox(height: 10),
                      Text("Sent at: ${snapshot.data![index].fields.timestamp}")
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