import 'package:flutter/material.dart';
// Update the import path below if the file exists elsewhere, for example:
import '../../models/Transaksi.dart';

class HistoryTransaksiPage extends StatelessWidget {
  final List<Transaksi> transaksiList;

  const HistoryTransaksiPage({required this.transaksiList, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transaksiList.isEmpty) {
      return Center(child: Text('Belum ada riwayat transaksi'));
    }

    return ListView.builder(
      itemCount: transaksiList.length,
      itemBuilder: (context, index) {
        final transaksi = transaksiList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ExpansionTile(
            title: Text('No Nota: ${transaksi.noNota}'),
            subtitle: Text(
              'Tanggal: ${transaksi.tanggalPesan}\nStatus: ${transaksi.status}',
            ),
            trailing: Text(
              'Rp ${transaksi.totalHarga.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaksi.status.toLowerCase() == 'batal'
                    ? Colors.red
                    : Colors.green,
              ),
            ),
            children: transaksi.detailTransaksi.map((detail) {
              return ListTile(
                title: Text(detail.namaBarang),
                subtitle: Text('Qty: ${detail.qty}'),
                trailing: Text('Rp ${detail.harga.toStringAsFixed(0)}'),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
