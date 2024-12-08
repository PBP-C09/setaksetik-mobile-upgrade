import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/spinthewheel/fortune_wheel/flutter_fortune_wheel.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class WheelView extends StatefulWidget {
  const WheelView({super.key});

  @override
  _WheelViewState createState() => _WheelViewState();
}

class _WheelViewState extends State<WheelView> {
  final StreamController<int> _controller = StreamController<int>();
  bool _buttonsEnabled = false;

  final List<FortuneItem> _wheelItems = [
    FortuneItem(child: const Text("Start Adding Items!"))
  ];
  List<int> _menuInWheel = [];
  List<MenuList> _menuOptions = [];

  String _selectedCategory = "All Categories";
  MenuList? _selectedItem;
  String? _selectedMenuName;

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
    // Delay the listener until the animation is complete
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _buttonsEnabled = true;
      });
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
            styleStrategy: AlternatingStyleStrategy(),
            selected: _controller.stream,
            items: _wheelItems,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the buttons horizontally
            children: [
              TextButton(
                onPressed: _buttonsEnabled ? _spinWheel : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Spin',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFF5F5DC), // Beige color for label
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(width: 20), // Add spacing between the buttons
              TextButton(
                onPressed: _buttonsEnabled ? _clearWheel : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFF5F5DC), // Beige color for label
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Container(
            color: const Color(0xFF3E2723), // Beige background
            width: 300, // Match the width of _buildOptionRow
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true, // Ensures the dropdown fills the container's width
              underline: const SizedBox(), // Removes the default underline
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
              dropdownColor: const Color(0xFF3E2723), // Beige for dropdown items
              style: TextStyle(
                      fontFamily: 'Raleway',
                      // fontWeight: FontWeight.w600,
                      color: const Color(0xFFF5F5DC),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
              icon: const Icon(Icons.arrow_drop_down), // Dropdown icon
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: _menuOptions.asMap().entries.map((entry) {
                int index = entry.key;
                var menu = entry.value;
                return _buildOptionRow(menu.fields.menu, index);
              }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchMenuOptions(CookieRequest request, String category) async {
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
  }

  Widget _buildOptionRow(String menuName, int menuIndex) {
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () =>  _buttonsEnabled ? _addOptionToWheel(menuName, menuIndex) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                textStyle: const TextStyle(color: Colors.black),
              ),
              child: const Text(
                'Add',
                style: TextStyle(fontFamily: 'Raleway'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addOptionToWheel(String option, int optionIndex) {
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
        _menuInWheel.add(optionIndex);
      }
    });
  }

  void _spinWheel() {
    if (_wheelItems.length > 1) {
      final int selectedIndex =
          DateTime.now().millisecondsSinceEpoch % _wheelItems.length;

      // Add the index to the stream
      _controller.add(selectedIndex);
      setState(() {
        _buttonsEnabled = false;
      });

      // Delay the listener until the animation is complete
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _selectedItem = _menuOptions[_menuInWheel[selectedIndex]];
          _selectedMenuName = _selectedItem?.fields.menu;
          _buttonsEnabled = true;
        });
        _showResultDialog(_selectedMenuName!, _selectedItem!); 
      });
    }
  }

  void _showResultDialog(String selectedMenuName, MenuList selectedMenu) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20.0),
          title: Center(
            child: Text(
              selectedMenuName,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2723),
                fontSize: 16.0,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Center(
              child: Text(
                selectedMenu.fields.restaurantName,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO: ADD TO SPIN HISTORAYYY
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add to history"),
                  ),
                  SizedBox(width: 10), // Add some space between buttons if needed
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close without adding"),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearWheel() {
    setState(() {
      _menuInWheel.clear();
      _wheelItems.clear();
      _wheelItems
          .add(FortuneItem(child: const Text("Start Adding Items!")));
    });
  }
}
