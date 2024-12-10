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
    print('Raw JSON Response: $response');
    
    if (response == null) {
      print('Response is null');
      return [];
    }

    List<MenuList> listMenu = [];
    for (var d in response) {
      try {
        if (d != null) {
          final menu = MenuList.fromJson(d);
          listMenu.add(menu);
          print('Successfully parsed menu: ${menu.fields.menu}');
        }
      } catch (e, stackTrace) {
        print('Error parsing menu item: $e');
        print('Stack trace: $stackTrace');  // Tambahkan stack trace untuk debugging
        // Lanjutkan ke item berikutnya alih-alih menghentikan seluruh proses
        continue;
      }
    }
    
    print('Successfully parsed ${listMenu.length} menu items');
    return listMenu;
    
  } catch (e, stackTrace) {
    print('Error fetching menu: $e');
    print('Stack trace: $stackTrace');
    return [];  // Return empty list instead of throwing
  }
}

  @override
  Widget build(BuildContext context) {
    print('Building MenuPage');
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
                    },
                  );
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
      drawer: LeftDrawer(),
      body: FutureBuilder<List<MenuList>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          print('Connection State: ${snapshot.connectionState}');
        print('Has Error: ${snapshot.hasError}');
        print('Error: ${snapshot.error}');
        print('Has Data: ${snapshot.hasData}');
        print('Data Length: ${snapshot.data?.length}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching menu data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu available.'));
          } else {
            final menus = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.70,
              ),
              itemCount: menus.length,
              itemBuilder: (BuildContext context, int index) {
                final menuList = menus[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MenuDetailPage(menuList: menuList),
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
        },
      ),
    );
  }

  void _applyFilters(
      String? namaMenu, City? kota, String? jenisBeef, int? hargaMax) {
    setState(() {
      _menuFuture = _menuFuture.then((menus) {
        return menus.where((menuList) {
          return (namaMenu == null ||
                  menuList.fields.menu.contains(namaMenu)) &&
              (kota == null || menuList.fields.city == kota) &&
              (jenisBeef == null ||
                  menuList.fields.category.contains(jenisBeef)) &&
              (hargaMax == null || menuList.fields.price <= hargaMax);
        }).toList();
      });
    });
  }
}
