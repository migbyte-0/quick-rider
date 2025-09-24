import 'package:equatable/equatable.dart';
import 'package:quickrider/features/payment/domain/entities/credit_card_entity.dart';

enum PaymentMethodType { card, cash }

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class AddCardLoading extends PaymentState {}

class AddCardSuccess extends PaymentState {}

class AddCardFailure extends PaymentState {
  final String message;
  const AddCardFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class PaymentMethodsLoaded extends PaymentState {
  final List<CreditCardEntity> savedCards;
  final PaymentMethodType selectedPaymentMethodType;
  final CreditCardEntity? selectedCard;

  const PaymentMethodsLoaded({
    this.savedCards = const [],
    this.selectedPaymentMethodType = PaymentMethodType.cash,
    this.selectedCard,
  });

  PaymentMethodsLoaded copyWith({
    List<CreditCardEntity>? savedCards,
    PaymentMethodType? selectedPaymentMethodType,
    CreditCardEntity? selectedCard,
  }) {
    return PaymentMethodsLoaded(
      savedCards: savedCards ?? this.savedCards,
      selectedPaymentMethodType:
          selectedPaymentMethodType ?? this.selectedPaymentMethodType,
      selectedCard: selectedCard,
    );
  }

  @override
  List<Object> get props => [
    savedCards,
    selectedPaymentMethodType,
    selectedCard ?? Object(),
  ];
}

class PaymentMethodsLoading extends PaymentState {}

class PaymentMethodsError extends PaymentState {
  final String message;
  const PaymentMethodsError({required this.message});
  @override
  List<Object> get props => [message];
}
