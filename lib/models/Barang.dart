class Barang {
  final String namaBarang;
  final String deskripsi;
  final List<dynamic> fotoProduk;
  final String status;

  Barang({
    required this.namaBarang,
    required this.deskripsi,
    required this.fotoProduk,
    required this.status,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      namaBarang: json['nama_barang'],
      deskripsi: json['deskripsi'],
      fotoProduk: List<String>.from(json['foto_produk']),
      status: json['status'],
    );
  }
}
