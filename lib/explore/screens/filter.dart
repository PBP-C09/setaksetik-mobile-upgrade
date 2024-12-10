import 'package:flutter/material.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class Filter extends StatefulWidget {
  final Function(String?, City?, String?, int?) onFilter;

  const Filter({Key? key, required this.onFilter}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _formKey = GlobalKey<FormState>();
  String? namaMenu;
  City? kota;
  String? jenisBeef;
  int? hargaMax;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onFilter(namaMenu, kota, jenisBeef, hargaMax);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 4,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter Menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Menu',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff3992C6),
                  ),
                ),
              ),
              onSaved: (value) => namaMenu = value,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<City>(
              value: kota,
              items: City.values.map((city) {
                return DropdownMenuItem<City>(
                  value: city,
                  child: Text(city.name), // gunakan extension `name` pada enum
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'City',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff3992C6),
                  ),
                ),
              ),
              onChanged: (value) => setState(() => kota = value),
              onSaved: (value) => kota = value,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Type',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff3992C6),
                  ),
                ),
              ),
              onSaved: (value) => jenisBeef = value,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff3992C6),
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              onSaved: (value) => hargaMax = int.tryParse(value ?? ''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: MaterialButton(
                onPressed: _submitForm,
                color: const Color(0xff3992C6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
