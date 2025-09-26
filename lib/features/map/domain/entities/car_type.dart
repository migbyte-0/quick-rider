import 'package:equatable/equatable.dart';

class CarType extends Equatable {
  final String id;
  final String name;
  final int minPrice;
  final int maxPrice;
  final int seats;
  final String imageUrl; // Asset path for the car image
  final int etaMinutes; // Estimated time of arrival for this car type

  const CarType({
    required this.id,
    required this.name,
    required this.minPrice,
    required this.maxPrice,
    required this.seats,
    required this.imageUrl,
    required this.etaMinutes,
  });

  @override
  List<Object?> get props =>
      [id, name, minPrice, maxPrice, seats, imageUrl, etaMinutes];
}
