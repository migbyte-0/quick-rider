import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [id, name, phoneNumber];
}
