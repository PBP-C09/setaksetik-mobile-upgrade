import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:setaksetikmobile/explore/screens/filter.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:setaksetikmobile/explore/screens/menu_detail.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<MenuList>> _menuFuture;

  @override
  void initState() {
    super.initState();
    _menuFuture = fetchMenu(Provider.of<CookieRequest>(context, listen: false));
  }

  Future<List<MenuList>> fetchMenu(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/explore/get_menu/');

      if (response == null) {
        return [];
      }

      List<MenuList> listMenu = [];
      for (var d in response) {
        try {
          if (d != null) {
            final menu = MenuList.fromJson(d);
            listMenu.add(menu);
          }
        } catch (e, stackTrace) {
          continue;
        }
      }

      return listMenu;
    } catch (e, stackTrace) {
      return []; // Return empty list instead of throwing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: const Text('Steak Menu'),
      ),
      drawer: LeftDrawer(),
      body: FutureBuilder<List<MenuList>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching menu data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu available.'));
          } else {
            final menus = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menus.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    color: const Color(0xFF3E2723),
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Makan apa Hari ini?",
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Playfair Display',
                            color: Color(0xFFF5F5DC),
                            //fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Search Bar
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Cari menu',
                                    hintStyle: const TextStyle(fontSize: 14),
                                    prefixIcon: const Icon(Icons.search, size: 20),
                                    isDense: true, 
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Filter Button
                            ElevatedButton.icon(
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
                                      },
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              icon: const Icon(Icons.tune, color: Colors.black),
                              label: const Text(
                                'Filter',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  final menuList = menus[index - 1];
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
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: const Color(0xFFF5F5DC),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 2.0,
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.network(
                                menuList.fields.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png",
                                    width: 200,
                                    height: 100,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menuList.fields.menu,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Playfair Display',
                                    color: Color(0xFF3E2723),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Color(0xFF3E2723),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${menuList.fields.restaurantName}, ${menuList.fields.city.name}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF3E2723),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFF3E2723),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${menuList.fields.rating} / 5',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF3E2723),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.payments_outlined,
                                      size: 16,
                                      color: Color(0xFF3E2723),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Rp ${menuList.fields.price}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF3E2723),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7B32B),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        menuList.fields.category,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7B32B),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        menuList.fields.specialized,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuDetailPage(menuList: menuList),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6D4C41),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    minimumSize: const Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'See Details',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
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
              },
            );
          }
        },
      ),
    );
  }

  void _applyFilters(String? namaMenu, City? kota, String? jenisBeef, int? hargaMax) {
    setState(() {
      _menuFuture = _menuFuture.then((menus) {
        return menus.where((menuList) {
          return (namaMenu == null || menuList.fields.menu.contains(namaMenu)) &&
              (kota == null || menuList.fields.city == kota) &&
              (jenisBeef == null || menuList.fields.category.contains(jenisBeef)) &&
              (hargaMax == null || menuList.fields.price <= hargaMax);
        }).toList();
      });
    });
  }
}
