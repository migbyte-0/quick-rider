import 'package:flutter/material.dart';

@immutable
abstract class LanguageState {
  final Locale locale;

  const LanguageState(this.locale);
}

class LanguageLoaded extends LanguageState {
  const LanguageLoaded(super.locale);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageLoaded &&
          runtimeType == other.runtimeType &&
          locale == other.locale;

  @override
  int get hashCode => locale.hashCode;
}
