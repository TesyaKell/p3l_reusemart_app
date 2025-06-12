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
                    subtitle: Text("Poin: ${item['poin']}"),
                    trailing: ElevatedButton(
                      onPressed: () {},
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
