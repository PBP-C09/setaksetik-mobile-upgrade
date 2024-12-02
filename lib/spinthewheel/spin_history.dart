import 'package:flutter/material.dart';

class SpinHistoryView extends StatelessWidget {
  const SpinHistoryView({super.key});

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
                  Text(
                    'Spin History ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Spun on: 2024-02-25'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Add details logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                        ),
                        child: const Text('Detail'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Add delete logic
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
