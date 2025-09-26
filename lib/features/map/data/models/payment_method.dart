
import '../../domain/entities/payment_method.dart'; // IMPORTANT: Import the entity here

class PaymentMethodModel extends PaymentMethod {
  const PaymentMethodModel({
    required super.id,
    required super.type,
    super.lastFourDigits,
    super.brand,
    super.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    final PaymentType type = json['type'] == 'cash'
        ? PaymentType.cash
        : PaymentType.creditCard;

    return PaymentMethodModel(
      id: json['id'] as String,
      type: type,
      lastFourDigits: json['lastFourDigits'] as String?,
      brand: json['brand'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'lastFourDigits': lastFourDigits,
      'brand': brand,
      'isDefault': isDefault,
    };
  }

  // Factory constructor for Cash (delegating to entity's factory for properties)
  factory PaymentMethodModel.cash() {
    return const PaymentMethodModel(
      id: 'cash',
      type: PaymentType.cash,
      isDefault: true,
    );
  }

  // Factory constructor for Credit Card (delegating to entity's factory for properties)
  factory PaymentMethodModel.creditCard({
    required String id,
    required String lastFourDigits,
    required String brand,
    bool isDefault = false,
  }) {
    return PaymentMethodModel(
      id: id,
      type: PaymentType.creditCard,
      lastFourDigits: lastFourDigits,
      brand: brand,
      isDefault: isDefault,
    );
  }

  // THIS IS THE CORRECT fromEntity for the MODEL, taking the DOMAIN ENTITY
  factory PaymentMethodModel.fromEntity(PaymentMethod entity) {
    return PaymentMethodModel(
      id: entity.id,
      type: entity.type,
      lastFourDigits: entity.lastFourDigits,
      brand: entity.brand,
      isDefault: entity.isDefault,
    );
  }
}
