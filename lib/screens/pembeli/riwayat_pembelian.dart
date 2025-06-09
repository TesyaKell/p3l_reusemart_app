import 'package:flutter/material.dart';
import '../../models/Transaksi.dart';
import 'detail_transaksi_page.dart'; // halaman detail
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/shared_prefs.dart';

class HistoryTransaksiPage extends StatefulWidget {
  const HistoryTransaksiPage({Key? key}) : super(key: key);

  @override
  State<HistoryTransaksiPage> createState() => _HistoryTransaksiPageState();
}

class _HistoryTransaksiPageState extends State<HistoryTransaksiPage> {
  late Future<List<Transaksi>> _futureTransaksi;

  @override
  void initState() {
    super.initState();
    _futureTransaksi = fetchTransaksi();
  }

  Future<List<Transaksi>> fetchTransaksi() async {
    final token = await SharedPrefsUtil.getToken();
    final response = await http.get(
      Uri.parse('http://192.168.1.52:8000/riwayat-transaksi'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['transaksiList'] as List;
      return list.map((json) => Transaksi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data transaksi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Transaksi>>(
        future: _futureTransaksi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada riwayat transaksi'));
          }

          final transaksiList = snapshot.data!;
          return ListView.builder(
            itemCount: transaksiList.length,
            itemBuilder: (context, index) {
              final transaksi = transaksiList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text('No Nota: ${transaksi.noNota}'),
                  subtitle: Text(
                    'Tanggal: ${transaksi.tanggalPesan}\nStatus: ${transaksi.status}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigasi ke halaman detail dengan data transaksi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailTransaksiPage(transaksi: transaksi),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
