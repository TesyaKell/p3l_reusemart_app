import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import '../utils/shared_prefs.dart';

class HistoryKomisiPage extends StatefulWidget {
  const HistoryKomisiPage({super.key});

  @override
  State<HistoryKomisiPage> createState() => _HistoryKomisiPageState();
}

class _HistoryKomisiPageState extends State<HistoryKomisiPage> {
  int totalKomisi = 0;
  List<dynamic> komisiList = [];

  @override
  void initState() {
    super.initState();
    fetchKomisi();
  }

  Future<void> fetchKomisi() async {
    final user = SharedPrefsUtil.getUser();
    final id = user?.id;

    if (id == null) return;

    final res = await http.get(Uri.parse('${Api.historyKomisi}/$id'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        totalKomisi = data['total_komisi'] ?? 0;
        komisiList = data['komisi'] ?? []; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Komisi'),
        backgroundColor: const Color(0xFFE9C8CE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: komisiList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Komisi: Rp $totalKomisi',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: komisiList.length,
                      itemBuilder: (context, index) {
                        final komisi = komisiList[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.monetization_on),
                            title: Text('Rp ${komisi['komisi_hunter']}'),
                            subtitle: Text('Barang: ${komisi['nama_barang']}'),
                            trailing: Text(komisi['tanggal']),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
