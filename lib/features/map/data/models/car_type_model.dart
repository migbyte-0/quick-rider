import '../../domain/entities/car_type.dart';

class CarTypeModel extends CarType {
  const CarTypeModel({
    required super.id,
    required super.name,
    required super.minPrice,
    required super.maxPrice,
    required super.seats,
    required super.imageUrl,
    required super.etaMinutes,
  });

  factory CarTypeModel.fromJson(Map<String, dynamic> json) {
    return CarTypeModel(
      id: json['id'],
      name: json['name'],
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
      seats: json['seats'],
      imageUrl: json['image_url'],
      etaMinutes: json['eta_minutes'],
    );
  }

  factory CarTypeModel.fromEntity(CarType carType) {
    return CarTypeModel(
      id: carType.id,
      name: carType.name,
      minPrice: carType.minPrice,
      maxPrice: carType.maxPrice,
      seats: carType.seats,
      imageUrl: carType.imageUrl,
      etaMinutes: carType.etaMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'min_price': minPrice,
      'max_price': maxPrice,
      'seats': seats,
      'image_url': imageUrl,
      'eta_minutes': etaMinutes,
    };
  }
}
