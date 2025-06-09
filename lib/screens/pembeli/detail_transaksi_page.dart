import 'package:flutter/material.dart';
import '../../models/Transaksi.dart';

class DetailTransaksiPage extends StatelessWidget {
  final Transaksi transaksi;

  const DetailTransaksiPage({Key? key, required this.transaksi})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Transaksi ${transaksi.noNota}')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              'No Nota: ${transaksi.noNota}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Tanggal Pesan: ${transaksi.tanggalPesan}'),
            Text('Status: ${transaksi.status}'),
            Text('Total Pembayaran: Rp ${transaksi.totalPembayaran}'),
            Text('Ongkir: Rp ${transaksi.ongkir}'),
            if (transaksi.alamatPengiriman != null)
              Text('Alamat Pengiriman: ${transaksi.alamatPengiriman}'),
            const SizedBox(height: 16),
            const Text(
              'Detail Barang:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ...transaksi.detailTransaksi.map(
              (detail) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(detail.namaBarang),
                  subtitle: Text(
                    'Kode: ${detail.kodeBarang}\nHarga: Rp ${detail.hargaJualBersih.toStringAsFixed(0)}',
                  ),
                  trailing: Text(
                    'Total: Rp ${detail.total.toStringAsFixed(0)}',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
