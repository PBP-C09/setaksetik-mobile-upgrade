import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/spinthewheel/models/secret_history.dart';

class SecretHistoryTab extends StatefulWidget {
  const SecretHistoryTab({super.key});

  @override
  State<SecretHistoryTab> createState() => _SecretHistoryTabState();
}

class _SecretHistoryTabState extends State<SecretHistoryTab> {
  late Future<List<SecretHistory>> secretHistoryFuture;

  @override
  void initState() {
    super.initState();
    secretHistoryFuture = _fetchSecretHistory(context.read<CookieRequest>());
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFF6D4C41),
      body: FutureBuilder(
        future: secretHistoryFuture,
        builder: (context, AsyncSnapshot<List<SecretHistory>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "You don't have any secret history :(",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFF5F5DC),
                  fontFamily: 'Playfair Display',
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final history = snapshot.data![index];
                final isRed = index % 2 == 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    color: const Color(0xFFF5F5DC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '#${index + 1} | ${history.fields.winner}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Playfair Display',
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Spinned on: ${history.fields.spinTime.toLocal().toString().split(' ')[0]}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xFF3E2723),
                                    fontFamily: 'Raleway',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Note: ${history.fields.note.isEmpty ? '-' : history.fields.note}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Raleway',
                                    color: Color(0xFF3E2723),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          child: Container(
                            color: isRed
                                ? const Color(0xFF842323)
                                : const Color(0xFFFFD54F),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      _deleteSecretHistory(request, history.pk);
                                      setState(() {
                                        secretHistoryFuture = _fetchSecretHistory(request);
                                      });
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Color(0xFF3E2723),
                                            content: Text("Secret history deleted!"),
                                          ),
                                        );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16.0,
                                        color: isRed
                                            ? const Color(0xFFF5F5DC)
                                            : const Color(0xFF3E2723),
                                        fontFamily: 'Playfair Display',
                                      ),
                                    ),
                                  ),
                                ]
                              )
                            ),
                          ),
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

  Future<List<SecretHistory>> _fetchSecretHistory(CookieRequest request) async {
    final response =
        await request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/spinthewheel/secret-json/');
    var data = response;
    List<SecretHistory> listHistory = [];
    for (var d in data) {
      if (d != null) {
        listHistory.add(SecretHistory.fromJson(d));
      }
    }
    return listHistory;
  }

  _deleteSecretHistory(CookieRequest request, String pk) {
    request.get('https://haliza-nafiah-setaksetik.pbp.cs.ui.ac.id/spinthewheel/delete-secret/$pk');
    setState(() {
      secretHistoryFuture = _fetchSecretHistory(request);
    });
  }
}