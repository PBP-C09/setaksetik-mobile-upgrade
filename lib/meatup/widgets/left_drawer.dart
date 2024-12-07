// import 'package:flutter/material.dart';
// // import 'package:mental_health_tracker/screens/list_moodentry.dart';
// // import 'package:mental_health_tracker/screens/menu.dart';
// // import 'package:mental_health_tracker/screens/moodentry_form.dart';
// // import 'package:pbp_django_auth/pbp_django_auth.dart';
// // import 'package:provider/provider.dart';

// class LeftDrawer extends StatelessWidget {
//   const LeftDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final request = context.watch<CookieRequest>();

//     return Drawer(
//       child: ListView(
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             child: const Column(
//               children: [
//                 Text(
//                   'Mental Health Tracker',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Padding(padding: EdgeInsets.all(8)),
//                 Text(
//                   "Ayo jaga kesehatan mentalmu setiap hari disini!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.white,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.home_outlined),
//             title: const Text('Halaman Utama'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const MyHomePage(),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.mood),
//             title: const Text('Tambah Mood'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const MessageEntryFormPage(),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.add_reaction_rounded),
//             title: const Text('Daftar Mood'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const MessageEntryPage(),
//                 ),
//               );
//             },
//           ),
//           // ListTile(
//           //   leading: const Icon(Icons.logout),
//           //   title: const Text('Logout'),
//           //   onTap: () async {
//           //     final response = await request.logout("http://127.0.0.1:8000/auth/logout/");
//           //     if (context.mounted) {
//           //       if (response['status']) {
//           //         String uname = response["username"];
//           //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           //           content: Text("Logout berhasil. Sampai jumpa, $uname!"),
//           //         ));
//           //         Navigator.pushReplacement(
//           //           context,
//           //           MaterialPageRoute(builder: (context) => const LoginPage()),
//           //         );
//           //       } else {
//           //         ScaffoldMessenger.of(context).showSnackBar(
//           //           SnackBar(
//           //             content: Text(response["message"]),
//           //           ),
//           //         );
//           //       }
//           //     }
//           //   },
//           // ),
//         ],
//       ),
//     );
//   }
// }
