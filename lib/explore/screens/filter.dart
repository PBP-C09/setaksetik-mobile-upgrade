import 'package:flutter/material.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

// Class untuk filter
class Filter extends StatefulWidget {
  final Function(String?, City?, String?, int?) onFilter;

  const Filter({Key? key, required this.onFilter}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

// State untuk filter
class _FilterState extends State<Filter> {
  final _formKey = GlobalKey<FormState>();
  City? selectedCity;
  String? selectedCategory;
  String? maxPrice;

  // List kategori
  final List<String> categories = [
    'Beef', 'Chicken', 'Fish', 'Lamb', 'Pork',
    'Rib Eye', 'Sirloin', 'T-Bone', 'Tenderloin',
    'Wagyu', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5DC),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      // Form untuk filter
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
            child: Text(
              "Filter",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5B3E39),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // City Dropdown
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<City>(
              value: selectedCity,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: City.values.map((City city) {
                return DropdownMenuItem<City>(
                  value: city,
                  child: Text(city.name),
                );
              }).toList(),
              onChanged: (City? newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          
            // Category Dropdown
            Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

            // Price TextField
            Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Maximum Price',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              onChanged: (value) {
                maxPrice = value;
              },
            ),
          ),
          const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onFilter(
                      null,
                      selectedCity,
                      selectedCategory,
                      int.tryParse(maxPrice ?? ''),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B3E39),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply Filter',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}