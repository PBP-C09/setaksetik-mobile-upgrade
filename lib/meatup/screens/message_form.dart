import 'package:flutter/material.dart';
import '../../screens/login.dart'; // Path ke halaman login
import '../screens/list_message_entry.dart'; // Path ke daftar pesan
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));

          if (item.name == "Tambah Pesan") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessageFormPage(), // Halaman form tambah pesan
              ),
            );
          } else if (item.name == "Lihat Pesan") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessageEntryPage(), // Halaman daftar pesan
              ),
            );
          } else if (item.name == "Logout") {
            final response = await request.logout(
                "http://127.0.0.1:8000/auth/logout/"); // URL logout
            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Tambahkan kelas MessageFormPage di bawah ini
class MessageFormPage extends StatelessWidget {
  const MessageFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pesan'),
      ),
      body: const Center(
        child: Text('Form Tambah Pesan akan diletakkan di sini.'),
      ),
    );
  }
}