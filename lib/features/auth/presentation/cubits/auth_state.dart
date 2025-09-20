part of 'auth_cubit.dart';

enum AuthStatus { initial, updated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.message = '',
  });

  final AuthStatus status;
  final String message;

  @override
  List<Object> get props => [status, message];
}

class AuthInitial extends AuthState {}

class AuthUpdated extends AuthState {
  final String message;

  AuthUpdated(this.message) : super(status: AuthStatus.updated, message: message);

  @override
  List<Object> get props => [message];
}
