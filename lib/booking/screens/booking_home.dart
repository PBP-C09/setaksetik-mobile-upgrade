import 'package:flutter/material.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class BookingPage extends StatelessWidget {
  final List<MenuList> menuList;  // MenuList or whatever your model class is named

  const BookingPage({super.key, required this.menuList});  // Pass the menuList in the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Restaurant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const Center(
              child: Column(
                children: [
                  Text(
                    'Book a Restaurant',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6F4E37), // brown color
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Choose your favorite restaurant and make your reservation now!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6F4E37), // brown color
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu List Section (where the menu data is displayed)
            ListView.builder(
              shrinkWrap: true,  // Allows the list to take only the required space
              itemCount: menuList.length,  // Number of items in the list
              itemBuilder: (context, index) {
                final menuItem = menuList[index];  // Get the menu item at index
                final fields = menuItem.fields;  // Access the fields of the menu item
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      fields.image,  // Display the image from the menu data
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(fields.restaurantName),  // Restaurant name
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category: ${fields.category}"),  // Category
                        Text("Specialized: ${fields.specialized}"),  // Specialized food
                        Text("Price: \$${fields.price}"),  // Price
                        Text("Rating: ${fields.rating} stars"),  // Rating
                        Text("City: ${fields.city.toString().split('.').last}"),  // City (Enum value)
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark),
                      onPressed: () {
                        // Handle booking logic or navigate to booking details
                      },
                    ),
                  ),
                );
              },
            ),

            // Filter Section (your existing filter code here)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6F4E37),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Restaurants',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Additional filter UI components...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
