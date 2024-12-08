import 'package:flutter/material.dart';
import 'package:setaksetikmobile/spinthewheel/models/spin_history.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SpinHistoryView extends StatefulWidget {
  const SpinHistoryView({super.key});

  @override
  State<SpinHistoryView> createState() => _SpinHistoryViewState();
}

class _SpinHistoryViewState extends State<SpinHistoryView> {
  late Future<List<SpinHistory>> spinHistoryFuture;

  @override
  void initState() {
    super.initState();
    spinHistoryFuture = _fetchSpinHistory(context.read<CookieRequest>());
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: FutureBuilder(
        future: spinHistoryFuture,
        builder: (context, AsyncSnapshot<List<SpinHistory>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Spin History Available :(',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3 / 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final history = snapshot.data![index];
                return Card(
                  elevation: 4,
                  color: const Color(0xFFF5F5DC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.fields.winner,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlayfairDisplay',
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Di-spin pada: ${history.fields.spinTime.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text('Note: ${history.fields.note.isEmpty ? '-' : history.fields.note}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ElevatedButton(
                            //   // TODO: tombol ke booking
                            //   onPressed: () {
                            //     Navigator.pushNamed(
                            //       context,
                            //       'http://127.0.0.1:8000/booking/form/${history.fields.winnerId}',
                            //     );
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: const Color(0xFFFFD54F),
                            //   ),
                            //   child: const Text(
                            //     'Book',
                            //     style: TextStyle(
                            //       fontFamily: 'Raleway',
                            //     ),
                            //   ),
                            // ),
                            // ElevatedButton(
                            //   // TODO: tombol ke detail
                            //   onPressed: () {
                            //     Navigator.pushNamed(
                            //       context,
                            //       'http://127.0.0.1:8000/explore/menu_detail/${history.fields.winnerId}',
                            //     );
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: const Color(0xFFFFD54F),
                            //   ),
                            //   child: const Text(
                            //     'Detail',
                            //     style: TextStyle(
                            //       fontFamily: 'Raleway',
                            //     ),
                            //   ),
                            // ),
                            ElevatedButton(
                              onPressed: () async {
                                _deleteSpinHistory(request, history.pk);
                                setState(() {
                                  spinHistoryFuture = _fetchSpinHistory(request);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFD54F),
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                ),
                              ),
                            ),
                          ],
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

  Future<List<SpinHistory>> _fetchSpinHistory(CookieRequest request) async {
    final response =
        await request.get('http://127.0.0.1:8000/spinthewheel/history-json/');
    var data = response;
    List<SpinHistory> listHistory = [];
    for (var d in data) {
      if (d != null) {
        listHistory.add(SpinHistory.fromJson(d));
      }
    }
    return listHistory;
  }

  _deleteSpinHistory(CookieRequest request, String pk) {
    request.get('http://127.0.0.1:8000/spinthewheel/delete/$pk');
    // Refresh the spin history list
    setState(() {
      spinHistoryFuture = _fetchSpinHistory(request);
    });
  }
}
