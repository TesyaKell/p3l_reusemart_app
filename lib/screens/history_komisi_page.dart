import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:p3l_reusemart/utils/garansi_utils.dart';
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
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  @override
  void initState() {
    super.initState();
    fetchKomisi();
  }

  Future<void> fetchKomisi() async {
    final user = SharedPrefsUtil.getUser();
    final id = user?.originalData['id_pegawai'];
    print('id: ${id}');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: komisiList.isEmpty
            ? const Center(child: 
            CircularProgressIndicator()
            // const Text('ga ada komisi')
            )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Komisi: ${currencyFormatter.format(totalKomisi)}',
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
                          title: Text('${currencyFormatter.format(komisi['komisi_hunter'])}'),
                          subtitle: Text('Barang: ${komisi['nama_barang']}'),
                          trailing: Text(komisi['tanggal']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailKomisiPage(komisi: komisi),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
class DetailKomisiPage extends StatelessWidget {
  final Map<String, dynamic> komisi;

  DetailKomisiPage({required this.komisi});

  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final List<dynamic> fotoList = komisi['foto'] ?? [];
    final warna = getWarrantyColor(komisi['garansi'].toString());
    final label = getWarrantyStatus(komisi['batas_garansi']);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Komisi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Nama Barang: ${komisi['nama_barang'] ?? '-'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Nomor Nota: ${komisi['no_nota'] ?? '-'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Komisi Hunter: ${currencyFormatter.format(komisi['komisi_hunter'])}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Batas Garansi: ${komisi['batas_garansi'] ?? '-'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [

                  const Text('Garansi: ', style: const TextStyle(fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: warna,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$label',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Status: ${komisi['status'] ?? '-'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              if (fotoList.isNotEmpty) ...[
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: fotoList.map<Widget>((fotoUrl) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fotoUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}