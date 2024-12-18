import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// import 'package:setaksetikmobile/review/models/menu.dart';
import 'package:setaksetikmobile/review/models/review.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'dart:convert';
// import 'models/review.dart';  // Review model
// import 'models/menu.dart';    // Menu model

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<MenuList> menus = [];  // Daftar menu yang di-fetch dari API

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    print("tes");
    fetchMenus(request);  // Panggil fungsi untuk fetch menu
  }

  //   @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final request = context.read<CookieRequest>();
  //     _fetchMenuOptions(request, _selectedCategory);
  //   });6

  // Fetch menus dari API Django
  Future<void> fetchMenus(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/explore/get_menu/');
      if (response != null) { // Pastikan response tidak null
        setState(() {
          menus = menuListFromJson(jsonEncode(response)); // Konversi JSON sesuai format
        });
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load menus');
    }
  }



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
      body: menus.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading state
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: menus.map((menu) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Image.network(menu.fields.image), // Menampilkan gambar
                        title: Text(menu.fields.restaurantName),
                        subtitle: Text(menu.fields.menu),
                        onTap: () {
                          // Menavigasi ke halaman form review dengan membawa menu yang dipilih
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddReviewPage(menu: menu),
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


//TODO: ini harus lebih diperhatikan lagi
class AddReviewPage extends StatelessWidget {
  final MenuList menu;

  const AddReviewPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final _placeController = TextEditingController();
    final _ratingController = TextEditingController();
    final _descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Your Review for ${menu.fields.menu}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _placeController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(
                labelText: 'Rating (1-5)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Kirim review ke API
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Review for ${menu.fields.menu} submitted!')),
                );
                // Lakukan proses penyimpanan review di API atau database
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 195, 181, 176)),
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}



  // Show Add Review Dialog
//   void _showAddReviewDialog(int menuId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Add New Review"),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Dropdown for selecting menu
//               DropdownButton<int>(
//                 value: _selectedMenuId,
//                 hint: Text('Select Menu'),
//                 onChanged: (int? newValue) {
//                   setState(() {
//                     _selectedMenuId = newValue;
//                   });
//                 },
//                 items: menus.map<DropdownMenuItem<int>>((MenuList menu) {
//                   return DropdownMenuItem<int>(
//                     value: menu.pk,
//                     child: Text("menu"),
//                   );
//                 }).toList(),
//               ),
//               TextField(
//                 controller: _placeController,
//                 decoration: InputDecoration(labelText: 'Place'),
//               ),
//               TextField(
//                 controller: _ratingController,
//                 decoration: InputDecoration(labelText: 'Rating (1-5)'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();  // Close the dialog
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 // addReview();  // Submit the review for the selected menu
//               },
//               child: Text("Submit"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
