class OrderResponse {
  final bool success;
  final List<Order> data;

  OrderResponse({required this.success, required this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => Order.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Order {
  final String noNota;
  final String? idKurirPegawai;
  final String idPembeli;
  final String tanggalPesan;
  final String? tanggalLunas;
  final String? tanggalAmbilKirim;
  final int tambahPoin;
  final int poinSebelum;
  final int poinSetelah;
  final String tipeDelivery;
  final int ongkir;
  final String alamatPengiriman;
  final int totalHargaJualBersih;
  final String? buktiPembayaran;
  final String status;
  final int komisiPenitip;
  final int totalPembayaran;
  final int tukarPoin;
  final List<DetailTransaksi> detailTransaksi;

  Order({
    required this.noNota,
    this.idKurirPegawai,
    required this.idPembeli,
    required this.tanggalPesan,
    this.tanggalLunas,
    this.tanggalAmbilKirim,
    required this.tambahPoin,
    required this.poinSebelum,
    required this.poinSetelah,
    required this.tipeDelivery,
    required this.ongkir,
    required this.alamatPengiriman,
    required this.totalHargaJualBersih,
    this.buktiPembayaran,
    required this.status,
    required this.komisiPenitip,
    required this.totalPembayaran,
    required this.tukarPoin,
    required this.detailTransaksi,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      noNota: json['no_nota'] ?? '',
      idKurirPegawai: json['id_kurir_pegawai'],
      idPembeli: json['id_pembeli'] ?? '',
      tanggalPesan: json['tanggal_pesan'] ?? '',
      tanggalLunas: json['tanggal_lunas'],
      tanggalAmbilKirim: json['tanggal_ambil_kirim'],
      tambahPoin: json['tambah_poin'] ?? 0,
      poinSebelum: json['poin_sebelum'] ?? 0,
      poinSetelah: json['poin_setelah'] ?? 0,
      tipeDelivery: json['tipe_delivery'] ?? '',
      ongkir: json['ongkir'] ?? 0,
      alamatPengiriman: json['alamat_pengiriman'] ?? '',
      totalHargaJualBersih: json['total_harga_jual_bersih'] ?? 0,
      buktiPembayaran: json['bukti_pembayaran'],
      status: json['status'] ?? '',
      komisiPenitip: json['komisi_penitip'] ?? 0,
      totalPembayaran: json['total_pembayaran'] ?? 0,
      tukarPoin: json['tukar_poin'] ?? 0,
      detailTransaksi:
          (json['detail_transaksi'] as List?)
              ?.map((item) => DetailTransaksi.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class DetailTransaksi {
  final int idDetailTransaksi;
  final String kodeBarang;
  final String noNota;
  final String namaBarang;
  final int hargaJualBersih;
  final int bonus;
  final int total;
  final int komisiReusmart;
  final int komisiHunter;
  final Barang barang;

  DetailTransaksi({
    required this.idDetailTransaksi,
    required this.kodeBarang,
    required this.noNota,
    required this.namaBarang,
    required this.hargaJualBersih,
    required this.bonus,
    required this.total,
    required this.komisiReusmart,
    required this.komisiHunter,
    required this.barang,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      idDetailTransaksi: json['id_detail_transaksi'] ?? 0,
      kodeBarang: json['kode_barang'] ?? '',
      noNota: json['no_nota'] ?? '',
      namaBarang: json['nama_barang'] ?? '',
      hargaJualBersih: json['harga_jual_bersih'] ?? 0,
      bonus: json['bonus'] ?? 0,
      total: json['total'] ?? 0,
      komisiReusmart: json['komisi_reusmart'] ?? 0,
      komisiHunter: json['komisi_hunter'] ?? 0,
      barang: Barang.fromJson(json['barang'] ?? {}),
    );
  }
}

class Barang {
  final String kodeBarang;
  final String idKategori;
  final String idPenitip;
  final String idHunterPegawai;
  final String namaBarang;
  final String deskripsi;
  final String status;
  final String? opsi;
  final int harga;
  final int garansi;
  final String tanggalMasuk;
  final String tanggalAkhir;
  final String tanggalBatas;
  final String? tanggalLaku;
  final String idQcPegawai;
  final String? tanggalAmbil;
  final int beratBarang;
  final List<String> fotoProduk;
  final String? batasGaransi;

  Barang({
    required this.kodeBarang,
    required this.idKategori,
    required this.idPenitip,
    required this.idHunterPegawai,
    required this.namaBarang,
    required this.deskripsi,
    required this.status,
    this.opsi,
    required this.harga,
    required this.garansi,
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
      kodeBarang: json['kode_barang'] ?? '',
      idKategori: json['id_kategori'] ?? '',
      idPenitip: json['id_penitip'] ?? '',
      idHunterPegawai: json['id_hunter_pegawai'] ?? '',
      namaBarang: json['nama_barang'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      status: json['status'] ?? '',
      opsi: json['opsi'],
      harga: json['harga'] ?? 0,
      garansi: json['garansi'] ?? 0,
      tanggalMasuk: json['tanggal_masuk'] ?? '',
      tanggalAkhir: json['tanggal_akhir'] ?? '',
      tanggalBatas: json['tanggal_batas'] ?? '',
      tanggalLaku: json['tanggal_laku'],
      idQcPegawai: json['id_qc_pegawai'] ?? '',
      tanggalAmbil: json['tanggal_ambil'],
      beratBarang: json['berat_barang'] ?? 0,
      // fotoProduk: json['foto_produk'] ?? '',
      fotoProduk: (json['foto_produk'] as List<dynamic>?) 
        ?.map((e) => e.toString()).toList() ?? [],
      batasGaransi: json['batas_garansi'],
    );
  }
}
