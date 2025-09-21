import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entites.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final bool isSendingOtp;
  const AuthLoading({this.isSendingOtp = true});

  @override
  List<Object> get props => [isSendingOtp];
}

class AuthCodeSentSuccess extends AuthState {
  final String verificationId;
  final int? resendToken;

  const AuthCodeSentSuccess({required this.verificationId, this.resendToken});

  @override
  List<Object> get props => [verificationId, resendToken ?? 0];
}

class AuthLoggedInSuccess extends AuthState {
  final UserEntity user;
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
