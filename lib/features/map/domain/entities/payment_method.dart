import 'package:equatable/equatable.dart';

enum PaymentType { cash, creditCard }

class PaymentMethod extends Equatable {
  final String id;
  final PaymentType type;
  final String? lastFourDigits;
  final String? brand;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    this.lastFourDigits,
    this.brand,
    this.isDefault = false,
  });

  factory PaymentMethod.cash() {
    return const PaymentMethod(
      id: 'cash',
      type: PaymentType.cash,
      isDefault: true,
    );
  }

  factory PaymentMethod.creditCard({
    required String id,
    required String lastFourDigits,
    required String brand,
    bool isDefault = false,
  }) {
    return PaymentMethod(
      id: id,
      type: PaymentType.creditCard,
      lastFourDigits: lastFourDigits,
      brand: brand,
      isDefault: isDefault,
    );
  }

  @override
  List<Object?> get props => [id, type, lastFourDigits, brand, isDefault];
}
