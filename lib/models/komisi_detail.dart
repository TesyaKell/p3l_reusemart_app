class Komisi {
  final String namaBarang;
  final String noNota;
  final double komisi_hunter;
  final String tanggal;

  Komisi({
    required this.namaBarang,
    required this.noNota,
    required this.komisi_hunter,
    required this.tanggal,
  });

  factory Komisi.fromJson(Map<String, dynamic> json) {
    return Komisi(
      namaBarang: json['nama_barang'],
      noNota: json['no_nota'],
      komisi_hunter: json['komisi_hunter'],
      tanggal: json['tanggal'],
    );
  }
}

