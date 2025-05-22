class RecommendedPlace {
  final String id;
  final String name;
  final String address;
  final double rating;
  final String image;
  final String category;
  final String city;
  final String cityId;
  final int reviewCount;
  final String placeId;

  RecommendedPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.image,
    required this.category,
    required this.city,
    required this.cityId,
    required this.reviewCount,
    required this.placeId,
  });

  factory RecommendedPlace.fromJson(Map<String, dynamic> json) {
    return RecommendedPlace(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      city: json['city'] ?? '',
      cityId: json['cityId'] ?? '',
      reviewCount: json['reviewCount'] ?? 0,
      placeId: json['placeId'] ?? '',
    );
  }
}
