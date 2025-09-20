part of 'splash_cubit.dart';

import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashNavigate extends SplashState {
  final String routeName;

  const SplashNavigate(this.routeName);

  @override
  List<Object> get props => [routeName];
}
