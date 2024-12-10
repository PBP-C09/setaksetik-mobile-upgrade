import 'package:flutter/material.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Restaurant'),
      ),
      drawer: LeftDrawer(),
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

            // Filter Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6F4E37), // brown color
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
                  // Checkboxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      FilterChip(label: 'Takeaway'),
                      FilterChip(label: 'Delivery'),
                      FilterChip(label: 'Outdoor'),
                      FilterChip(label: 'Wi-Fi'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // City Filter Dropdown
                  const Text(
                    'City:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: 'All Cities', // Default selected value
                    items: [
                      'All Cities',
                      'Central Jakarta',
                      'East Jakarta',
                      'North Jakarta',
                      'South Jakarta',
                      'West Jakarta',
                    ]
                        .map((city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),

                  // Filter Button
                  Center(
                    child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107), // yellow color
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Filter'),
                  )
                  ,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Menu Grid Display
            const Text(
              'Restaurant Menus',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: 6, // For now, set a static value for grid items
              itemBuilder: (context, index) {
                return RestaurantCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  final String label;

  const FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.yellow.shade500,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/restaurant_image.jpg', // Use an image asset or network image
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Restaurant Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6F4E37), // brown color
                  ),
                ),
                Text('Category: Italian'),
                Text('Price: \$30'),
                Text('City: Central Jakarta'),
                Text('Rating: 4.5'),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107), // yellow color
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Select Restaurant'),
          ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: BookingPage(),
  ));
}