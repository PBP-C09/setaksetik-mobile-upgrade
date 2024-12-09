// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';

// import 'package:flutter/material.dart';
// // import 'package:pageturn_mobile/apps/Homepage/menu.dart';
// // import 'package:pbp_django_auth/pbp_django_auth.dart';
// // import 'package:provider/provider.dart';

// class ReviewForm extends StatefulWidget {
//   const ReviewForm({super.key});

//   @override
//   State<ReviewForm> createState() => _ReviewFormState();
// }

// class _ReviewFormState extends State<ReviewForm> {
//   final _formKey = GlobalKey<FormState>();
//   String _name = "";
//   String _review = "";

//   @override
//   Widget build(BuildContext context) {
//     // final request = context.watch<CookieRequest>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'Form Tambah Review',
//           ),
//         ),
//         backgroundColor: const Color(0xffc06c34),
//         foregroundColor: Colors.white,
//       ),
//       // : Tambahkan drawer yang sudah dibuat di sini
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               decoration: InputDecoration(
//                 hintText: "Nama Buku",
//                 labelText: "Nama Buku",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//               ),
//               onChanged: (String? value) {
//                 setState(() {
//                   _name = value!;
//                 });
//               },
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return "Nama tidak boleh kosong!";
//                 }
//                 return null;
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               decoration: InputDecoration(
//                 hintText: "Review",
//                 labelText: "Review",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//               ),
//               onChanged: (String? value) {
//                 setState(() {
//                   // : Tambahkan variabel yang sesuai
//                   _review = value!;
//                 });
//               },
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return "Deskripsi tidak boleh kosong!";
//                 }
//                 return null;
//               },
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.indigo),
//                 ),
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     // Kirim ke Django dan tunggu respons
//                     // : Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
//                     final response = await request.postJson(
//                         "https://pageturn-b11-tk.pbp.cs.ui.ac.id/review/create-flutter/",
//                         jsonEncode(<String, String>{
//                           'name': _name,
//                           'description': _review,
//                           // : Sesuaikan field data sesuai dengan aplikasimu
//                         }));
//                     if (response['status'] == 'success') {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                         content: Text("Review baru berhasil disimpan!"),
//                       ));
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const MyHomePage()),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                         content: Text("Terdapat kesalahan, silakan coba lagi."),
//                       ));
//                     }
//                   }
//                 },
//                 child: const Text(
//                   "Save",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ])),
//       ),
//     );
//   }
// }