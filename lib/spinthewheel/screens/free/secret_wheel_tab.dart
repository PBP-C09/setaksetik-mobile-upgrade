import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/spinthewheel/fortune_wheel/flutter_fortune_wheel.dart';

class SecretWheelTab extends StatefulWidget {
  const SecretWheelTab({super.key});

  @override
  _SecretWheelTabState createState() => _SecretWheelTabState();
}

class _SecretWheelTabState extends State<SecretWheelTab> {
  final StreamController<int> _controller = StreamController<int>();
  final TextEditingController _noteController = TextEditingController();
  bool _buttonsEnabled = true;
  
  List<TextEditingController> _optionControllers = [];
  
  final List<FortuneItem> _wheelItems = [
    FortuneItem(child: const Text("Add options to start!"))
  ];

  @override
  void initState() {
    super.initState();
    _addNewOption();
  }

  @override
  void dispose() {
    _controller.close();
    _noteController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return SingleChildScrollView(
      child: Center(
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                  onPressed: _buttonsEnabled ? _clearOptions : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFF5F5DC),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView(
                      children: [
                        ..._optionControllers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final controller = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: 'Option ${index + 1}',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFFF5F5DC),
                                        fontFamily: 'Raleway',
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFF3E2723),
                                      border: OutlineInputBorder(),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFFF5F5DC),
                                      fontFamily: 'Raleway',
                                    ),
                                    onChanged: (value) => _updateWheel(),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Color(0xFFF5F5DC)),
                                  onPressed: _optionControllers.length > 1
                                      ? () => _removeOption(index)
                                      : null,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton.icon(
                    onPressed: _addNewOption,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Option'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD54F),
                      foregroundColor: const Color(0xFF3E2723),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
      _updateWheel();
    });
  }

  void _updateWheel() {
    final items = _optionControllers
        .map((controller) => controller.text)
        .where((text) => text.trim().isNotEmpty)
        .toList();

    setState(() {
      _wheelItems.clear();
      if (items.isEmpty) {
        _wheelItems.add(FortuneItem(child: const Text("Add options to start!")));
      } else {
        for (var item in items) {
          _wheelItems.add(FortuneItem(
            child: Text(item),
          ));
        }
      }
    });
  }

  void _clearOptions() {
    setState(() {
      // Dispose all current controllers
      for (var controller in _optionControllers) {
        controller.dispose();
      }
      _optionControllers.clear();
      // Add one empty option
      _addNewOption();
      _updateWheel();
    });
  }

  void _spinWheel(CookieRequest request) {
    if (_wheelItems.length > 1 || (_wheelItems.length == 1 && _wheelItems[0].child is Text && 
        (_wheelItems[0].child as Text).data != "Enter items to start!")) {
      final int selectedIndex =
          DateTime.now().millisecondsSinceEpoch % _wheelItems.length;

      _controller.add(selectedIndex);

      setState(() {
        _buttonsEnabled = false;
      });

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _buttonsEnabled = true;
        });
        
        String selectedItem = "";
        if (_wheelItems[selectedIndex].child is Text) {
          selectedItem = (_wheelItems[selectedIndex].child as Text).data ?? "";
        }
        
        if (selectedItem.isNotEmpty) {
          _showResultDialog(request, selectedItem);
        }
      });
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF3E2723),
            content: Text("Please add at least one item to the wheel!"),
          ),
        );
    }
  }

  void _showResultDialog(CookieRequest request, String selectedItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20.0),
          title: Center(
            child: Text(
              selectedItem,
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: Color(0xFF3E2723),
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(
                color: Color(0xFF3E2723),
                height: 2,
                indent: 7,
                endIndent: 7,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Add a note (optional)',
                  hintStyle: TextStyle(
                    fontFamily: 'Raleway',
                    color: Color(0xFFF5F5DC),
                  ),
                  filled: true,
                  fillColor: Color(0xFF3E2723),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  color: Color(0xFFF5F5DC),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
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
                      await request.postJson(
                        "https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/spinthewheel/add-secret-history-mobile/",
                        jsonEncode({
                          'winner': selectedItem,
                          'note': _noteController.text
                        })
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFF3E2723),
                            content: Text("Added to secret history!"),
                          ),
                        );
                      Navigator.of(context).pop();
                      _noteController.clear();
                    },
                    child: const Text("Add to history"),
                  ),
                  const SizedBox(width: 10),
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