import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickrider/features/payment/presentation/cubits/payment_state.dart';

import 'package:uuid/uuid.dart';

import 'package:quickrider/services/logger_services.dart';

import '../../domain/domain_exports.dart';

import '../../domain/usecases/set_default_credit_card_usecase.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final SaveCreditCardUseCase saveCreditCardUseCase;
  final GetCreditCardsUseCase getCreditCardsUseCase;
  final SetDefaultCreditCardUseCase setDefaultCreditCardUseCase;
  final RemoveCreditCardUseCase removeCreditCardUseCase;

  final AppLogger logger;
  final Uuid _uuid = const Uuid();

  PaymentCubit({
    required this.saveCreditCardUseCase,
    required this.getCreditCardsUseCase,
    required this.setDefaultCreditCardUseCase,
    required this.removeCreditCardUseCase,
    required this.logger,
  }) : super(
          const PaymentMethodsLoaded(),
        );

  final List<CreditCardEntity> _inMemorySavedCards = [];

  Future<void> loadPaymentMethods() async {
    logger.i('Loading payment methods...');
    emit(PaymentMethodsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      CreditCardEntity? initialSelectedCard;
      PaymentMethodType initialSelectedPaymentMethodType =
          PaymentMethodType.cash;

      if (_inMemorySavedCards.isNotEmpty) {
        initialSelectedCard = _inMemorySavedCards.firstWhere(
          (card) => card.isDefault,
          orElse: () => _inMemorySavedCards.first,
        );
        initialSelectedPaymentMethodType = PaymentMethodType.card;
        logger.d(
            'Loaded ${_inMemorySavedCards.length} cards. Selected card: ****${initialSelectedCard.cardNumber.substring(initialSelectedCard.cardNumber.length - 4)}');
      } else {
        logger.d('No saved cards found. Defaulting to Cash payment.');
      }

      emit(
        PaymentMethodsLoaded(
          savedCards: List.from(_inMemorySavedCards),
          selectedPaymentMethodType: initialSelectedPaymentMethodType,
          selectedCard: initialSelectedCard,
        ),
      );
      logger.i('Payment methods loaded successfully.');
    } catch (e, st) {
      logger.e('Failed to load payment methods.', error: e, stackTrace: st);
      emit(
        const PaymentMethodsError(message: 'Failed to load payment methods.'),
      );
    }
  }

  Future<void> saveNewCard(CreditCardEntity newCardDetails) async {
    logger.i('Attempting to save a new card...');
    emit(AddCardLoading());

    final cardToSave = CreditCardEntity(
      id: _uuid.v4(),
      cardNumber: newCardDetails.cardNumber,
      expiryDate: newCardDetails.expiryDate,
      cardHolderName: newCardDetails.cardHolderName,
      cvvCode: newCardDetails.cvvCode,
      bankName: newCardDetails.bankName,
      cardType: newCardDetails.cardType,
      isDefault: _inMemorySavedCards.isEmpty ? true : false,
    );

    final result = await saveCreditCardUseCase(cardToSave);
    result.fold(
      (failure) {
        logger.w('Failed to save new card: ${failure.message}');
        emit(AddCardFailure(message: failure.message));
        loadPaymentMethods();
      },
      (_) {
        if (_inMemorySavedCards.isEmpty) {
          _inMemorySavedCards.add(cardToSave.copyWith(isDefault: true));
        } else {
          _inMemorySavedCards.add(cardToSave);
        }

        logger.i(
            'New card saved successfully: ****${cardToSave.cardNumber.substring(cardToSave.cardNumber.length - 4)}');
        emit(AddCardSuccess());

        emit(
          PaymentMethodsLoaded(
            savedCards: List.from(_inMemorySavedCards),
            selectedPaymentMethodType: PaymentMethodType.card,
            selectedCard: cardToSave,
          ),
        );
        logger.d('Payment methods state updated after new card added.');
      },
    );
  }

  void selectPaymentMethodType(PaymentMethodType type) {
    logger.d('Selecting payment method type: $type');
    if (state is PaymentMethodsLoaded) {
      final currentState = state as PaymentMethodsLoaded;
      emit(
        currentState.copyWith(
          selectedPaymentMethodType: type,
          selectedCard:
              type == PaymentMethodType.cash ? null : currentState.selectedCard,
        ),
      );
    } else {
      logger.w(
        'Attempted to select payment method type from an invalid state: $state',
      );
    }
  }

  void selectCard(CreditCardEntity card) {
    logger.d(
        'Selecting card: ****${card.cardNumber.substring(card.cardNumber.length - 4)}');
    if (state is PaymentMethodsLoaded) {
      final currentState = state as PaymentMethodsLoaded;
      emit(
        currentState.copyWith(
          selectedCard: card,
          selectedPaymentMethodType: PaymentMethodType.card,
        ),
      );
    } else {
      logger.w('Attempted to select card from an invalid state: $state');
    }
  }

  Future<void> setDefaultCard(String cardId) async {
    logger.i('Attempting to set card $cardId as default...');
    if (state is PaymentMethodsLoaded) {
      emit(PaymentMethodsLoading());

      try {
        await Future.delayed(const Duration(milliseconds: 500));

        for (var i = 0; i < _inMemorySavedCards.length; i++) {
          final card = _inMemorySavedCards[i];
          _inMemorySavedCards[i] = card.copyWith(isDefault: card.id == cardId);
        }

        final newDefaultCard =
            _inMemorySavedCards.firstWhere((card) => card.id == cardId);

        logger.d('Card $cardId set as default (mock).');

        emit(
          PaymentMethodsLoaded(
            savedCards: List.from(_inMemorySavedCards),
            selectedCard: newDefaultCard, // Select the new default card
            selectedPaymentMethodType: PaymentMethodType.card,
          ),
        );
      } catch (e, st) {
        logger.e('Failed to set default card.', error: e, stackTrace: st);
        emit(
          const PaymentMethodsError(message: 'Failed to set default card.'),
        );
        loadPaymentMethods(); // Reload to revert to previous state
      }
    } else {
      logger.w('Attempted to set default card from an invalid state: $state');
      loadPaymentMethods();
    }
  }

  Future<void> removeCard(String cardId) async {
    logger.i('Attempting to remove card with ID: $cardId');
    if (state is PaymentMethodsLoaded) {
      final currentState = state as PaymentMethodsLoaded;
      emit(PaymentMethodsLoading());

      await Future.delayed(const Duration(seconds: 1));
      final originalLength = _inMemorySavedCards.length;
      final wasDefault = _inMemorySavedCards
          .firstWhere((card) => card.id == cardId,
              orElse: () => throw Exception('Card not found for default check'))
          .isDefault;

      _inMemorySavedCards.removeWhere((card) => card.id == cardId);

      if (_inMemorySavedCards.length < originalLength) {
        logger.d('Card $cardId removed successfully (mock).');
        CreditCardEntity? newSelectedCard;
        PaymentMethodType newSelectedMethodType = PaymentMethodType.cash;

        // If the removed card was the default, and other cards exist, set a new default
        if (wasDefault && _inMemorySavedCards.isNotEmpty) {
          final firstCard = _inMemorySavedCards.first;
          _inMemorySavedCards[_inMemorySavedCards.indexOf(firstCard)] =
              firstCard.copyWith(isDefault: true);
          newSelectedCard = firstCard.copyWith(isDefault: true);
          newSelectedMethodType = PaymentMethodType.card;
          logger.d(
              'Removed default card, set first remaining card as new default.');
        } else if (_inMemorySavedCards.isNotEmpty) {
          // If the removed card was not default, keep the current default/selected if it still exists
          newSelectedCard = currentState.selectedCard != null &&
                  _inMemorySavedCards
                      .any((card) => card.id == currentState.selectedCard!.id)
              ? currentState.selectedCard
              : _inMemorySavedCards.firstWhere((card) => card.isDefault,
                  orElse: () => _inMemorySavedCards.first);
          newSelectedMethodType = PaymentMethodType.card;
        } else {
          logger.d('No cards remaining after removal. Defaulting to Cash.');
        }

        emit(
          PaymentMethodsLoaded(
            savedCards: List.from(_inMemorySavedCards),
            selectedCard: newSelectedCard,
            selectedPaymentMethodType: newSelectedMethodType,
          ),
        );
      } else {
        logger.w('Card with ID $cardId not found for removal (mock)..');
        emit(PaymentMethodsError(message: 'Card with ID $cardId not found.'));
        loadPaymentMethods(); // Reload to revert to previous state
      }
    } else {
      logger.w('Attempted to remove card from an invalid state: $state');
      loadPaymentMethods();
    }
  }
}
