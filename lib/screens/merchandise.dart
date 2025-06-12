import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import '../models/user_model.dart';
import '../utils/shared_prefs.dart';

class MerchandisePage extends StatefulWidget {
  const MerchandisePage({super.key});

  @override
  State<MerchandisePage> createState() => _MerchandisePageState();
}

class _MerchandisePageState extends State<MerchandisePage> {
  List<dynamic> merchandises = [];
  User? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserAndMerchandise();
  }


  Future<void> loadUserAndMerchandise() async {
    final loadedUser = SharedPrefsUtil.getUser();
    final response = await http.get(Uri.parse(Api.merchandise));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        user = loadedUser;
        merchandises = data;
        _isLoading = false;
      });
      // final List<dynamic> data1 = jsonDecode(response.body);
      // print('Decoded Data: $data1'); // tampilkan data setelah decoding
      
      // for (var item in data1) {
      //   print('Nama Merchandise: ${item['nama']}');
      // }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
Future<void> claimMerchandise(String id, int requiredPoints) async {
  if (user == null || (user!.points ?? 0) < requiredPoints) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Poin tidak cukup untuk klaim.")),
    );
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Konfirmasi Penukaran"),
      content: Text("Apakah Anda yakin ingin menukar $requiredPoints poin untuk merchandise ini?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Ya, Klaim"),
        ),
      ],
    ),
  );

  if (confirmed != true) return;
  final response = await http.post(
    Uri.parse('${Api.baseUrl}/claim-merchandise'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'id_pembeli': user!.id,
      'id_merchandise': id,
    }),
  );

  final resData = jsonDecode(response.body);

  if (response.statusCode == 200 && resData['success'] == true) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Klaim berhasil, silakan ambil di CS!")),
    );
    loadUserAndMerchandise();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resData['message'] ?? 'Gagal klaim merchandise.')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    
    return RefreshIndicator(
      onRefresh: loadUserAndMerchandise,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : merchandises.isEmpty
          ? const Center(child: Text('Tidak ada merchandise tersedia.'))
          : ListView.builder(
              itemCount: merchandises.length,
              itemBuilder: (context, index) {
                final item = merchandises[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${Api.baseUrlnon}/storage/${item['gambar']}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => const Icon(Icons.broken_image),
                      ),
                    ),

                    title: Text(item['nama']),
                    subtitle: Text("Poin: ${item['poin']} Stok: ${item['stok']}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        claimMerchandise(item['id_merchandise'].toString(), item['poin']);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE9C8CE),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Tukar"),
                    ),
                  ),
                );
              },
            ),
    );
    
  }
}
