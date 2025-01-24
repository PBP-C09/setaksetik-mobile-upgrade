import 'package:flutter/material.dart';
import 'package:setaksetikmobile/booking/screens/resto_menu.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:setaksetikmobile/booking/screens/booking_form.dart';
import 'package:setaksetikmobile/review/screens/review_entry.dart';

class BookingDetailPage extends StatelessWidget {
  final MenuList menu;

  const BookingDetailPage({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Details'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF3E2723),
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
                    menu.fields.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      List<String> placeholderImages = [
                        "assets/images/placeholder-image-1.png",
                        "assets/images/placeholder-image-2.png",
                        "assets/images/placeholder-image-3.png",
                        "assets/images/placeholder-image-4.png",
                        "assets/images/placeholder-image-5.png",
                      ];
                      int index = menu.pk % placeholderImages.length;
                      return Image.asset(
                        placeholderImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  menu.fields.restaurantName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    fontFamily: 'Playfair Display',
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Favorite Menu: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        menu.fields.menu,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF3E2723),
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
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      menu.fields.city.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF3E2723),
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
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      menu.fields.specialized,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF3E2723),
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
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      '${menu.fields.rating}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF3E2723),
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
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 8),
                _buildBulletInfo('Takeaway', menu.fields.takeaway),
                const SizedBox(height: 4),
                _buildBulletInfo('Delivery', menu.fields.delivery),
                const SizedBox(height: 4),
                _buildBulletInfo('Outdoor Seating', menu.fields.outdoor),
                const SizedBox(height: 4),
                _buildBulletInfo('Smoking Area', menu.fields.smokingArea),
                const SizedBox(height: 4),
                _buildBulletInfo('WiFi', menu.fields.wifi),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingFormPage(
                                menuId: menu.pk,
                                restaurantName: menu.fields.restaurantName,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Booking',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF7B32B),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestoMenuPage(menuId: menu.pk),
                            ),
                          );
                        },
                        child: const Text(
                          'View Menu',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E2723),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Back to Restaurant List',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
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
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Color(0xFF842323),
          size: 20.0,
        ),
      ],
    );
  }
}
