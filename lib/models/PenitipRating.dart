class PenitipRating {
  final String name;
  final double averageRating;
  final int totalRatings;
  final double? totalPenjualan;
  final int? bonusPoin;

  PenitipRating({
    required this.name,
    required this.averageRating,
    required this.totalRatings,
    this.totalPenjualan,
    this.bonusPoin,
  });

  factory PenitipRating.fromJson(Map<String, dynamic> json) {
    return PenitipRating(
      name: json['nama_penitip'] ?? '',
      averageRating:
          (json['average_rating'] is int
              ? json['average_rating'].toDouble()
              : json['average_rating']) ??
          0.0,
      totalRatings: json['total_ratings'] ?? 0,
      totalPenjualan: (json['total_penjualan'] ?? 0).toDouble(),
      bonusPoin: json['bonus_poin'] ?? 0,
    );
  }
}
