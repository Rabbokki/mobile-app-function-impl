class FlightInfo {
  final String id;
  final String departureAirport;
  final String arrivalAirport;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String price;
  final String currency;
  final String carrier;
  final String flightNumber;
  final String? returnDepartureTime;
  final String? returnArrivalTime;

  FlightInfo({
    required this.id,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.currency,
    required this.carrier,
    required this.flightNumber,
    this.returnDepartureTime,
    this.returnArrivalTime,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      id: json['id'],
      departureAirport: json['departureAirport'],
      arrivalAirport: json['arrivalAirport'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      duration: json['duration'],
      price: json['price'],
      currency: json['currency'],
      carrier: json['carrier'],
      flightNumber: json['flightNumber'],
      returnDepartureTime: json['returnDepartureTime'],
      returnArrivalTime: json['returnArrivalTime'],
    );
  }
}
