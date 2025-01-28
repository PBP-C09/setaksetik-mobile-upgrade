import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilter;

  const FilterWidget({Key? key, required this.onFilter}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String? selectedCity;
  bool takeaway = false;
  bool delivery = false;
  bool outdoor = false;
  bool wifi = false;

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
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              "Filter Restaurants",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B3E39),
              ),
            ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
              DropdownButtonFormField<String>(
                value: selectedCity,
                items: const [
                  DropdownMenuItem(value: 'Central Jakarta', child: Text('Central Jakarta')),
                  DropdownMenuItem(value: 'East Jakarta', child: Text('East Jakarta')),
                  DropdownMenuItem(value: 'North Jakarta', child: Text('North Jakarta')),
                  DropdownMenuItem(value: 'South Jakarta', child: Text('South Jakarta')),
                  DropdownMenuItem(value: 'West Jakarta', child: Text('West Jakarta')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'City', 
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Takeaway'),
            value: takeaway,
            onChanged: (value) {
              setState(() {
                takeaway = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Delivery'),
            value: delivery,
            onChanged: (value) {
              setState(() {
                delivery = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Outdoor'),
            value: outdoor,
            onChanged: (value) {
              setState(() {
                outdoor = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Wi-Fi'),
            value: wifi,
            onChanged: (value) {
              setState(() {
                wifi = value ?? false;
              });
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onFilter({
                  'city': selectedCity,
                  'takeaway': takeaway,
                  'delivery': delivery,
                  'outdoor': outdoor,
                  'wifi': wifi,
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B3E39),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Apply Filters'),
            ),
          )
        ],
      ),
    );
  }
}
