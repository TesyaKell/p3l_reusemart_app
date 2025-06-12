class Transaksi {
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
  final String? alamatPengiriman;
  final double totalHargaJualBersih;
  final String? buktiPembayaran;
  final String status;
  final int totalPembayaran;
  final int? tukarPoin;
  final List<DetailTransaksi> detailTransaksi;

  Transaksi({
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
    this.alamatPengiriman,
    required this.totalHargaJualBersih,
    this.buktiPembayaran,
    required this.status,
    required this.totalPembayaran,
    this.tukarPoin,
    required this.detailTransaksi,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    var listDetail = json['detail_transaksi'] as List;
    List<DetailTransaksi> details = listDetail
        .map((i) => DetailTransaksi.fromJson(i))
        .toList();

    return Transaksi(
      noNota: json['no_nota'],
      idKurirPegawai: json['id_kurir_pegawai'],
      idPembeli: json['id_pembeli'],
      tanggalPesan: json['tanggal_pesan'],
      tanggalLunas: json['tanggal_lunas'],
      tanggalAmbilKirim: json['tanggal_ambil_kirim'],
      tambahPoin: json['tambah_poin'],
      poinSebelum: json['poin_sebelum'],
      poinSetelah: json['poin_setelah'],
      tipeDelivery: json['tipe_delivery'],
      ongkir: json['ongkir'],
      alamatPengiriman: json['alamat_pengiriman'],
      totalHargaJualBersih: (json['total_harga_jual_bersih'] as num).toDouble(),
      buktiPembayaran: json['bukti_pembayaran'],
      status: json['status'],
      totalPembayaran: json['total_pembayaran'],
      tukarPoin: json['tukar_poin'],
      detailTransaksi: details,
    );
  }
}

class DetailTransaksi {
  final int idDetailTransaksi;
  final String kodeBarang;
  final String noNota;
  final String namaBarang;
  final double hargaJualBersih;
  final double bonus;
  final double total;
  final double komisiReusmart;
  final double? komisiHunter;
  final double? komisiPenitip;

  DetailTransaksi({
    required this.idDetailTransaksi,
    required this.kodeBarang,
    required this.noNota,
    required this.namaBarang,
    required this.hargaJualBersih,
    required this.bonus,
    required this.total,
    required this.komisiReusmart,
    this.komisiHunter,
    this.komisiPenitip,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic val) {
      if (val == null) return null;
      if (val is int) return val.toDouble();
      if (val is double) return val;
      return double.tryParse(val.toString());
    }

    return DetailTransaksi(
      idDetailTransaksi: json['id_detail_transaksi'],
      kodeBarang: json['kode_barang'],
      noNota: json['no_nota'],
      namaBarang: json['nama_barang'],
      hargaJualBersih: parseDouble(json['harga_jual_bersih']) ?? 0.0,
      bonus: parseDouble(json['bonus']) ?? 0.0,
      total: parseDouble(json['total']) ?? 0.0,
      komisiReusmart: parseDouble(json['komisi_reusmart']) ?? 0.0,
      komisiHunter: parseDouble(json['komisi_hunter']),
      komisiPenitip: parseDouble(json['komisi_penitip']),
    );
  }
}
