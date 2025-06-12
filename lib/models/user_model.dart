class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int? points;
  final double? balance;
  final bool isTopSeller;
  final Map<String, dynamic> originalData; // Store original API data

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.points,
    this.balance,
    required this.isTopSeller,
    required this.originalData,
  });

  factory User.fromJson(Map<String, dynamic> json, String role) {
    if (role == 'penitip') {
      return User(
        id: json['id_penitip'] ?? '',
        name: json['nama_penitip'] ?? '',
        email: json['email'] ?? '',
        phone: json['no_telp'] ?? '',
        role: role,
        points: json['poin'] ?? 0,
        balance: (json['saldo'] ?? 0).toDouble(),
        isTopSeller: json['top_seller'] == 1,
        originalData: Map<String, dynamic>.from(json),
      );
    } else if (role == 'pembeli') {
      return User(
        id: json['id_pembeli'] ?? '',
        name: json['nama_pembeli'] ?? '',
        email: json['email'] ?? '',
        phone: json['no_telp'] ?? '',
        role: role,
        points: json['poin'] ?? 0,
        balance: (json['saldo'] ?? 0).toDouble(),
        isTopSeller: false,
        originalData: Map<String, dynamic>.from(json),
      );
    } else if (role == 'kurir' || role == 'hunter') {
      return User(
        id: json['id_pegawai'] ?? '',
        name: json['nama_pegawai'] ?? '',
        email: json['email'] ?? '',
        phone: json['no_telp'] ?? '',
        role: role,
        points: 0,
        balance: 0,
        isTopSeller: false,
        originalData: Map<String, dynamic>.from(json),
      );
    } else {
      // Default case for unknown roles
      return User(
        id: json['id'] ?? '',
        name: json['nama_pegawai'] ?? '',
        email: json['email'] ?? '',
        phone: json['no_telp'] ?? '',
        role: role,
        // points: 0,
        // balance: 0,
        isTopSeller: false,
        originalData: Map<String, dynamic>.from(json),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'points': points,
      'balance': balance,
      'isTopSeller': isTopSeller,
      'originalData': originalData,
    };
  }
}

class LoginResponse {
  final String message;
  final User user;
  final String token;
  final String role;

  LoginResponse({
    required this.message,
    required this.user,
    required this.token,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      user: User.fromJson(json['user'], json['role']),
      token: json['token'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
