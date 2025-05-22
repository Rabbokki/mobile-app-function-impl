class TravelPlanRequest {
  final String city;
  final String country;
  final String startDate;
  final String endDate;
  final String planType;
  final int? travelPlanId;
  final List<PlaceDto> places;
  final List<AccommodationDto> accommodations;
  final List<TransportationDto> transportations;

  TravelPlanRequest({
    required this.city,
    required this.country,
    required this.startDate,
    required this.endDate,
    this.planType = "MY",
    this.travelPlanId,
    this.places = const [],
    this.accommodations = const [],
    this.transportations = const [],
  });

  Map<String, dynamic> toJson() => {
    "city": city,
    "country": country,
    "start_date": startDate,
    "end_date": endDate,
    "plan_type": planType,
    if (travelPlanId != null) "travelPlanId": travelPlanId,
    "places": places.map((e) => e.toJson()).toList(),
    "accommodations": accommodations.map((e) => e.toJson()).toList(),
    "transportations": transportations.map((e) => e.toJson()).toList(),
  };
}

class PlaceDto {
  final String name;
  final String address;
  final int day;
  final String? category;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? time; // "HH:mm"

  PlaceDto({
    required this.name,
    required this.address,
    required this.day,
    this.category,
    this.description,
    this.latitude,
    this.longitude,
    this.time,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "day": day,
    "category": category,
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "time": time,
  };
}

class AccommodationDto {
  final String name;
  final String address;
  final int day;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? checkInDate; // "yyyy-MM-ddTHH:mm:ss"
  final String? checkOutDate;

  AccommodationDto({
    required this.name,
    required this.address,
    required this.day,
    this.description,
    this.latitude,
    this.longitude,
    this.checkInDate,
    this.checkOutDate,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "day": day,
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "checkInDate": checkInDate,
    "checkOutDate": checkOutDate,
  };
}

class TransportationDto {
  final String type; // "SUBWAY", "BUS", ...
  final int day;

  TransportationDto({
    required this.type,
    required this.day,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "day": day,
  };
}
