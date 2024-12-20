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
  final TextEditingController _noteController = TextEditingController();
  bool _buttonsEnabled = false;

  final List<FortuneItem> _wheelItems = [
    FortuneItem(child: const Text("Start Adding Items!"))
  ];
  List<int> _menuInWheel = [];
  List<MenuList> _menuOptions = [];
  List<MenuList> _allMenu = [];
  List<bool> _isAddedList = List.generate(106, (index) => false);

  String _selectedCategory = "All Categories";
  MenuList? _selectedItem;
  String? _selectedMenuName;

  @override
  void dispose() {
    _controller.close();
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      _fetchMenuOptions(request, _selectedCategory);
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _buttonsEnabled = true;
        _allMenu = List.from(_menuOptions);
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
                onPressed: _buttonsEnabled ? () => _spinWheel(request) : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Spin',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFF5F5DC),
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(width: 20),
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
            color: const Color(0xFF3E2723),
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              underline: const SizedBox(),
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
              onChanged: _buttonsEnabled
                ? (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                      _fetchMenuOptions(request, newValue);
                    }
                  }
                : null,
              hint: const Text("All Categories"),
              dropdownColor: const Color(0xFF3E2723),
              icon: const Icon(Icons.arrow_drop_down),
              iconEnabledColor: const Color(0xFFF5F5DC),
              iconDisabledColor: const Color(0xFF3E2723),
              style: TextStyle(
                      fontFamily: 'Raleway',
                      color: const Color(0xFFF5F5DC),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
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
                return _buildOptionRow(menu.fields.menu, index, menu.pk);
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

  Widget _buildOptionRow(String menuName, int optionIndex, int menuIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
        color: const Color(0xFFF5F5DC),
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                menuName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _isAddedList[menuIndex] || !_buttonsEnabled ? null : () {
                _addOptionToWheel(menuName, menuIndex);
                setState(() {
                  _isAddedList[menuIndex] = true;
                });
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  color: Color(0xFF3E2723),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway',
                ),
                backgroundColor: Color(0xFFFFD54F),
                disabledBackgroundColor: const Color.fromARGB(255, 206, 188, 126),
                disabledForegroundColor: Color.fromARGB(255, 128, 106, 102),
              ),
              child: _isAddedList[menuIndex] 
                  ? const Text(
                      'Added',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: Color(0xFF3E2723),
                      ),
                    )
                  : const Text(
                      'Add',
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _addOptionToWheel(String option, int menuIndex) {
    setState(() {
      if (_wheelItems.length == 1 &&
          _wheelItems[0].child is Text &&
          (_wheelItems[0].child as Text).data == "Start Adding Items!") {
        _wheelItems.clear();
      }

      bool exists = _wheelItems.any((item) => 
        item.child is Text && (item.child as Text).data == option);

      if (!exists) {
        _wheelItems.add(FortuneItem(child: Text(option)));
        _menuInWheel.add(menuIndex);
      }
    });
  }

  void _spinWheel(CookieRequest request) {
    if (_wheelItems.length > 1) {
      final int selectedIndex =
          DateTime.now().millisecondsSinceEpoch % _wheelItems.length;

      _controller.add(selectedIndex);

      setState(() {
        _buttonsEnabled = false;
      });

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _selectedItem = _allMenu[_menuInWheel[selectedIndex]-1];
          _selectedMenuName = _selectedItem?.fields.menu;
          _buttonsEnabled = true;
        });
        _showResultDialog(request, _selectedMenuName!, _selectedItem!); 
      });
    }

    else {
      ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                  backgroundColor: Color(0xFF3E2723),
                                  content:
                                      Text("Please add at least two items to the wheel!")),
                            );
    }
  }

  void _clearWheel() {
    setState(() {
      _menuInWheel.clear();
      _wheelItems.clear();
      _wheelItems
          .add(FortuneItem(child: const Text("Start Adding Items!")));
      _isAddedList = List.generate(106, (index) => false);
    });
  }

  void _showResultDialog(CookieRequest request, String selectedMenuName, MenuList selectedMenu) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20.0),
          title: Center(
            child: Text(
              selectedMenuName,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: Color(0xFF3E2723),
                fontSize: 20.0,
              ),
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                color: Color(0xFF3E2723),
                height: 2,
                indent: 7,
                endIndent: 7,
              ),
              SizedBox(height: 12),
              Text(
                selectedMenu.fields.restaurantName,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                selectedMenu.fields.city.name,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Add a note (optional)',
                  hintStyle: TextStyle(
                        fontFamily: 'Raleway',
                        color: Color(0xFFF5F5DC),
                      ),
                  filled: true,
                  fillColor: Color(0xFF3E2723),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  fontFamily: 'Raleway',
                  color: Color(0xFFF5F5DC),
                ),
              ),
            ],
          ),

          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      final response = await request.postJson(
                        "http://127.0.0.1:8000/spinthewheel/add-spin-history-mobile/",
                        jsonEncode({
                          'winner': selectedMenuName,
                          'winnerId': selectedMenu.pk.toString(),
                          'note': _noteController.text
                        })
                      );
                      Navigator.of(context).pop();
                      _noteController.clear();
                    },
                    child: const Text("Add to history"),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _noteController.clear();
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
}
