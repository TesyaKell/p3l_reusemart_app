class Api {
  // Base URL
  static const String baseUrl = 'http://192.168.18.104:8000/api';
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator

  // Auth endpoints
  static const String login = '$baseUrl/login-mobile';
  static const String logout = '$baseUrl/logout-mobile';
  static const String pengirimanKurir = '$baseUrl/pengiriman-kurir';
  static const String historyPengirimanKurir =
      '$baseUrl/history-pengiriman-kurir';
}
