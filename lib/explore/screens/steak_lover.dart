import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:setaksetikmobile/explore/screens/filter.dart';
import 'package:http/http.dart' as http;
import 'package:setaksetikmobile/explore/screens/menu_detail.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<MenuList> _allmenuLists;
  late List<MenuList> _filteredmenuLists;

  @override
  void initState() {
    super.initState();
    _allmenuLists = [];
    _filteredmenuLists = [];
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    // Ganti URL berikut dengan endpoint API dataset Anda
    var url = Uri.parse('http://127.0.0.1:8000/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      _allmenuLists =
          body.map((dynamic item) => MenuList.fromJson(item)).toList();
      _filteredmenuLists = List.from(_allmenuLists);
      setState(() {});
    } else {
      throw Exception('Failed to load menuLists');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Steak Lover Menu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                showDragHandle: true,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Filter(
                      onFilter: (namaMenu, kota, jenisBeef, hargaMax) {
                    _applyFilters(namaMenu, kota, jenisBeef, hargaMax);
                  });
                },
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: const Text(
              'FILTER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildmenuListGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildmenuListGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.70,
      ),
      itemCount: _filteredmenuLists.length,
      itemBuilder: (BuildContext context, int index) {
        MenuList menuList = _filteredmenuLists[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuDetailPage(menuList: menuList),
              ),
            );
          },
          child: Card(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.6,
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      menuList.fields.image,
                      fit: BoxFit.cover,
                      errorBuilder: ((context, error, stackTrace) {
                        return Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png",
                          width: 64,
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuList.fields.menu,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        menuList.fields.menu,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Place: ${menuList.fields.restaurantName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _applyFilters(
      String? namaMenu, City? kota, String? jenisBeef, int? hargaMax) {
    setState(() {
      _filteredmenuLists = _allmenuLists.where((menuList) {
        return (namaMenu == null ||
                menuList.fields.menu.contains(namaMenu)) &&
            (kota == null ||
                menuList.fields.city == kota) &&
            (jenisBeef == null ||
                menuList.fields.category.contains(jenisBeef)) &&
            (hargaMax == null || menuList.fields.price <= hargaMax);
      }).toList();
    });
  }
}
