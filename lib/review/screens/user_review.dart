// // ignore_for_file: prefer_const_constructors_in_immutables

// import 'package:flutter/material.dart';
// // import 'package:pageturn_mobile/apps/Reviewbuku/screens/addreview.dart';
// // import 'package:pageturn_mobile/apps/Reviewbuku/screens/listreview.dart';
// // import 'package:pageturn_mobile/components/left_drawer.dart';

// class HalamanPertama extends StatelessWidget {
//   HalamanPertama({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // drawer: const LeftDrawer(),
//       appBar: AppBar(
//         title: const Text(
//           ' REVIEW BUKU ',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 78, 52, 16),
//         foregroundColor: const Color.fromARGB(255, 255, 255, 255),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           const SizedBox(height: 20),
//           Align(
//             alignment: Alignment.center,
//             child: TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ReviewForm()),
//                 );
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 152, 0),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//               ),
//               child: const Text(
//                 'Add Review',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white, // Warna teks putih
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Align(
//             alignment: Alignment.center,
//             child: TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ReviewPage()),
//                 );
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 152, 0),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//               ),
//               child: const Text(
//                 'Daftar Review',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white, // Warna teks putih
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }