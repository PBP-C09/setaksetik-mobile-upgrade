import 'package:flutter/material.dart';
import 'package:setaksetikmobile/spinthewheel/screens/wheel_screen.dart';
import 'package:setaksetikmobile/spinthewheel/screens/history_screen.dart';
import 'package:setaksetikmobile/widgets/left_drawer.dart';

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
        title: const Text('Spin the Wheel'),
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
          WheelView(), // Wheel Screen
          SpinHistoryView(), // Spin History Screen
        ],
      ),
    );
  }
}
