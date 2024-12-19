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
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Filter Restaurants',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
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
            decoration: const InputDecoration(labelText: 'City'),
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
          ElevatedButton(
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
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
