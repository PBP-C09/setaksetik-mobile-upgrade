import 'package:flutter/material.dart';
import 'package:setaksetikmobile/explore/models/menu_entry.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Future<List<MenuList>> fetchMood(CookieRequest request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://127.0.0.1:8000/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object MenuList
    List<MenuList> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(MenuList.fromJson(d));
      }
    }
    return listProduct;
  }
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Entry List'),
      ),
      body: FutureBuilder(
        future: fetchMood(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data![index].fields.menu_name}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.kategori}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.harga}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.restaurant}"),
                       const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.kota}"),
                       const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.specialization}"),
                       const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.rate}"),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}