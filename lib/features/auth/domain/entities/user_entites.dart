class UserEntity {
  final String id;
  final String phoneNumber;
  final String name;
  final String? city;
  UserEntity({
    required this.id,
    required this.phoneNumber,
    required this.name,
    this.city,
  });

  UserEntity copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? city,
  }) {
    return UserEntity(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      city: city ?? this.city,
    );
  }
}
