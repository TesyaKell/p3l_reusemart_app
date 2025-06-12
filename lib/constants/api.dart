class Api {
  // Base URL
  // static const String baseUrl =
  //     //ini jangan dihapus, dikomen aja kalau ga dipake
  //     'https://cb9d-2a09-bac1-34e0-18-00-3c3-45.ngrok-free.app/api';
  // //static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator

  //static const String baseUrl = 'https://b103-2a09-bac5-39e2-1028-00-19c-8.ngrok-free.app/api';
  static const String nobase =
      'https://b103-2a09-bac5-39e2-1028-00-19c-8.ngrok-free.app';

  static const String baseUrlnon =
      // 'http://192.168.187.9:8000/';// puri phunix O
      // 'http://192.168.8.151:8000';// noni karmel
      'http://192.168.127.9:8000'; 
      // 'http://192.168.89.47:8000';

  static const String baseUrl =
      //ini jangan dihapus, dikomen aja kalau ga dipake
      // 'https://4e91-182-253-183-18.ngrok-free.app/api';
      // 'http://192.168.187.9:8000/api';
      'http://192.168.127.9:8000/api'; 
      // 'http://192.168.8.151:8000/api';//noni karmel
      
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator

  // Auth endpoints
  static const String login = '$baseUrl/login-mobile';
  static const String logout = '$baseUrl/logout-mobile';
  static const String pengirimanKurir = '$baseUrl/pengiriman-kurir';
  static const String historyPengirimanKurir =
      '$baseUrl/history-pengiriman-kurir';

  static const String barang = '$nobase/barang';
  static const String rating = '$nobase/topSeller';
  static const String riwayatPenitipan = '$nobase/riwayat-penitipan';
  static const String barangTersedia ='$baseUrl/home-barang';
  static const String historyKomisi ='$baseUrl/history-komisi/hunter';
  static const String merchandise ='$baseUrl/merchandise';
  static const String claimMerchandise ='$baseUrl/claim-merchandise';
}
