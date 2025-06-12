class Api {
  // Base URL

  static const String baseIP =
      // '192.168.187.9/';// puri phunix O
      '192.168.8.151';// noni karmel
      // '10.53.10.204'; //atma spot
      // '192.168.89.47'; //Gen0xD
  static const String baseUrlnon =
      // 'http://192.168.187.9:8000/';// puri phunix O
      // 'http://192.168.8.151:8000';// noni karmel
      'http://$baseIP:8000'; //atma spot
      // 'http://192.168.89.47:8000';

  static const String baseUrl =
      //ini jangan dihapus, dikomen aja kalau ga dipake
      // 'https://4e91-182-253-183-18.ngrok-free.app/api';
      // 'http://192.168.187.9:8000/api';
      'http://$baseIP:8000/api'; //atma spot
      // 'http://192.168.8.151:8000/api';//noni karmel
      
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator

  // Auth endpoints
  static const String login = '$baseUrl/login-mobile';
  static const String logout = '$baseUrl/logout-mobile';
  static const String pengirimanKurir = '$baseUrl/pengiriman-kurir';
  static const String historyPengirimanKurir ='$baseUrl/history-pengiriman-kurir';
  static const String barangTersedia ='$baseUrl/home-barang';
  static const String historyKomisi ='$baseUrl/history-komisi/hunter';
  static const String merchandise ='$baseUrl/merchandise';
  static const String claimMerchandise ='$baseUrl/claim-merchandise';
}
