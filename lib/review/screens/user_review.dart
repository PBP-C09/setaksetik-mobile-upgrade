import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/review/models/review.dart';
import 'package:setaksetikmobile/review/screens/review_list.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

class ReviewMainPage extends StatefulWidget {
  const ReviewMainPage({super.key});

  @override
  _ReviewMainPageState createState() => _ReviewMainPageState();
}

class _ReviewMainPageState extends State<ReviewMainPage> {
  List<ReviewList> reviews = []; // Daftar review yang di-fetch dari API

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchReviews(request); // Panggil fungsi untuk fetch reviews
  }

  // Fetch reviews dari API Django
  Future<void> fetchReviews(CookieRequest request) async {
    try {
      final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/review/get_review/');

      if (response != null) {
        setState(() {
          reviews = reviewListFromJson(response);
        });
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: reviews.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Apa kata ',
                                  style: TextStyle(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFF5F5DC),
                                  ),
                                ),
                                TextSpan(
                                  text: 'mereka?',
                                  style: TextStyle(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFFF5F5DC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                          const SizedBox(height: 12.0),
                          Column(
                            children: const [
                              Text(
                                'Dengar cerita dan rekomendasi dari',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'steak enthusiasts di seluruh penjuru',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: reviews.map((review) {
                        return Card(
                          color: const Color(0xFFF5F5DC),
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              review.fields.menu,
                              style: const TextStyle(
                                fontSize: 16, // Font size reduced
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.brown, // Dark brown color
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      review.fields.place,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.brown, // Darker brown
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Row(
                                      children: List.generate(
                                        review.fields.rating,
                                        (index) => const Icon(
                                          Icons.star,
                                          color: Color(0xFFE5B700),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${review.fields.rating}/5',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  review.fields.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                  if (review.fields.ownerReply != null &&
                                    review.fields.ownerReply!.isNotEmpty)
                                  Container(
                                    width: double.infinity, // Ensures full width inside the card
                                    margin: const EdgeInsets.only(top: 8.0), // Space above the reply box
                                    padding: const EdgeInsets.all(12.0), // Inner padding for the box
                                    decoration: BoxDecoration(
                                      color: Colors.white, // White background for the reply box
                                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Balasan Pemilik:',
                                          style: const TextStyle(
                                            fontFamily: 'Raleway',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown, // Dark brown text color
                                          ),
                                        ),
                                        const SizedBox(height: 4), // Space between title and reply text
                                        Text(
                                          review.fields.ownerReply!,
                                          style: const TextStyle(
                                            fontFamily: 'Raleway',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black, // Black text for reply content
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                              ],
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
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
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReviewPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
    );
  }
}
