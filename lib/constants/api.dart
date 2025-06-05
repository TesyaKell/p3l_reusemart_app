class Api {
  // Base URL
  static const String baseUrl =
      //ini jangan dihapus, dikomen aja kalau ga dipake
      'https://4e91-182-253-183-18.ngrok-free.app/api';
  //static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator

  // Auth endpoints
  static const String login = '$baseUrl/login-mobile';
  static const String logout = '$baseUrl/logout-mobile';
  static const String pengirimanKurir = '$baseUrl/pengiriman-kurir';
  static const String historyPengirimanKurir =
      '$baseUrl/history-pengiriman-kurir';
}
