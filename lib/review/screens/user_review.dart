import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// import 'package:setaksetikmobile/review/models/menu.dart';
import 'package:setaksetikmobile/review/models/review.dart';
// import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'dart:convert';

import 'package:setaksetikmobile/review/screens/review_list.dart';
// import 'models/review.dart';  // Review model
// import 'models/menu.dart';    // Menu model

class ReviewMainPage extends StatefulWidget {
  const ReviewMainPage({super.key});

  @override
  _ReviewMainPageState createState() => _ReviewMainPageState();
}

class _ReviewMainPageState extends State<ReviewMainPage> {
  List<ReviewList> reviews = [];  // Daftar menu yang di-fetch dari API

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    print("tes");
    fetchReviews(request);  // Panggil fungsi untuk fetch menu
    print("masuk sini ga");
  }


  // Fetch menus dari API Django
  // Future<void> fetchReviews(CookieRequest request) async {
  //   try {
  //     final response = await request.get('http://127.0.0.1:8000/review/get_review/');
  //     print("Response: $response");  // Log the response to check its structure

  //     if (response != null) {
  //       // Parse the response into ReviewList objects
  //       print("dia ga null");
  //       setState(() {
  //         reviews = reviewListFromJson(response);  // Ensure the response is a valid JSON string
  //         print("disini ya errornya"); 
  //       });
  //     } else {
  //       throw Exception('Response is null');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to load reviews');
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Review',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: reviews.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading state
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: reviews.map((reviews) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        // leading: Image.network(reviews.fields.place), // Menampilkan gambar
                        title: Text(reviews.fields.place),
                        subtitle: Text(reviews.fields.place),
                        onTap: () {
                          // Menavigasi ke halaman form review dengan membawa menu yang dipilih
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}

