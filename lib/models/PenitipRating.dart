class PenitipRating {
  final String name;
  final double averageRating;
  final int totalRatings;

  PenitipRating({
    required this.name,
    required this.averageRating,
    required this.totalRatings,
  });

  factory PenitipRating.fromJson(Map<String, dynamic> json) {
    return PenitipRating(
      name: json['nama_penitip'] ?? '', // Map 'nama_penitip' to 'name'
      averageRating:
          (json['average_rating'] is int
              ? json['average_rating'].toDouble()
              : json['average_rating']) ??
          0.0, // Handle int or double
      totalRatings: json['total_ratings'] ?? 0,
    );
  }
}
