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
                "You don't have any spin history :(",
                style: TextStyle(
                  fontSize: 20, 
                  color: Color(0xFFF5F5DC),
                  fontFamily: 'Playfair Display',
                  fontStyle: FontStyle.italic
                  ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cardColor = (index % 2 == 0) ? const Color(0xFFFFD54F) : const Color(0xFFF5F5DC);
                final history = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0), // Add vertical space between cards
                  child:Card(
                    elevation: 4,
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${index + 1} | ${history.fields.winner}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Playfair Display',
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Divider(
                                color: Color(0xFF3E2723),
                                height: 2,
                                indent: 7,
                                endIndent: 7,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                history.fields.spinTime.toLocal().toString().split(' ')[0],

                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Note: ${history.fields.note.isEmpty ? '-' : history.fields.note}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // TODO: booking?
                              // ElevatedButton(
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
                              // TODO: detail?
                              // ElevatedButton(
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
                                  backgroundColor: const Color(0xFF842323),
                                ),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Color(0xFFF5F5DC),
                                    fontFamily: 'Playfair Display',
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
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
