import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Riwayat Transaksi'),
      //   backgroundColor: Color(0xFFE9C8CE),
      // ),
      body: ListView.builder(
        itemCount: 5, // Ubah sesuai jumlah data riwayat
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text('Transaksi #${index + 1}'),
              subtitle: const Text('Tanggal: 2024-05-30\nTotal: Rp 120.000'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Arahkan ke detail riwayat jika perlu
              },
            ),
          );
        },
      ),
    );
  }
}
