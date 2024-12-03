import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'fortune_wheel/flutter_fortune_wheel.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class WheelView extends StatefulWidget {
  const WheelView({super.key});

  @override
  _WheelViewState createState() => _WheelViewState();
}

class _WheelViewState extends State<WheelView> {
  final StreamController<int> _controller = StreamController<int>();
  final List<FortuneItem> _wheelItems = [
    FortuneItem(child: const Text("Start Adding Items!"))
  ];
  List<MenuList> _menuOptions = [];
  String _selectedCategory = "All Categories";

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      _fetchMenuOptions(request, _selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text('Spin'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _clearWheel,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text('Clear'),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _selectedCategory,
            items: const [
              DropdownMenuItem(
                value: "All Categories",
                child: Text("All Categories"),
              ),
              DropdownMenuItem(value: "Beef", child: Text("Beef")),
              DropdownMenuItem(value: "Chicken", child: Text("Chicken")),
              DropdownMenuItem(value: "Fish", child: Text("Fish")),
              DropdownMenuItem(value: "Lamb", child: Text("Lamb")),
              DropdownMenuItem(value: "Pork", child: Text("Pork")),
              DropdownMenuItem(value: "Rib Eye", child: Text("Rib Eye")),
              DropdownMenuItem(value: "Sirloin", child: Text("Sirloin")),
              DropdownMenuItem(value: "T-Bone", child: Text("T-Bone")),
              DropdownMenuItem(value: "Tenderloin", child: Text("Tenderloin")),
              DropdownMenuItem(value: "Wagyu", child: Text("Wagyu")),
              DropdownMenuItem(value: "Other", child: Text("Other")),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCategory = newValue;
                });
                _fetchMenuOptions(request, newValue);
              }
            },
            hint: const Text("All Categories"),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: _menuOptions.map((menu) {
                  return buildMenuRow(menu.fields.menu);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchMenuOptions(CookieRequest request, String category) async {
    try {
      final response = await request.get(
          'http://127.0.0.1:8000/spinthewheel/option-json/$category/');
      var data = response;

      setState(() {
        _menuOptions.clear();
        for (var option in data) {
          if (option != null) {
            _menuOptions.add(MenuList.fromJson(option));
          }
        }
      });
    } catch (error) {
      print("Error fetching menu options: $error");
    }
  }

  void _addOptionToWheel(String option) {
    setState(() {
      // Remove the placeholder if it's the only item
      if (_wheelItems.length == 1 &&
          _wheelItems[0].child is Text &&
          (_wheelItems[0].child as Text).data == "Start Adding Items!") {
        _wheelItems.clear();
      }

      bool exists = _wheelItems.any((item) => 
        item.child is Text && (item.child as Text).data == option);

      if (!exists) {
        _wheelItems.add(FortuneItem(child: Text(option)));
      }
    });
  }

  void _spinWheel() {
    if (_wheelItems.length > 1) {
      final int randomIndex =
          DateTime.now().millisecondsSinceEpoch % _wheelItems.length;
      _controller.add(randomIndex);
    }
  }

  void _clearWheel() {
    setState(() {
      _wheelItems.clear();
      _wheelItems
          .add(FortuneItem(child: const Text("Start Adding Items!")));
    });
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
