import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:setaksetikmobile/explore/screens/filter.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';
import 'package:setaksetikmobile/explore/screens/admin_detail.dart';
import 'package:setaksetikmobile/explore/screens/menu_form.dart';
import 'package:setaksetikmobile/explore/screens/edit_menu_form.dart';

// Class menu untuk admin
class ExploreAdmin extends StatefulWidget {
  const ExploreAdmin({Key? key}) : super(key: key);

  @override
  State<ExploreAdmin> createState() => _ExploreAdminState();
}

class _ExploreAdminState extends State<ExploreAdmin> {
  late Future<List<MenuList>> _menuFuture;
  final TextEditingController _searchController = TextEditingController();
  List<MenuList> _originalMenus = [];
  @override
  void initState() {
    super.initState();
    _menuFuture = fetchMenu(Provider.of<CookieRequest>(context, listen: false));
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // Fungsi untuk mengambil data menu
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
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: const Text('Manage Menus'),
        centerTitle: true,
      ),
      drawer: LeftDrawer(),
      body: FutureBuilder<List<MenuList>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          Widget searchAndFilterSection = Container(
            color: const Color(0xFF3E2723),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 42,
                        fontFamily: 'Playfair Display',
                        color: Color(0xFFF5F5DC),
                      ),
                      children: const [
                        TextSpan(text: 'Menu '),
                        TextSpan(
                          text: 'Admin',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Search Bar
                Row(
                  children: [
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

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching menu data.'));
            // Untuk menu yang tidak ada saat pencarian
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center( 
                          child: RichText( 
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 42,
                                fontFamily: 'Playfair Display',
                                color: Color(0xFFF5F5DC),
                              ),
                              children: const [
                                TextSpan(text: 'Menu '),
                                TextSpan(
                                  text: 'Admin',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
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
                        ),
                        const SizedBox(height: 20), 

                        // Tombol Add Menu
                        SizedBox(
                          width: 160,
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MenuFormPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF842323), 
                              foregroundColor: Colors.white, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), 
                              ),
                            ),
                            icon: const Icon(Icons.add, color: Colors.white,),
                            label: const Text(
                              'Add Menu',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  // Tampilan menu
                } else {
                  final menuList = menus[index - 1];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminDetail(menuList: menuList),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: const Color(0xFFF5F5DC),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
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
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
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
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AdminDetail(menuList: menuList),
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
                          // Edit and Delete Buttons
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFD54F),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditMenuFormPage(menuToEdit: menuList),
                                        ),
                                      ).then((_) {
                                        setState(() {
                                          _menuFuture = fetchMenu(
                                            Provider.of<CookieRequest>(context, listen: false)
                                          );
                                        });
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width:8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF842323),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Menu'),
                                            content: const Text('Are you sure you want to delete this menu?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(color: Color(0xFF842323)),
                                                ),
                                                onPressed: () async {                  
                                                  _deleteMenu(request, menuList.pk);
                                                  setState(() {
                                                    _menuFuture = fetchMenu(request);
                                                  });
                                                  Navigator.pop(context);
                                                }         
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
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

  // Fungsi untuk menghapus menu
  _deleteMenu(CookieRequest request, int pk) {
    request.get('https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/explore/delete/$pk');
    setState(() {
      _menuFuture = fetchMenu(request);
    });
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

  // Fungsi untuk handle search
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
