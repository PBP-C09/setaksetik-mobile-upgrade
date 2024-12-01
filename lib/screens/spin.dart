import 'package:flutter/material.dart';

class SpinPage extends StatefulWidget {
  const SpinPage({super.key});

  @override
  _SpinPageState createState() => _SpinPageState();
}

class _SpinPageState extends State<SpinPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spin Page'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Wheel', 
                style: TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ), // Tab for Wheel View
            Tab(
              child: Text(
                'Spin History',
                style: TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ), // Tab for Spin History View
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WheelView(), // Wheel View
          HistoryView(), // Spin History View
        ],
      ),
    );
  }
}

class WheelView extends StatelessWidget {
  const WheelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for the Wheel (circle)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.brown, width: 4),
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),

          // Dropdown placeholder
          DropdownButton<String>(
            items: const [
              DropdownMenuItem(value: "All Categories", child: Text("All Categories")),
              DropdownMenuItem(value: "Sirloin", child: Text("Sirloin")),
              DropdownMenuItem(value: "Rib Eye", child: Text("Rib Eye")),
              DropdownMenuItem(value: "Lamb", child: Text("Lamb")),
            ],
            onChanged: (String? newValue) {
              // TODO: ajax option selected
            },
            hint: const Text("All Categories"),
          ),
          
          // Scrollable box with buttons
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildMenuRow("Menu-1"),
                  buildMenuRow("Menu-2"),
                  buildMenuRow("Menu-3"),
                  buildMenuRow("Menu-4"),
                  buildMenuRow("Menu-5"),
                  buildMenuRow("Menu-6"),
                  buildMenuRow("Menu-7"),
                  buildMenuRow("Menu-8"),
                  buildMenuRow("Menu-9"),
                  buildMenuRow("Menu-10"),
                  buildMenuRow("Menu-11"),
                  buildMenuRow("Menu-12"),
                  buildMenuRow("Menu-13"),
                  buildMenuRow("Menu-14"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuRow(String menuName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        color: Color(0xFFF5F5DC),
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            // Left column - Text
            Expanded(
              child: Text(
                menuName,
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Right column - ElevatedButton
            ElevatedButton(
              onPressed: () {
                // TODO: Add button
              },
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

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 2,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            color: const Color(0xFFF5F5DC),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Informasi Nama dan Tanggal
                  Text(
                    'Spin History ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Di-spin pada: 2024-02-25'),
                  // Baris tombol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Detail
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Detail button
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                        ),
                        child: const Text('Detail'),
                      ),
                      // Tombol Delete
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Delete button
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


}
