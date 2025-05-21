class FlightInfo {
  final String id;
  final String carrier;
  final String? carrierCode;
  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final String departureTime;
  final String arrivalTime;
  final String? returnDepartureTime;
  final String? returnArrivalTime;
  final String? returnDepartureAirport;
  final String? returnArrivalAirport;
  final String price;
  final String currency;

  FlightInfo({
    required this.id,
    required this.carrier,
    this.carrierCode,
    required this.flightNumber,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    this.returnDepartureTime,
    this.returnArrivalTime,
    this.returnDepartureAirport,
    this.returnArrivalAirport,
    required this.price,
    required this.currency,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      id: json['id'],
      carrier: json['carrier'],
      carrierCode: json['carrierCode'],
      flightNumber: json['flightNumber'],
      departureAirport: json['departureAirport'],
      arrivalAirport: json['arrivalAirport'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      returnDepartureTime: json['returnDepartureTime'],
      returnArrivalTime: json['returnArrivalTime'],
      returnDepartureAirport: json['returnDepartureAirport'],
      returnArrivalAirport: json['returnArrivalAirport'],
      price: json['price'],
      currency: json['currency'],
    );
  }
}
