import 'package:equatable/equatable.dart';

abstract class ProfileSetupState extends Equatable {
  const ProfileSetupState();

  @override
  List<Object> get props => [];
}

class ProfileSetupInitial extends ProfileSetupState {}

class ProfileSetupLoading extends ProfileSetupState {}

class ProfileSetupSuccess extends ProfileSetupState {}

class ProfileSetupFailure extends ProfileSetupState {
  final String message;

  const ProfileSetupFailure({required this.message});

  @override
  List<Object> get props => [message];
}
