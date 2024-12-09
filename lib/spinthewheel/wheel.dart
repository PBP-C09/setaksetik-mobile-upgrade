import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'fortune_wheel/flutter_fortune_wheel.dart';

class WheelView extends StatefulWidget {
  const WheelView({super.key});

  @override
  _WheelViewState createState() => _WheelViewState();
}

class _WheelViewState extends State<WheelView> {
  final StreamController<int> _controller = StreamController<int>();
  final List<FortuneItem> _wheelItems = [FortuneItem(child: const Text("Start Adding Items!"))];
  List<String> _menuOptions = [];
  String _selectedCategory = "All Categories";

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          FortuneBar(
            selected: _controller.stream,
            items: _wheelItems,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _spinWheel,
            child: const Text('Spin'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _clearWheel,
            child: const Text('Clear'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _selectedCategory,
            items: const [
              DropdownMenuItem(value: "All Categories", child: Text("All Categories")),
              DropdownMenuItem(value: "sirloin", child: Text("Sirloin")),
              DropdownMenuItem(value: "rib Eye", child: Text("Rib Eye")),
              DropdownMenuItem(value: "lamb", child: Text("Lamb")),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCategory = newValue;
                });
                _fetchMenuOptions(newValue);
              }
            },
            hint: const Text("All Categories"),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                // children: _menuOptions.map((menu) => buildMenuRow(menu)).toList(),
                children: [
                  buildMenuRow("1"),
                  buildMenuRow("2"),
                  buildMenuRow("3"),
                  buildMenuRow("4"),
                  ]
              ),
            ),
          ),
          
        ],
      ),
    );
  }


  Future<void> _fetchMenuOptions(String category) async {
    final url = category == "All Categories"
        ? 'http://127.0.0.1:8000/option-json/'
        : 'http://127.0.0.1:8000/option-json/$category/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _menuOptions = data.map((item) => item['fields']['menu'].toString()).toList();
        });
      } else {
        setState(() {
          _menuOptions = [];
        });
      }
    } catch (e) {
      setState(() {
        _menuOptions = [];
      });
    }
  }

  void _addOptionToWheel(String option) {
    setState(() {
      // Remove the placeholder if it's the only item
      if (_wheelItems.length == 1 && _wheelItems[0].child is Text && (_wheelItems[0].child as Text).data == "Start Adding Items!") {
        _wheelItems.clear();
      }
      _wheelItems.add(FortuneItem(child: Text(option)));
    });
  }

  void _spinWheel() {
    if (_wheelItems.length != 1) {
      final int randomIndex = DateTime.now().millisecondsSinceEpoch % _wheelItems.length;
      _controller.add(randomIndex);
    }
  }

  void _clearWheel() {
    setState(() {
      _wheelItems.clear();
      _wheelItems.add(FortuneItem(child: const Text("Start Adding Items!")));
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMenuOptions(_selectedCategory);
  }

  
  Widget buildMenuRow(String menuName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
        color: const Color(0xFFF5F5DC),
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                menuName,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => _addOptionToWheel(menuName),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                textStyle: const TextStyle(color: Colors.black),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
