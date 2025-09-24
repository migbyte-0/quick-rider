import 'package:quickrider/features/payment/domain/entities/credit_card_entity.dart';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CreditCardModel {
  final String id;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String? cvvCode;
  final String bankName;
  final String cardType;
  final bool isDefault;

  CreditCardModel({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    this.cvvCode,
    this.bankName = '',
    this.cardType = '',
    this.isDefault = false,
  });

  CreditCardEntity toEntity() {
    return CreditCardEntity(
      id: id,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      bankName: bankName,
      cardType: cardType,
      isDefault: isDefault,
    );
  }

  factory CreditCardModel.fromEntity(CreditCardEntity entity,
      {String? entityCvvCode}) {
    return CreditCardModel(
      id: entity.id,
      cardNumber: entity.cardNumber,
      expiryDate: entity.expiryDate,
      cardHolderName: entity.cardHolderName,
      cvvCode: entityCvvCode,
      bankName: entity.bankName,
      cardType: entity.cardType,
      isDefault: entity.isDefault,
    );
  }

  CreditCardModel copyWith({
    String? id,
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    String? cvvCode,
    String? bankName,
    String? cardType,
    bool? isDefault,
  }) {
    return CreditCardModel(
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
}
