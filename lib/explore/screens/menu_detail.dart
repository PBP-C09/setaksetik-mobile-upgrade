import 'package:flutter/material.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class MenuDetailPage extends StatelessWidget {
  final MenuList menuList;

  const MenuDetailPage({required this.menuList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: const Color(0xFF3E2723)),
        title: const Text(
          'Detail Menu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: const Color(0xFF3E2723),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFF6D4C41),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: const Color(0xFFF5F5DC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    menuList.fields.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png",
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Menu Title
                Text(
                  menuList.fields.menu,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    fontFamily: 'Playfair Display',
                    color: const Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Text(
                      'Category: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      menuList.fields.category,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text(
                      'Price: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      'Rp ${menuList.fields.price}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text(
                      'Restaurant: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        menuList.fields.restaurantName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: const Color(0xFF3E2723),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text(
                      'City: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      menuList.fields.city.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text(
                      'Specialized in: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      menuList.fields.specialized,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text(
                      'Rating: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      '${menuList.fields.rating}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 8),
                
                _buildBulletInfo('Takeaway', menuList.fields.takeaway),
                const SizedBox(height: 4),
                _buildBulletInfo('Delivery', menuList.fields.delivery),
                const SizedBox(height: 4),
                _buildBulletInfo('Outdoor Seating', menuList.fields.outdoor),
                const SizedBox(height: 4),
                _buildBulletInfo('Smoking Area', menuList.fields.smokingArea),
                const SizedBox(height: 4),
                _buildBulletInfo('WiFi', menuList.fields.wifi),
                
                const SizedBox(height: 20),

                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E2723),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back to Menu List',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletInfo(String label, bool value) {
    return Row(
      children: [
        const Text(
          '• ',
          style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF3E2723),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3E2723),
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.red,
          size: 20.0,
        ),
      ],
    );
  }
}