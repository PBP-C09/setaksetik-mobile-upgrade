import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:setaksetikmobile/review/models/menu.dart';
import 'package:setaksetikmobile/review/models/review.dart';
import 'dart:convert';
// import 'models/review.dart';  // Review model
// import 'models/menu.dart';    // Menu model

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Menu> menus = [];  // To store fetched menus
  List<Review> reviews = [];  // To store fetched reviews
  final _placeController = TextEditingController();
  final _ratingController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedMenuId;  // Variable to store selected menu ID

  @override
  void initState() {
    super.initState();
    fetchMenus();  // Fetch menus on initial load
  }

  // Fetch menus from Django API
  Future<void> fetchMenus() async {
    final response = await http.get(Uri.parse('https://your-django-api-endpoint.com/menus/'));

    if (response.statusCode == 200) {
      setState(() {
        menus = menuFromJson(response.body);  // Parse JSON into Menu objects
      });
    } else {
      throw Exception('Failed to load menus');
    }
  }

  // Add a review via AJAX (POST request)
  Future<void> addReview() async {
    final place = _placeController.text;
    final rating = int.tryParse(_ratingController.text) ?? 0;
    final description = _descriptionController.text;

    final response = await http.post(
      Uri.parse('https://your-django-api-endpoint.com/create-review-entry-ajax'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'menu_id': _selectedMenuId,  // Send the selected menu ID
        'place': place,
        'rating': rating,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      // If review was created successfully, reload reviews for that menu
      fetchReviews();
      Navigator.of(context).pop();  // Close the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add review")));
    }
  }

  // Fetch reviews for a specific menu
  Future<void> fetchReviews() async {
    final response = await http.get(Uri.parse('https://your-django-api-endpoint.com/reviews/$_selectedMenuId/'));

    if (response.statusCode == 200) {
      setState(() {
        reviews = reviewFromJson(response.body);  // Parse JSON into Review objects
      });
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Steak Reviews',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: menus.isEmpty
          ? Center(child: CircularProgressIndicator())  // Show loading indicator if menus are still fetching
          : ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(menu.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Menu: ${menu.name}'),
                        ElevatedButton(
                          onPressed: () {
                            _showAddReviewDialog(menu.id);  // Open dialog for adding review
                          },
                          child: Text("Add Review"),
                        ),
                        // Display reviews related to this menu (optional)
                        ...reviews.map((review) {
                          return ListTile(
                            title: Text(review.description),
                            subtitle: Text('Rating: ${review.rating}'),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Show Add Review Dialog
  void _showAddReviewDialog(int menuId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Review"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown for selecting menu
              DropdownButton<int>(
                value: _selectedMenuId,
                hint: Text('Select Menu'),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedMenuId = newValue;
                  });
                },
                items: menus.map<DropdownMenuItem<int>>((Menu menu) {
                  return DropdownMenuItem<int>(
                    value: menu.id,
                    child: Text(menu.name),
                  );
                }).toList(),
              ),
              TextField(
                controller: _placeController,
                decoration: InputDecoration(labelText: 'Place'),
              ),
              TextField(
                controller: _ratingController,
                decoration: InputDecoration(labelText: 'Rating (1-5)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                addReview();  // Submit the review for the selected menu
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
