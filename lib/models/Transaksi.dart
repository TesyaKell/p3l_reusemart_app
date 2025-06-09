class Transaksi {
  final String noNota;
  final String status;
  final String tanggalPesan;
  final double totalHarga;
  final List<DetailTransaksi> detailTransaksi;

  Transaksi({
    required this.noNota,
    required this.status,
    required this.tanggalPesan,
    required this.totalHarga,
    required this.detailTransaksi,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      noNota: json['no_nota'] ?? '',
      status: json['status'] ?? '',
      tanggalPesan: json['tanggal_pesan'] ?? '',
      totalHarga: (json['total_harga_jual_bersih'] ?? 0).toDouble(),
      detailTransaksi:
          (json['detail_transaksi'] as List<dynamic>?)
              ?.map((e) => DetailTransaksi.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DetailTransaksi {
  final String namaBarang;
  final int qty;
  final double harga;

  DetailTransaksi({
    required this.namaBarang,
    required this.qty,
    required this.harga,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      namaBarang: json['nama_barang'] ?? '',
      qty: json['qty'] ?? 0,
      harga: (json['harga'] ?? 0).toDouble(),
    );
  }
}
