import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entites.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCodeSentSuccess extends AuthState {}

class AuthLoggedInSuccess extends AuthState {
  final User user;
  const AuthLoggedInSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}
