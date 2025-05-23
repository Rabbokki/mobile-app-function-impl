class SavedPlace {
  final String placeId;
  final String name;
  final String address;
  final String city;
  final String category;

  SavedPlace({
    required this.placeId,
    required this.name,
    required this.address,
    required this.city,
    required this.category,
  });

  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      placeId: json['placeId'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      category: json['category'],
    );
  }
}
