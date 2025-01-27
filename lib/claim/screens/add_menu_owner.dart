import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

// Class untuk menu form
class AddMenuOwner extends StatefulWidget {
  const AddMenuOwner({super.key});

  @override
  State<AddMenuOwner> createState() => _AddMenuOwnerState();
}

class _AddMenuOwnerState extends State<AddMenuOwner> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown Selections
  String? _selectedCategory;

  // Text Input
  String _menuName = "";
  String restaurantName = "";
  String restaurantCity = "";
  String restaurantSpecialized = "";
  int _price = 0;
  double _rating = 0.0;
  String _imageUrl = "";
  bool _takeaway = false;
  bool _delivery = false;
  bool _outdoor = false;
  bool _smokingArea = false;
  bool _wifi = false;

  // Dropdown
  final List<DropdownMenuItem<String>> categoryChoices = const [
    DropdownMenuItem(value: 'Beef', child: Text('Beef')),
    DropdownMenuItem(value: 'Chicken', child: Text('Chicken')),
    DropdownMenuItem(value: 'Fish', child: Text('Fish')),
    DropdownMenuItem(value: 'Lamb', child: Text('Lamb')),
    DropdownMenuItem(value: 'Pork', child: Text('Pork')),
    DropdownMenuItem(value: 'Rib Eye', child: Text('Rib Eye')),
    DropdownMenuItem(value: 'Sirloin', child: Text('Sirloin')),
    DropdownMenuItem(value: 'T-Bone', child: Text('T-Bone')),
    DropdownMenuItem(value: 'Tenderloin', child: Text('Tenderloin')),
    DropdownMenuItem(value: 'Wagyu', child: Text('Wagyu')),
    DropdownMenuItem(value: 'Other', child: Text('Other')),
  ];

  final List<DropdownMenuItem<String>> cityChoices = const [
    DropdownMenuItem(value: 'Central Jakarta', child: Text('Central Jakarta')),
    DropdownMenuItem(value: 'East Jakarta', child: Text('East Jakarta')),
    DropdownMenuItem(value: 'North Jakarta', child: Text('North Jakarta')),
    DropdownMenuItem(value: 'South Jakarta', child: Text('South Jakarta')),
    DropdownMenuItem(value: 'West Jakarta', child: Text('West Jakarta')),
  ];

  final List<DropdownMenuItem<String>> specializedChoices = const [
    DropdownMenuItem(value: 'Argentinian', child: Text('Argentinian')),
    DropdownMenuItem(value: 'Brazilian', child: Text('Brazilian')),
    DropdownMenuItem(value: 'Breakfast Cafe', child: Text('Breakfast Cafe')),
    DropdownMenuItem(value: 'British', child: Text('British')),
    DropdownMenuItem(value: 'French', child: Text('French')),
    DropdownMenuItem(value: 'Fushioned', child: Text('Fushioned')),
    DropdownMenuItem(value: 'Italian', child: Text('Italian')),
    DropdownMenuItem(value: 'Japanese', child: Text('Japanese')),
    DropdownMenuItem(value: 'Local', child: Text('Local')),
    DropdownMenuItem(value: 'Local Westerned', child: Text('Local Westerned')),
    DropdownMenuItem(value: 'Mexican', child: Text('Mexican')),
    DropdownMenuItem(value: 'Western', child: Text('Western')),
    DropdownMenuItem(value: 'Singaporean', child: Text('Singaporean')),
  ];

  @override
  void initState() {
    super.initState();
    // Ambil data restoran saat form dibuka
    fetchRestaurantData();
  }

  // Function untuk fetch data restoran
  Future<void> fetchRestaurantData() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/claim/owned_flutter/');
    
    if (response != null) {
      final menus = response['menus'] as List;
      final firstMenu = menus[0]['fields'];
      setState(() {
        restaurantName = firstMenu['restaurant_name'];
        restaurantCity = firstMenu['city'];
        restaurantSpecialized = firstMenu['specialized'];
        _takeaway = firstMenu['takeaway'] ?? false;
        _delivery = firstMenu['delivery'] ?? false;
        _outdoor = firstMenu['outdoor'] ?? false;
        _smokingArea = firstMenu['smoking_area'] ?? false;
        _wifi = firstMenu['wifi'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    // Scaffold untuk menampilkan form
    return Scaffold(
      backgroundColor: const Color(0xFF6D4C41),
      appBar: AppBar(
        title: const Text('Add Menu'),
        centerTitle: true,
      ),
      body: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Latar belakang kotak form
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.brown.shade400, // Warna border cokelat
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),

      // Form untuk menambahkan menu
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add New Menu",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4E342E),
                    fontFamily: 'Playfair Display', 
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.brown.shade300, thickness: 1.5), // Garis dekoratif

              // Menu Name Input
              const SizedBox(height: 16),
              _buildTextField(
                label: "Menu Name",
                hint: "Menu name (max length: 50)",
                onChanged: (value) => setState(() => _menuName = value),
                validator: (value) =>
                    value == null || value.isEmpty ? "Menu name cannot be empty!" : null,
              ),

              // Restaurant Name Input
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: restaurantName,
                  style: const TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                  labelText: "Restaurant: $restaurantName",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFFBDBDBD)), 
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  ),
                  enabled: false,
                ),
                ),

                // Dropdown for City
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: restaurantCity,
                  style: const TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                  labelText: "City: $restaurantCity",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFFBDBDBD)), 
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  ),
                  enabled: false,
                ),
                ),

                // Dropdown for Specialized
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: restaurantSpecialized,
                  style: const TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                  labelText: "Specialized: $restaurantSpecialized",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFFBDBDBD)), 
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  ),
                  enabled: false,
                ),
                ),

              // Dropdown for Category
              _buildDropdown(
                label: "Category",
                value: _selectedCategory,
                items: categoryChoices,
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),

              // Price Input
              _buildTextField(
                label: "Price",
                hint: "Add price (10000 - 1800000)",
                isNumeric: true,
                onChanged: (value) => setState(() => _price = int.tryParse(value) ?? 0),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Price cannot be empty!";
                  if (int.tryParse(value) == null) return "Price must be numbers!";
                  if (_price < 10000 || _price > 1800000) {
                    return "Price must be between 10000 and 1800000!";
                  }
                  return null;
                },
              ),

              // Rating Input
              _buildTextField(
                label: "Rating",
                hint: "Add rating (0.0 - 5.0)",
                isNumeric: true,
                onChanged: (value) {
                  setState(() {
                    _rating = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return "Rating cannot be empty!";
                  if (double.tryParse(value) == null) return "Rating must be number!";
                  double? rating = double.tryParse(value);
                  if (rating == null || rating < 0.0 || rating > 5.0) {
                    return "Rating must be between 0.0 and 5.0!";
                  }
                  return null;
                },
              ),

              // Image URL Input
              _buildTextField(
                label: "Image URL",
                hint: "Add image URL",
                onChanged: (value) => setState(() => _imageUrl = value),
                validator: (value) =>
                    value == null || value.isEmpty ? "Image URL cannot be empty!" : null,
              ),

              // Checkboxes for Additional Features
              const SizedBox(height: 16),
              Text(
                "Additional Features",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4E342E),
                ),
              ),
              _buildDisabledTextField(
                label: "Takeaway",
                value: _takeaway,
              ),
              _buildDisabledTextField(
                label: "Delivery",
                value: _delivery,
              ),
              _buildDisabledTextField(
                label: "Outdoor Seating",
                value: _outdoor,
              ),
              _buildDisabledTextField(
                label: "Smoking Area",
                value: _smokingArea,
              ),
              _buildDisabledTextField(
                label: "WiFi",
                value: _wifi,
              ),

              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBCAAA4),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    
                        const SizedBox(width: 16),
                        // Add Menu Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD54F), 
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Kirim data menu ke django
                              final response = await request.postJson(
                                "https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/claim/add-menu-flutter/",
                                jsonEncode(<String, String>{
                                  "menu": _menuName,
                                  "category": _selectedCategory ?? "",
                                  "restaurant_name": restaurantName,
                                  "city": restaurantCity,
                                  "price": _price.toString(),
                                  "rating": _rating.toString(),
                                  "specialized": restaurantSpecialized,
                                  "image": _imageUrl,
                                  "takeaway": _takeaway.toString(),
                                  "delivery": _delivery.toString(),
                                  "outdoor": _outdoor.toString(),
                                  "smoking_area": _smokingArea.toString(),
                                  "wifi": _wifi.toString(),
                                }),
                              );
                              // Tampilkan pesan sukses atau gagal
                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("New menu has been saved successfully!")),
                                  );
                                   Navigator.pop(context, true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("There was an error, please try again."),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text(
                            "Add Menu",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper Widget: Text Field
Widget _buildTextField({
  required String label,
  required String hint,
  required void Function(String) onChanged,
  required String? Function(String?) validator,
  bool isNumeric = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFFBDBDBD)), 
        borderRadius: BorderRadius.circular(8.0),
      ),
      
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
      validator: validator,
    ),
  );
}

// Helper Widget: Dropdown
Widget _buildDropdown({
  required String label,
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required void Function(String?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFBDBDBD)), 
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: (value) => value == null || value.isEmpty ? "$label must be selected!" : null,
    ),
  );
}

Widget _buildDisabledTextField({
  required String label,
  required bool value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di luar kotak
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
        Container(
          width: double.infinity,  
          height: 48,  
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Color(0xFFBDBDBD)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Value Yes/No di dalam kotak
          child: Text(
            value ? "Yes" : "No",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    ),
  );
}