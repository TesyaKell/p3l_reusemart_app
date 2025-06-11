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
  final user = SharedPrefsUtil.getUser();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMerchandise();
  }

  Future<void> loadMerchandise() async {
    
    final response = await http.get(Uri.parse(Api.merchandise));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        merchandises = data['merchandise'];
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> claimMerchandise(String id, int requiredPoints) async {
    if (user!.points! > requiredPoints ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Poin tidak cukup untuk klaim.")),
      );
      return;
    }

   final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Konfirmasi Penukaran"),
      content: Text("Apakah Anda yakin ingin menukar ${requiredPoints} poin untuk merchandise ini?"),
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
    Uri.parse('${Api.baseUrl}claim-merchandise'),
    body: {
      'id_pembeli': user!.id,
      'id_merchandise': id,
    },
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Klaim berhasil, silakan ambil di CS!")),
    );
    await loadMerchandise(); // Refresh list
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal klaim merchandise.")),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    
    return RefreshIndicator(
      onRefresh: loadMerchandise,
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
                    leading: const Icon(Icons.card_giftcard),
                    title: Text(item['nama_merchandise']),
                    subtitle: Text("Poin: ${item['poin']}"),
                    trailing: ElevatedButton(
                      onPressed: () => claimMerchandise(item['id_merchandise'], item['poin']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
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
