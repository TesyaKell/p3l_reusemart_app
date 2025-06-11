class Api {
  // Base URL
  static const String baseUrlnon =
      // 'http://192.168.187.9:8000/';
      // 'http://192.168.8.151:8000';
      'http://192.168.89.47:8000';

  static const String baseUrl =
      //ini jangan dihapus, dikomen aja kalau ga dipake
      // 'https://4e91-182-253-183-18.ngrok-free.app/api';
      // 'http://192.168.187.9:8000/api';
      'http://192.168.8.151:8000/api';
      
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator

  // Auth endpoints
  static const String login = '$baseUrl/login-mobile';
  static const String logout = '$baseUrl/logout-mobile';
  static const String pengirimanKurir = '$baseUrl/pengiriman-kurir';
  static const String historyPengirimanKurir ='$baseUrl/history-pengiriman-kurir';
  static const String barangTersedia ='$baseUrl/home-barang';
  static const String historyKomisi ='$baseUrl/history-komisi/pegawai';
  static const String merchandise ='$baseUrl/merchandise';
  static const String claimMerchandise ='$baseUrl/claim-merchandise';
}
