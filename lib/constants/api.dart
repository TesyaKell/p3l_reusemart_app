class Api {
  // Base URL
  // static const String baseUrl =
  //     //ini jangan dihapus, dikomen aja kalau ga dipake
  //     'https://cb9d-2a09-bac1-34e0-18-00-3c3-45.ngrok-free.app/api';
  // //static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator

  static const String baseUrl =
      'https://reusemart-gpdrhhgtayafbfbm.indonesiacentral-01.azurewebsites.net/api';
  static const String nobase =
      'https://reusemart-gpdrhhgtayafbfbm.indonesiacentral-01.azurewebsites.net/';
  // Auth endpoints
  static const String login = '$baseUrl/login-mobile';
  static const String logout = '$baseUrl/logout-mobile';
  static const String pengirimanKurir = '$baseUrl/pengiriman-kurir';
  static const String historyPengirimanKurir =
      '$baseUrl/history-pengiriman-kurir';

  static const String barang = '$baseUrl/barang';
  static const String rating = '$baseUrl/topSeller';
  static const String riwayatPenitipan = '$baseUrl/riwayat-penitipan';
  static const String riwayatPembelian = '$baseUrl/riwayat-transaksi';
}
