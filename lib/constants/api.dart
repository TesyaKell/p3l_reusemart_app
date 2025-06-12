class Api {
  // Base URL
  // static const String baseUrl =
  //     //ini jangan dihapus, dikomen aja kalau ga dipake
  //     'https://cb9d-2a09-bac1-34e0-18-00-3c3-45.ngrok-free.app/api';
  // //static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator

  static const String baseUrl = 'http://10.32.254.113:8000/api';
  static const String nobase = 'http://10.32.254.113:8000';
  // Auth endpoints
  static const String login = '$baseUrl/login-mobile';
  static const String logout = '$baseUrl/logout-mobile';
  static const String pengirimanKurir = '$baseUrl/pengiriman-kurir';
  static const String historyPengirimanKurir =
      '$baseUrl/history-pengiriman-kurir';

  static const String barang = '$nobase/barang';
  static const String rating = '$nobase/topSeller';
  static const String riwayatPenitipan = '$nobase/riwayat-penitipan';
}
