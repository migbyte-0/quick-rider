import '../../../auth/domain/entities/user_entites.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.phoneNumber,
    required super.name,
    super.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'phoneNumber': phoneNumber, 'name': name, 'city': city};
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      phoneNumber: entity.phoneNumber,
      name: entity.name,
      city: entity.city,
    );
  }
}
