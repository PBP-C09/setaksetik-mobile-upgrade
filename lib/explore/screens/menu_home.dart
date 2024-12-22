import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:setaksetikmobile/explore/screens/filter.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:setaksetikmobile/explore/screens/menu_detail.dart';

// Class untuk menampilkan halaman explore steak lover
class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<MenuList>> _menuFuture; // Menyimpan data menu yang akan diambil dari API
  final TextEditingController _searchController = TextEditingController();
  List<MenuList> _originalMenus = [];
  @override
  void initState() {
    super.initState();
    _menuFuture = fetchMenu(Provider.of<CookieRequest>(context, listen: false)); // Untuk mengambil data menu
  }
  @override
  void dispose() {
    // Membersihkan controller saat widget dihapus
    _searchController.dispose();
    super.dispose();
  }
  // Mengambil data menu dari backend API
  Future<List<MenuList>> fetchMenu(CookieRequest request) async {
    try {
      final response = await request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/explore/get_menu/');

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
      _originalMenus = listMenu; 
      return listMenu;
    } catch (e, stackTrace) {
      return []; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: const Text('Explore Steak Menus', softWrap: true,),
        centerTitle: true,
      ),
      drawer: LeftDrawer(),
      body: FutureBuilder<List<MenuList>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          // Search bar dan filter
          Widget searchAndFilterSection = Container(
            color: const Color(0xFF3E2723),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Makan apa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Playfair Display',
                    color: Color(0xFFF5F5DC),
                  ),
                ),
                Text(
                  'hari ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Playfair Display',
                    color: Color(0xFFF5F5DC),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Search Bar
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Cari menu',
                            hintStyle: const TextStyle(fontSize: 14),
                            prefixIcon: const Icon(Icons.search, size: 20),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _handleSearch('');
                              },
                            ),
                          ),
                          onSubmitted: _handleSearch,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Filter Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Tampilkan modal bottom sheet untuk filter
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
                              // Tampilkan filter
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
                    ),
                  ],
                )
              ],
            ),
          );
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching menu data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Tampilkan pesan jika data kosong
              return SingleChildScrollView(
              child: Column(
                children: [
                  searchAndFilterSection,
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.sentiment_dissatisfied,
                    size: 80,
                    color: Color(0xFFF5F5DC),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Menu yang kamu cari tidak ada',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFF5F5DC),
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                ],
              ),
            );          
          } else {
            // Tampilkan daftar menu
            final menus = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menus.length + 1, // +1 untuk search bar dan filter
              itemBuilder: (BuildContext context, int index) {
               // Tampilkan search bar dan filter di index 0
                if (index == 0) {
                  return Container(
                    color: const Color(0xFF3E2723),
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center( 
                          
                        ),
                        Text(
                  'Makan apa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Playfair Display',
                    color: Color(0xFFF5F5DC),
                  ),
                ),
                Text(
                  'hari ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Playfair Display',
                    color: Color(0xFFF5F5DC),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Search Bar
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextField(
                                  controller: _searchController, 
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Cari menu',
                                    hintStyle: const TextStyle(fontSize: 14),
                                    prefixIcon: const Icon(Icons.search, size: 20),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () {
                                        _searchController.clear();
                                        _handleSearch(''); // Panggil dengan string kosong untuk reset
                                      },
                                    ),
                                  ),
                                  onSubmitted: _handleSearch,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Filter Button
                            Expanded( 
                              flex: 2, 
                              child:
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
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  // Tampilkan menu
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image
                          AspectRatio(
                            aspectRatio: 2.0,
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.network(
                                menuList.fields.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  List<String> placeholderImages = [
                                    "assets/images/placeholder-image-1.png",
                                    "assets/images/placeholder-image-2.png",
                                    "assets/images/placeholder-image-3.png",
                                    "assets/images/placeholder-image-4.png",
                                    "assets/images/placeholder-image-5.png",
                                  ];

                                  int index = menuList.pk % placeholderImages.length;

                                  return Image.asset(
                                    placeholderImages[index],
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          // Menu description
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Menu name
                                Text(
                                  menuList.fields.menu,
                                  textAlign: TextAlign.center,
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
                                // Restaurant and city
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Color(0xFF3E2723),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        '${menuList.fields.restaurantName}, ${menuList.fields.city.name}',
                                        textAlign: TextAlign.center,
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
                                // Rating
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${menuList.fields.rating} / 5',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF3E2723),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Price
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.payments_outlined,
                                      size: 16,
                                      color: Color(0xFF3E2723),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Rp ${menuList.fields.price}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF3E2723),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Category and specialization
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        textAlign: TextAlign.center,
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
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // See details button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
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
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk menerapkan filter
  void _applyFilters(String? namaMenu, City? kota, String? jenisBeef, int? hargaMax) {
    setState(() {
      _menuFuture = Future.value(_originalMenus.where((menuList) {
        bool cityMatch = kota == null || menuList.fields.city == kota;
        bool categoryMatch = jenisBeef == null || menuList.fields.category.contains(jenisBeef);
        bool priceMatch = hargaMax == null || menuList.fields.price <= hargaMax;

        return cityMatch && categoryMatch && priceMatch;
      }).toList());
    });
  }

  // Fungsi untuk menghandle search
  void _handleSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        _menuFuture = Future.value(_originalMenus);
      });
    } else {
      setState(() {
        _menuFuture = Future.value(_originalMenus.where((menuList) {
          return menuList.fields.menu.toLowerCase().contains(value.toLowerCase());
        }).toList());
      });
    }
  }
}