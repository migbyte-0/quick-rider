import 'package:equatable/equatable.dart';

class CreditCardEntity extends Equatable {
  final String id;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String? cvvCode;
  final String bankName;
  final String cardType;
  final bool isDefault;

  const CreditCardEntity({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    this.cvvCode,
    this.bankName = '',
    this.cardType = '',
    this.isDefault = false,
  });

  CreditCardEntity copyWith({
    String? id,
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    String? cvvCode,
    String? bankName,
    String? cardType,
    bool? isDefault,
  }) {
    return CreditCardEntity(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cvvCode: cvvCode ?? this.cvvCode,
      bankName: bankName ?? this.bankName,
      cardType: cardType ?? this.cardType,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
        id,
        cardNumber,
        expiryDate,
        cardHolderName,
        bankName,
        cardType,
        isDefault,
      ];
}
