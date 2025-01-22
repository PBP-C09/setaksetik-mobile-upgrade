import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/claim/screens/owned_restaurant.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

// Class untuk edit menu
class EditMenuOwnerPage extends StatefulWidget {
  final MenuList menuToEdit;
  const EditMenuOwnerPage({super.key, required this.menuToEdit});

  @override
  State<EditMenuOwnerPage> createState() => _EditMenuOwnerPageState();
}

class _EditMenuOwnerPageState extends State<EditMenuOwnerPage> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown Selections
  String? _selectedCategory;
  String? _selectedCity;
  String? _selectedSpecialized;

  // Text Input
  String _menuName = "";
  String _restaurantName = "";
  int _price = 0;
  double _rating = 0.0;
  String _imageUrl = "";
  bool _takeaway = false;
  bool _delivery = false;
  bool _outdoor = false;
  bool _smokingArea = false;
  bool _wifi = false;

  // Dropdown Choices
  final List<DropdownMenuItem<String>> categoryChoices = const [
    DropdownMenuItem(value: 'beef', child: Text('Beef')),
    DropdownMenuItem(value: 'chicken', child: Text('Chicken')),
    DropdownMenuItem(value: 'fish', child: Text('Fish')),
    DropdownMenuItem(value: 'lamb', child: Text('Lamb')),
    DropdownMenuItem(value: 'pork', child: Text('Pork')),
    DropdownMenuItem(value: 'rib eye', child: Text('Rib Eye')),
    DropdownMenuItem(value: 'sirloin', child: Text('Sirloin')),
    DropdownMenuItem(value: 't-bone', child: Text('T-Bone')),
    DropdownMenuItem(value: 'tenderloin', child: Text('Tenderloin')),
    DropdownMenuItem(value: 'wagyu', child: Text('Wagyu')),
    DropdownMenuItem(value: 'other', child: Text('Other')),
  ];

  final List<DropdownMenuItem<String>> cityChoices = const [
    DropdownMenuItem(value: 'Central Jakarta', child: Text('Central Jakarta')),
    DropdownMenuItem(value: 'East Jakarta', child: Text('East Jakarta')),
    DropdownMenuItem(value: 'North Jakarta', child: Text('North Jakarta')),
    DropdownMenuItem(value: 'South Jakarta', child: Text('South Jakarta')),
    DropdownMenuItem(value: 'West Jakarta', child: Text('West Jakarta')),
  ];

  final List<DropdownMenuItem<String>> specializedChoices = const [
    DropdownMenuItem(value: 'argentinian', child: Text('Argentinian')),
    DropdownMenuItem(value: 'brazilian', child: Text('Brazilian')),
    DropdownMenuItem(value: 'breakfast cafe', child: Text('Breakfast Cafe')),
    DropdownMenuItem(value: 'british', child: Text('British')),
    DropdownMenuItem(value: 'french', child: Text('French')),
    DropdownMenuItem(value: 'fushioned', child: Text('Fushioned')),
    DropdownMenuItem(value: 'italian', child: Text('Italian')),
    DropdownMenuItem(value: 'japanese', child: Text('Japanese')),
    DropdownMenuItem(value: 'local', child: Text('Local')),
    DropdownMenuItem(value: 'local westerned', child: Text('Local Westerned')),
    DropdownMenuItem(value: 'mexican', child: Text('Mexican')),
    DropdownMenuItem(value: 'western', child: Text('Western')),
    DropdownMenuItem(value: 'singaporean', child: Text('Singaporean')),
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill form dengan data yang ada
    _menuName = widget.menuToEdit.fields.menu;
    _restaurantName = widget.menuToEdit.fields.restaurantName;
    _selectedCategory = widget.menuToEdit.fields.category.toLowerCase();
    _selectedCity = widget.menuToEdit.fields.city.name;
    _selectedSpecialized = widget.menuToEdit.fields.specialized.toLowerCase();
    _price = widget.menuToEdit.fields.price;
    _rating = widget.menuToEdit.fields.rating;
    _imageUrl = widget.menuToEdit.fields.image;
    _takeaway = widget.menuToEdit.fields.takeaway;
    _delivery = widget.menuToEdit.fields.delivery;
    _outdoor = widget.menuToEdit.fields.outdoor;
    _smokingArea = widget.menuToEdit.fields.smokingArea;
    _wifi = widget.menuToEdit.fields.wifi;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
      appBar: AppBar(
        title: const Text('Edit Menu'),
      ),
      body: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, 
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Latar belakang form
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.brown.shade400, // Border cokelat
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
      
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Edit Menu",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4E342E),
                        fontFamily: 'Playfair Display', 
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.brown.shade300, thickness: 1.5),

                // Menu Name Input
                _buildTextField(
                  label: "Menu Name",
                  hint: "Menu name (max length: 50)",
                  onChanged: (value) => setState(() => _menuName = value),
                  validator: (value) =>
                    value == null || value.isEmpty ? "Nama menu tidak boleh kosong!" : null,
                ),

                // Restaurant Name Input
                _buildTextField(
                  label: "Restaurant",
                  hint: "Restaurant name (max length: 50)",
                  onChanged: (value) => setState(() => _restaurantName = value),
                  validator: (value) =>
                    value == null || value.isEmpty ? "Nama restoran tidak boleh kosong!" : null,
                ),

                // Dropdown for City
                _buildDropdown(
                  label: "City",
                  value: _selectedCity,
                  items: cityChoices,
                  onChanged: (value) => setState(() => _selectedCity = value),
                ),

                // Dropdown for Category
                _buildDropdown(
                  label: "Category",
                  value: _selectedCategory,
                  items: categoryChoices,
                  onChanged: (value) => setState(() => _selectedCategory = value),
                ),

                // Dropdown for Specialized
                _buildDropdown(
                  label: "Specialized",
                  value: _selectedSpecialized,
                  items: specializedChoices,
                  onChanged: (value) => setState(() => _selectedSpecialized = value),
                ),

                // Price Input
                _buildTextField(
                  label: "Price",
                  hint: "Add price (1000 - 1800000)",
                  isNumeric: true,
                  onChanged: (value) => setState(() => _price = int.tryParse(value) ?? 0),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Harga menu tidak boleh kosong!";
                    if (int.tryParse(value) == null) return "Harga harus berupa angka!";
                    if (_price < 1000 || _price > 1800000) {
                      return "Rating harus antara 1000 dan 1800000!";
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
                    if (value == null || value.isEmpty) return "Rating tidak boleh kosong!";
                    if (double.tryParse(value) == null) return "Harga harus berupa angka!";
                    double? rating = double.tryParse(value);
                    if (rating == null || rating < 0.0 || rating > 5.0) {
                      return "Rating harus antara 0.0 dan 5.0!";
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
                    value == null || value.isEmpty ? "Gambar menu tidak boleh kosong!" : null,
                ),

                // Checkboxes for Additional Features
                _buildCheckbox(
                  label: "Takeaway",
                  value: _takeaway,
                  onChanged: (value) => setState(() => _takeaway = value!),
                ),
                _buildCheckbox(
                  label: "Delivery",
                  value: _delivery,
                  onChanged: (value) => setState(() => _delivery = value!),
                ),
                _buildCheckbox(
                  label: "Outdoor Seating",
                  value: _outdoor,
                  onChanged: (value) => setState(() => _outdoor = value!),
                ),
                _buildCheckbox(
                  label: "Smoking Area",
                  value: _smokingArea,
                  onChanged: (value) => setState(() => _smokingArea = value!),
                ),
                _buildCheckbox(
                  label: "WiFi",
                  value: _wifi,
                  onChanged: (value) => setState(() => _wifi = value!),
                ),
                Column(
                    children: [
                      // Update Menu Button
                      SizedBox(
                        width: double.infinity,  // Membuat tombol selebar layar
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC62828),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await request.postJson(
                                "https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/claim/edit-flutter/${widget.menuToEdit.pk}/",
                                jsonEncode(<String, String>{
                                  "menu": _menuName,
                                  "category": _selectedCategory ?? "",
                                  "restaurant_name": _restaurantName,
                                  "city": _selectedCity ?? "",
                                  "price": _price.toString(),
                                  "rating": _rating.toString(),
                                  "specialized": _selectedSpecialized ?? "",
                                  "image": _imageUrl,
                                  "takeaway": _takeaway.toString(),
                                  "delivery": _delivery.toString(),
                                  "outdoor": _outdoor.toString(),
                                  "smoking_area": _smokingArea.toString(),
                                  "wifi": _wifi.toString(),
                                }),
                              );
                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                        backgroundColor: Color(0xFF3E2723),
                                        content:
                                            Text("Menu berhasil diupdate!")),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => OwnedRestaurantPage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("")),
                                  );
                                  ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                        backgroundColor: Color(0xFF3E2723),
                                        content:
                                            Text("Terdapat kesalahan, silakan coba lagi.")),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text(
                            "Update Menu",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  
                      const SizedBox(height: 12), 
                  
                      // Back to Menu List Button
                      SizedBox(
                        width: double.infinity,  
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3E2723),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget: TextField
  Widget _buildTextField({
    required String label,
    required String hint,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
    bool isNumeric = false,
  }) {
    String initialValue = '';
    switch (label) {
    case "Menu Name":
      initialValue = _menuName;
      break;
    case "Restaurant":
      initialValue = _restaurantName;
      break;
    case "Price":
      initialValue = _price.toString();
      break;
    case "Rating":
      initialValue = _rating.toString();
      break;
    case "Image URL":
      initialValue = _imageUrl;
      break;
  }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        initialValue: initialValue,
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
      validator: (value) => value == null || value.isEmpty ? "$label harus dipilih!" : null,
    ),
  );
}

Widget _buildCheckbox({
  required String label,
  required bool value,
  required void Function(bool?) onChanged,
}) {
  return CheckboxListTile(
    title: Text(label),
    value: value,
    onChanged: onChanged,
    controlAffinity: ListTileControlAffinity.leading,
    contentPadding: EdgeInsets.zero,
  );
}
