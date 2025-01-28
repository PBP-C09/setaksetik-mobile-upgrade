import 'package:flutter/material.dart';
import 'package:setaksetikmobile/spinthewheel/screens/free/secret_wheel_tab.dart';
import 'package:setaksetikmobile/spinthewheel/screens/free/secret_history_tab.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

class SecretPage extends StatefulWidget {
  const SecretPage({super.key});

  @override
  _SecretPageState createState() => _SecretPageState();
}

class _SecretPageState extends State<SecretPage> with SingleTickerProviderStateMixin {
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
        title: const Text('Wheel of Free Will'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Wheel',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Spin History',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: LeftDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SecretWheelTab(),
          SecretHistoryTab()
        ],
      ),
    );
  }
}