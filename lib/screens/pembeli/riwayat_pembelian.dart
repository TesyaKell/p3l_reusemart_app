import 'package:flutter/material.dart';
import '../../models/Transaksi.dart';
import 'detail_transaksi_page.dart';
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
  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _futureTransaksi = fetchTransaksi();
  }

  Future<List<Transaksi>> fetchTransaksi({
    int? day,
    int? month,
    int? year,
  }) async {
    final token = await SharedPrefsUtil.getToken();
    // Build query parameters
    final queryParams = <String, String>{};
    if (day != null) queryParams['day'] = day.toString();
    if (month != null) queryParams['month'] = month.toString();
    if (year != null) queryParams['year'] = year.toString();

    final uri = Uri.parse(
      'http://192.168.1.20:8000/riwayat-transaksi',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
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

  void _applyFilter() {
    setState(() {
      _futureTransaksi = fetchTransaksi(
        day: _selectedDay,
        month: _selectedMonth,
        year: _selectedYear,
      );
    });
  }

  void _resetFilter() {
    setState(() {
      _selectedDay = null;
      _selectedMonth = null;
      _selectedYear = null;
      _futureTransaksi = fetchTransaksi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Transaksi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Day Dropdown
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Hari',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedDay,
                            items: [
                              const DropdownMenuItem<int>(
                                value: null,
                                child: Text('Semua'),
                              ),
                              ...List.generate(
                                31,
                                (index) => DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedDay = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Month Dropdown
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Bulan',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedMonth,
                            items: [
                              const DropdownMenuItem<int>(
                                value: null,
                                child: Text('Semua'),
                              ),
                              ...List.generate(
                                12,
                                (index) => DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedMonth = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Year Dropdown
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Tahun',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedYear,
                            items: [
                              const DropdownMenuItem<int>(
                                value: null,
                                child: Text('Semua'),
                              ),
                              ...List.generate(
                                5,
                                (index) => DropdownMenuItem<int>(
                                  value: DateTime.now().year - index,
                                  child: Text('${DateTime.now().year - index}'),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: _resetFilter,
                          child: const Text('Reset'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _applyFilter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Terapkan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Transaction List
          Expanded(
            child: FutureBuilder<List<Transaksi>>(
              future: _futureTransaksi,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Belum ada riwayat transaksi'),
                  );
                }

                final transaksiList = snapshot.data!;
                return ListView.builder(
                  itemCount: transaksiList.length,
                  itemBuilder: (context, index) {
                    final transaksi = transaksiList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: ListTile(
                        title: Text('No Nota: ${transaksi.noNota}'),
                        subtitle: Text(
                          'Tanggal: ${transaksi.tanggalPesan}\nStatus: ${transaksi.status}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
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
          ),
        ],
      ),
    );
  }
}
