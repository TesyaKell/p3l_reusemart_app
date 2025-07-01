class Barang {
  final String kodeBarang;
  final String idKategori;
  final String idPenitip;
  final String? idHunterPegawai;
  final String namaBarang;
  final String deskripsi;
  final String status;
  final String? opsi;
  final double harga;
  final int? garansi;
  final DateTime tanggalMasuk;
  final DateTime tanggalAkhir;
  final DateTime tanggalBatas;
  final DateTime? tanggalLaku;
  final String idQcPegawai;
  final DateTime? tanggalAmbil;
  final int beratBarang;
  final List<String> fotoProduk;
  final DateTime? batasGaransi;

  Barang({
    required this.kodeBarang,
    required this.idKategori,
    required this.idPenitip,
    this.idHunterPegawai,
    required this.namaBarang,
    required this.deskripsi,
    required this.status,
    this.opsi,
    required this.harga,
    this.garansi,
    required this.tanggalMasuk,
    required this.tanggalAkhir,
    required this.tanggalBatas,
    this.tanggalLaku,
    required this.idQcPegawai,
    this.tanggalAmbil,
    required this.beratBarang,
    required this.fotoProduk,
    this.batasGaransi,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      kodeBarang: json['kode_barang'],
      idKategori: json['id_kategori'],
      idPenitip: json['id_penitip'],
      idHunterPegawai: json['id_hunter_pegawai'],
      namaBarang: json['nama_barang'],
      deskripsi: json['deskripsi'],
      status: json['status'],
      opsi: json['opsi'],
      harga: (json['harga'] as num).toDouble(),
      garansi: json['garansi'],
      tanggalMasuk: DateTime.parse(json['tanggal_masuk']),
      tanggalAkhir: DateTime.parse(json['tanggal_akhir']),
      tanggalBatas: DateTime.parse(json['tanggal_batas']),
      tanggalLaku: json['tanggal_laku'] != null
          ? DateTime.parse(json['tanggal_laku'])
          : null,
      idQcPegawai: json['id_qc_pegawai'],
      tanggalAmbil: json['tanggal_ambil'] != null
          ? DateTime.parse(json['tanggal_ambil'])
          : null,
      beratBarang: json['berat_barang'],
      fotoProduk: json['foto_produk'] != null
          ? List<String>.from(json['foto_produk'])
          : [],
      batasGaransi: json['batas_garansi'] != null
          ? DateTime.parse(json['batas_garansi'])
          : null,
    );
  }
}
