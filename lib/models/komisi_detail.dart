class Komisi {
  final String namaBarang;
  final String noNota;
  final double komisi_hunter;
  final String tanggal;
  final int garansi;
  final List<String> foto; // changed from String to List<String>
  final String? batas_garansi;

  Komisi({
    required this.namaBarang,
    required this.noNota,
    required this.komisi_hunter,
    required this.tanggal,
    required this.garansi,
    this.batas_garansi,
    required this.foto,
  });

  factory Komisi.fromJson(Map<String, dynamic> json) {
    return Komisi(
      namaBarang: json['nama_barang'],
      noNota: json['no_nota'],
      komisi_hunter: json['komisi_hunter'],
      tanggal: json['tanggal'],
      batas_garansi: json['batas_garansi'],
      garansi: json['garansi'],
      foto: (json['foto_produk'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}

