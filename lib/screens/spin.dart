import 'package:flutter/material.dart';
import 'package:setaksetikmobile/spinthewheel/wheel.dart';
import 'package:setaksetikmobile/spinthewheel/spin_history.dart';

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
